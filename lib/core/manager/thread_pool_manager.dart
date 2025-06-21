import 'dart:async';
import 'dart:isolate';
import 'package:flutter/services.dart';

class ThreadPoolManager {
  late Isolate _databaseIsolate;
  late Isolate _algorithmIsolate;
  late Isolate _otherIsolate;
  late SendPort _databaseSendPort;
  late SendPort _algorithmSendPort;
  late SendPort _otherSendPort;
  final RootIsolateToken _rootIsolateToken;
  
  bool _isInitialized = false;
  final Completer<void> _initializationCompleter = Completer<void>();

  /// singleton
  ThreadPoolManager._internal(this._rootIsolateToken);
  factory ThreadPoolManager() => sharedInstance;
  static final ThreadPoolManager sharedInstance =
  ThreadPoolManager._internal(RootIsolateToken.instance!);

  bool get isInitialized => _isInitialized;

  Future<void> initialize() async {
    if (_isInitialized) {
      return;
    }
    
    try {
      _databaseSendPort = await _createIsolate((sendPort) {
        _databaseIsolate = sendPort.isolate;
        return sendPort.sendPort;
      });
      _algorithmSendPort = await _createIsolate((sendPort) {
        _algorithmIsolate = sendPort.isolate;
        return sendPort.sendPort;
      });
      _otherSendPort = await _createIsolate((sendPort) {
        _otherIsolate = sendPort.isolate;
        return sendPort.sendPort;
      });
      
      _isInitialized = true;
      _initializationCompleter.complete();
    } catch (error) {
      _initializationCompleter.completeError(error);
      rethrow;
    }
  }

  Future<SendPort> _createIsolate(Function(IsolateConfig) isolateConfig) async {
    final receivePort = ReceivePort();
    final isolate = await Isolate.spawn(_isolateEntry, receivePort.sendPort);
    final sendPort = await receivePort.first as SendPort;
    isolateConfig(IsolateConfig(isolate, sendPort));
    return sendPort;
  }

  Future<dynamic> _runTask(
      Future<dynamic> Function() task, SendPort sendPort) async {
    final completer = Completer<dynamic>();
    final port = ReceivePort();
    sendPort.send([task, port.sendPort, _rootIsolateToken]);
    port.listen((message) {
      port.close(); // Close the port once the task is completed
      completer.complete(message);
    });
    return completer.future;
  }

  Future<dynamic> runDatabaseTask(Future<dynamic> Function() task) async {
    await _ensureInitialized();
    return _runTask(task, _databaseSendPort);
  }

  Future<dynamic> runAlgorithmTask(Future<dynamic> Function() task) async {
    await _ensureInitialized();
    return _runTask(task, _algorithmSendPort);
  }

  Future<dynamic> runOtherTask(Future<dynamic> Function() task) async {
    await _ensureInitialized();
    return _runTask(task, _otherSendPort);
  }

  Future<void> _ensureInitialized() async {
    if (!_isInitialized) {
      print('ThreadPoolManager not initialized. Waiting for the initialization to complete...');
      await _initializationCompleter.future;
    }
  }

  void dispose() {
    _databaseIsolate.kill(priority: Isolate.immediate);
    _algorithmIsolate.kill(priority: Isolate.immediate);
    _otherIsolate.kill(priority: Isolate.immediate);
  }
}

class IsolateConfig {
  Isolate isolate;
  SendPort sendPort;
  IsolateConfig(this.isolate, this.sendPort);
}

void _isolateEntry(SendPort sendPort) {
  final port = ReceivePort();
  sendPort.send(port.sendPort);
  port.listen((message) async {
    if (message is List && message.length == 3) {
      final task = message[0] as Future Function();
      final replyPort = message[1] as SendPort;
      final rootIsolateToken = message[2] as RootIsolateToken;
      try {
        // Attach root isolate token to the current isolate
        BackgroundIsolateBinaryMessenger.ensureInitialized(rootIsolateToken);
        final result = await task();
        replyPort.send(result);
      } catch (e, stackTrace) {
        print('_isolateEntry Error: $e\n$stackTrace');
        replyPort.send("Error: $e");
      }
    }
  });
}
