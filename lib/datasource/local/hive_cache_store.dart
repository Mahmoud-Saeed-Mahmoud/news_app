import 'package:hive/hive.dart';
import '../../models/news.dart';

/// A class that provides caching functionality for news data using Hive.
///
/// This class wraps a `Box` instance and provides methods to store and retrieve
/// news data from the cache. It uses the `toJson` and `fromJson` methods of the
/// `News` class to serialize and deserialize the data.
///
/// Example usage:
///
/// ```dart
/// final cacheStore = HiveCacheStore(box: Hive.box('news'));
///
/// // Store news data in the cache
/// await cacheStore.set('world', newsData);
///
/// // Retrieve news data from the cache
/// final cachedData = await cacheStore.get('world');
///
/// // Delete cached news data
/// await cacheStore.delete('world');
/// ```
class HiveCacheStore {
  final Box _box;

  /// Creates a new [HiveCacheStore] instance with the given `Box`.
  HiveCacheStore({required Box box}) : _box = box;

  /// Deletes the cached news data with the specified key.
  Future<void> delete(String key) async {
    await _box.delete(key);
  }

  /// Returns the cached news data with the specified key, or null if it doesn't exist.
  ///
  /// This method deserializes the cached data using the `News.fromJson` method
  /// and returns it as a `News` object.
  Future<News?> get(String key) async {
    final cachedData = _box.get(key);
    if (cachedData != null) {
      final cacheMap = cachedData;
      return News.fromJson(cacheMap);
    } else {
      return null;
    }
  }

  /// Stores the specified news data in the cache with the specified key.
  ///
  /// This method serializes the news data using the `News.toJson` method and
  /// stores it in the cache under the specified key.
  Future<void> set(String key, News response) async {
    final cacheMap = response.toJson();
    await _box.put(key, cacheMap);
  }
}
