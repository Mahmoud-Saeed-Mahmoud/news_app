import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'i_news.dart';

import '../datasource/local/hive_cache_store.dart';
import '../datasource/remote/dio_news_api.dart';
import '../models/news.dart';

/// A [INewsNotifier] implementation that fetches news related to world events.
///
/// This implementation uses the `Dio` HTTP client to make requests to the
/// News API, and a `HiveCacheStore` to cache the fetched news data. It overrides
/// the [INewsNotifier.getData] method to fetch and process news data specific
/// to world events.
///
/// Example usage:
///
/// ```dart
/// final worldNews = ref.read(worldNewsProvider);
/// final news = await worldNews.getData();
/// ```
class WorldNewsNotifier extends INewsNotifier {
  final Dio _dioRef;
  final HiveCacheStore _cacheStore = HiveCacheStore(box: Hive.box('news'));

  /// Creates a new [WorldNewsNotifier] instance with the given `Dio` client.
  WorldNewsNotifier(this._dioRef) : super(_dioRef);

  @override
  Future<News> getData({String? query}) async {
    final api = Api(_dioRef);
    try {
      final response =
          await api.get('everything', 'q=world&langauge=en&sortby=popularity');
      state = News.fromJson(response.data)
        ..articles!.removeWhere((element) => element.urlToImage == null);
      _cacheStore.set('world', state);
      return state;
    } catch (e) {
      final cachedNews = await _cacheStore.get('world');
      state = cachedNews ?? News.fromJson({});
      return state;
    }
  }
}

/// A [StateNotifierProvider] that provides a [WorldNewsNotifier] instance.
///
/// Example usage:
///
/// ```dart
/// final worldNews = ref.read(worldNewsProvider);
/// final news = await worldNews.getData();
/// ```
final worldNewsProvider = StateNotifierProvider<INewsNotifier, News>((ref) {
  final dio = ref.watch(dioProvider);
  return WorldNewsNotifier(dio);
});
