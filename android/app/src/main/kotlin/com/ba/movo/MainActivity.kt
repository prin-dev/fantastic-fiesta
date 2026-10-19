package com.ba.movo

import android.content.ContentValues
import android.net.Uri
import android.os.Build
import android.os.Environment
import android.provider.MediaStore
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterFragmentActivity() {
    private val CHANNEL = "com.ba.movo/native_download"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "saveToPublicDownloads") {
                val bytes = call.argument<ByteArray>("bytes")
                val fileName = call.argument<String>("fileName")
                val mimeType = call.argument<String>("mimeType") ?: "application/octet-stream"

                if (bytes != null && fileName != null) {
                    val savedPath = saveToMediaStore(bytes, fileName, mimeType)
                    if (savedPath != null) {
                        result.success(savedPath) // Returns the path/URI string to Dart
                    } else {
                        result.error("SAVE_FAILED", "Failed to save file to public storage", null)
                    }
                } else {
                    result.error("INVALID_ARGS", "Missing bytes or fileName parameters", null)
                }
            } else {
                result.notImplemented()
            }
        }
    }

    private fun saveToMediaStore(bytes: ByteArray, fileName: String, mimeType: String): String? {
        val resolver = contentResolver
        val contentValues = ContentValues().apply {
            put(MediaStore.MediaColumns.DISPLAY_NAME, fileName)
            put(MediaStore.MediaColumns.MIME_TYPE, mimeType)
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
                put(MediaStore.MediaColumns.RELATIVE_PATH, Environment.DIRECTORY_DOWNLOADS)
            }
        }

        val uri: Uri = resolver.insert(MediaStore.Downloads.EXTERNAL_CONTENT_URI, contentValues) ?: return null

        return try {
            resolver.openOutputStream(uri)?.use { outputStream ->
                outputStream.write(bytes)
            }
            
            // Resolve path for Dart
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
                // Returns clean human-readable path: /storage/emulated/0/Download/fileName
                "${Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_DOWNLOADS).absolutePath}/$fileName"
            } else {
                // Fallback for older Android versions
                getLegacyFilePath(uri) ?: uri.toString()
            }
        } catch (e: Exception) {
            e.printStackTrace()
            null
        }
    }

    private fun getLegacyFilePath(uri: Uri): String? {
        val projection = arrayOf(MediaStore.MediaColumns.DATA)
        contentResolver.query(uri, projection, null, null, null)?.use { cursor ->
            if (cursor.moveToFirst()) {
                val columnIndex = cursor.getColumnIndexOrThrow(MediaStore.MediaColumns.DATA)
                return cursor.getString(columnIndex)
            }
        }
        return uri.toString()
    }
}