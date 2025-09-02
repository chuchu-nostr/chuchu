import 'blossom_uploader.dart';
import 'package:mime/mime.dart';
import 'string_util.dart';


class Uploader {

  static String getFileType(String filePath) {
    var fileType = lookupMimeType(filePath);
    if (StringUtil.isBlank(fileType)) {
      fileType = "image/jpeg";
    }

    return fileType!;
  }

  static Future<String?> upload(
    String localPath, {
    String? imageServiceAddr,
    String? fileName,
    Function(double progress)? onProgress,
  }) async {
    try{
      return await BolssomUploader.upload(imageServiceAddr, localPath, fileName: fileName, onProgress: onProgress);
    } catch (e) {
      rethrow;
    }
  }
}
