import 'dart:async';

abstract class AppWebSocket {
  Stream<dynamic> get stream;
  Future<void> get done;
  void add(dynamic data);
  Future<void> close();
}
