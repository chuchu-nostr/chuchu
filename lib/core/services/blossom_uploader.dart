import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:mime/mime.dart';
import 'dart:io' if (dart.library.html) 'package:chuchu/core/account/platform_stub.dart';
import 'package:chuchu/core/account/web_file_registry_stub.dart'
    if (dart.library.html) 'package:chuchu/core/account/web_file_registry.dart'
    as web_file_registry;

import '../account/account.dart';
import 'package:nostr_core_dart/src/event.dart';
import './string_util.dart';
import 'base64.dart';
import 'hash_util.dart';

class BolssomUploader {
  static var dio = Dio();

  static Future<String?> upload(String? endPoint, String filePath, {
    String? fileName,
    Function(double progress)? onProgress,
  }) async {
    var uri = Uri.tryParse(endPoint ?? 'https://blossom.band');
    if (uri == null) {
      return null;
    }
    var uploadApiPath = Uri(
            scheme: uri.scheme,
            userInfo: uri.userInfo,
            host: uri.host,
            port: uri.port,
            path: "/upload")
        .toString();

    String? payload;
    MultipartFile? multipartFile;
    Uint8List? bytes;
    if (BASE64.check(filePath)) {
      bytes = BASE64.toData(filePath);
    } else {
      if (filePath.startsWith('webfile://')) {
        bytes = web_file_registry.getWebFileData(filePath);
        if (bytes == null) {
          throw Exception('Web file data not found for $filePath');
        }
        if (StringUtil.isBlank(fileName)) {
          fileName = filePath.split('/').last;
        }
      } else {
        var file = File(filePath);
        bytes = await file.readAsBytes();
        if (StringUtil.isBlank(fileName)) {
          fileName = filePath.split("/").last;
        }
      }
    }

    final Uint8List? data = bytes;
    if (data == null || data.isEmpty) {
      return null;
    }

    var fileSize = data.length;
    log("file size is ${data.length}");
    payload = HashUtil.sha256Bytes(data);
    
    multipartFile = MultipartFile.fromBytes(
      data,
      filename: fileName,
    );

    Map<String, String>? headers = {};
    
    // Set Content-Length header (required by server)
    headers["Content-Length"] = fileSize.toString();
    
    // Set Content-Type header based on file type
    if (StringUtil.isNotBlank(fileName)) {
      var mt = lookupMimeType(fileName!);
      if (StringUtil.isNotBlank(mt)) {
        headers["Content-Type"] = mt!;
      }
    }
    if (StringUtil.isBlank(headers["Content-Type"])) {
      if (multipartFile.contentType != null) {
        headers["Content-Type"] = multipartFile.contentType!.mimeType;
      } else {
        // Default to application/octet-stream for unknown types
        headers["Content-Type"] = "application/octet-stream";
      }
    }

    List<List<String>> tags = [];
    tags.add(["t", "upload"]);
    tags.add([
      "expiration",
      ((DateTime.now().millisecondsSinceEpoch ~/ 1000) + 60 * 10).toString()
    ]);
    tags.add(["size", "$fileSize"]);
    tags.add(["x", payload]);
    Event nip98Event = await Event.from(
        kind: 24242,
        tags: tags,
        content: "Upload $fileName",
        pubkey: Account.sharedInstance.currentPubkey,
        privkey: Account.sharedInstance.currentPrivkey);
        headers["Authorization"] =
            "Nostr ${base64Url.encode(utf8.encode(jsonEncode(nip98Event.toJson())))}";

    try {
      var response = await dio.put(
        uploadApiPath,
        data: bytes, // Use bytes directly for both images and videos

        options: Options(
          headers: headers,
          validateStatus: (status) {
            return true;
          },
        ),
        onSendProgress: (count, total) {
          if (onProgress != null && total > 0) {
            final progress = count / total;
            onProgress(progress);
          }
        },
      );
      var body = response.data;
      log(jsonEncode(response.data));
      if (body is Map<String, dynamic> && body["url"] != null) {
        return body["url"];
      } else {
        throw Exception('${uri.host} Bad Gateway');
      }
    } catch (e) {
      print("BolssomUploader.upload upload exception:");
      print(e);
      rethrow;
    }
  }
}
