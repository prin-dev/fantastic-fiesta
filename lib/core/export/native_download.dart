import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class NativeDownloader {
  static const _platform = MethodChannel('com.ba.movo/native_download');

  /// Saves file to public Downloads folder and returns the saved file path, or [null] if failed.
  static Future<String?> saveFile({
    required Uint8List bytes,
    required String fileName,
    String mimeType = 'application/octet-stream',
  }) async {
    try {
      final String? savedPath = await _platform.invokeMethod<String>(
        'saveToPublicDownloads',
        {'bytes': bytes, 'fileName': fileName, 'mimeType': mimeType},
      );
      return savedPath;
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print("Download error: ${e.message}");
      }
      return null;
    }
  }
}
