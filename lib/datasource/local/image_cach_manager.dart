import 'dart:convert' show utf8;
import 'dart:io' show Directory, File;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hex/hex.dart' show HEX;
import 'package:crypto/crypto.dart' show sha256;
import 'package:dio/dio.dart';
import 'package:hive/hive.dart' show Hive;
import 'package:path_provider/path_provider.dart'
    show getApplicationSupportDirectory;

import '../remote/dio_news_api.dart';

/// A class that provides caching functionality for images using Dio and Hive.

class ImageCacheManager {
  final Dio _dio;
  ImageCacheManager(this._dio);
  final String _cacheDir = 'my_image_cache_dir';

  final Duration _cacheExpiration = const Duration(days: 1);
  // ignore: unused_field
  final Duration _cacheCleanupInterval = const Duration(days: 1);

  /// Returns the cached image file for the specified URL.
  ///
  /// This method first checks if the image file exists in the cache directory
  /// and has the expected content length. If it does, it returns the file. If
  /// it doesn't, it downloads the image from the URL, stores it in the cache,
  /// and returns the file.
  Future<File> getImage(String url) async {
    final cacheDir = await getApplicationSupportDirectory();
    final cachePath = '${cacheDir.path}/$_cacheDir';
    final cacheFile = File('$cachePath/${Uri.parse(url).pathSegments.last}');

    if (cacheFile.existsSync()) {
      final expectedLength = await _getExpectedContentLength(url);
      final actualLength = await cacheFile.length();
      if (expectedLength == actualLength) {
        return cacheFile;
      } else {
        await cacheFile.delete();
      }
    }

    await cacheFile.create(recursive: true);
    await _dio.download(url, cacheFile.path);
    await _cleanupCache(cacheDir, cachePath);
    return cacheFile;
  }

  /// Retrieves the expected content length for the specified URL from the
  /// `expected_content_length_cache` box.
  ///
  /// If the expected content length is not found in the box, it sends a HEAD
  /// request to the URL to get the content length, stores it in the box, and
  /// returns it.
  Future<int> _getExpectedContentLength(String url) async {
    final box = Hive.box<int>('expected_content_length_cache');
    final key = _generateHashKey(url);

    if (box.containsKey(key)) {
      final expectedLength = box.get(key)!;
      return expectedLength;
    }

    final response = await _dio.head(url);
    final contentLengthHeader = response.headers['content-length'];
    if (contentLengthHeader != null && contentLengthHeader.isNotEmpty) {
      final expectedLength = int.parse(contentLengthHeader.first);
      await box.put(key, expectedLength);
      return expectedLength;
    } else {
      return -1;
    }
  }

  /// Generates a hash key for the specified URL.

  String _generateHashKey(String url) {
    final bytes = utf8.encode(url);
    final digest = sha256.convert(bytes);
    final truncatedDigest = digest.toString().substring(0, 64);
    return HEX.encode(utf8.encode(truncatedDigest));
  }

  /// Cleans up the cache directory by deleting expired files and directories.
  ///
  /// This method deletes image files and metadata files that have expired based
  /// on the `_cacheExpiration` duration. It also deletes any directories that
  /// are not the cache directory.
  Future<void> _cleanupCache(Directory cacheDir, String cachePath) async {
    final now = DateTime.now().millisecondsSinceEpoch;
    final cacheFiles = await cacheDir
        .list()
        .where((entity) => entity is File)
        .cast<File>()
        .toList();

    for (final file in cacheFiles) {
      final age = Duration(
          milliseconds: now - file.statSync().modified.millisecondsSinceEpoch);
      if (age >= _cacheExpiration) {
        final metadataPath = '${file.path}.metadata';
        final metadataFile = File(metadataPath);
        await file.delete();
        await metadataFile.delete();
      }
    }

    final cacheDirs = await cacheDir
        .list()
        .where((entity) => entity is Directory)
        .cast<Directory>()
        .toList();
    for (final dir in cacheDirs) {
      if (dir.path != cachePath) {
        await dir.delete(recursive: true);
      }
    }
  }
}

/// A provider that returns the `File` for the specified URL from an
/// `ImageCacheManager` instance.
final imageCacheManagerProvider =
    FutureProvider.family<File, String>((ref, url) {
  final dio = ref.watch(dioProvider);
  return ImageCacheManager(dio).getImage(url);
});
