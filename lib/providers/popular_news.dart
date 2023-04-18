import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

import '../datasource/local/hive_cache_store.dart';
import '../datasource/remote/dio_news_api.dart';
import '../models/news.dart';
import 'i_news.dart';

/// A [INewsNotifier] implementation that fetches popular news.
///
/// This implementation uses the `Dio` HTTP client to make requests to the
/// News API, and a `HiveCacheStore` to cache the fetched news data. It overrides
/// the [INewsNotifier.getData] method to fetch and process news data specific
/// to popular news.
///
/// Example usage:
///
/// ```dart
/// final popularNews = ref.read(popularNewsProvider);
/// final news = await popularNews.getData();
/// ```
class PopularNewsNotifier extends INewsNotifier {
  final Dio _dioRef;
  final HiveCacheStore _cacheStore = HiveCacheStore(box: Hive.box('news'));

  /// Creates a new [PopularNewsNotifier] instance with the given `Dio` client.
  PopularNewsNotifier(this._dioRef) : super(_dioRef);

  @override
  Future<News> getData({String? query}) async {
    final api = Api(_dioRef);

    try {
      final response = await api.get(
          'everything', 'q=popular&langauge=en&sortby=popularity');
      state = News.fromJson(response.data)
        ..articles!.removeWhere((element) => element.urlToImage == null);
      _cacheStore.set('popular', state);
      return state;
    } catch (e) {
      final cachedNews = await _cacheStore.get('popular');
      state = cachedNews ?? News.fromJson({});
      return state;
    }
  }
}

/// A [StateNotifierProvider] that provides a [PopularNewsNotifier] instance.
///
/// Example usage:
///
/// ```dart
/// final popularNews = ref.read(popularNewsProvider);
/// final news = await popularNews.getData();
/// ```
final popularNewsProvider = StateNotifierProvider<INewsNotifier, News>((ref) {
  final dio = ref.watch(dioProvider);
  return PopularNewsNotifier(dio);
});
