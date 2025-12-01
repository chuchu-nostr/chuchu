import 'dart:math';
import 'dart:typed_data';

final Map<String, Uint8List> _webFileStorage = {};
final Random _random = Random();

String createVirtualFilePath(String? fileName) {
  final safeName = (fileName?.isNotEmpty == true ? fileName! : 'web_file')
      .replaceAll(RegExp(r'[^a-zA-Z0-9._-]'), '_');
  final id = DateTime.now().microsecondsSinceEpoch;
  final suffix = _random.nextInt(1 << 15);
  return 'webfile://$id-$suffix-$safeName';
}

void registerWebFileData(String path, Uint8List data) {
  _webFileStorage[path] = data;
}

void unregisterWebFileData(String path) {
  _webFileStorage.remove(path);
}

Uint8List? getWebFileData(String path) {
  return _webFileStorage[path];
}

