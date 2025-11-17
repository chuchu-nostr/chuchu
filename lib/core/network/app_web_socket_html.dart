import 'dart:async';

import 'package:web_socket_channel/html.dart';

import 'app_web_socket_interface.dart';

class HtmlAppWebSocket implements AppWebSocket {
  final HtmlWebSocketChannel _channel;
  final StreamController<dynamic> _controller = StreamController<dynamic>.broadcast();
  final Completer<void> _doneCompleter = Completer<void>();

  HtmlAppWebSocket._(this._channel) {
    _channel.stream.listen((event) {
      if (!_controller.isClosed) {
        _controller.add(event);
      }
    }, onError: (error, stackTrace) {
      if (!_controller.isClosed) {
        _controller.addError(error, stackTrace);
      }
      if (!_doneCompleter.isCompleted) {
        _doneCompleter.completeError(error, stackTrace);
      }
    }, onDone: () {
      if (!_controller.isClosed) {
        _controller.close();
      }
      if (!_doneCompleter.isCompleted) {
        _doneCompleter.complete();
      }
    });
  }

  static Future<HtmlAppWebSocket> connect(String url) async {
    final channel = HtmlWebSocketChannel.connect(url);
    return HtmlAppWebSocket._(channel);
  }

  @override
  Stream<dynamic> get stream => _controller.stream;

  @override
  Future<void> get done => _doneCompleter.future;

  @override
  void add(dynamic data) => _channel.sink.add(data);

  @override
  Future<void> close() async {
    await _channel.sink.close();
    if (!_controller.isClosed) {
      await _controller.close();
    }
    if (!_doneCompleter.isCompleted) {
      _doneCompleter.complete();
    }
  }
}

Future<AppWebSocket> connectAppWebSocket(String url) async {
  return HtmlAppWebSocket.connect(url);
}
