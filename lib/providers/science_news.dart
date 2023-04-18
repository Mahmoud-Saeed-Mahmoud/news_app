import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'i_news.dart';

import '../datasource/local/hive_cache_store.dart';
import '../datasource/remote/dio_news_api.dart';
import '../models/news.dart';

/// A [INewsNotifier] implementation that fetches news related to science.
///
/// This implementation uses the `Dio` HTTP client to make requests to the
/// News API, and a `HiveCacheStore` to cache the fetched news data. It overrides
/// the [INewsNotifier.getData] method to fetch and process news data specific
/// to science.
///
/// Example usage:
///
/// ```dart
/// final scienceNews = ref.read(scienceNewsProvider);
/// final news = await scienceNews.getData();
/// ```
class ScienceNewsNotifier extends INewsNotifier {
  final Dio _dioRef;
  final HiveCacheStore _cacheStore = HiveCacheStore(box: Hive.box('news'));

  /// Creates a new [ScienceNewsNotifier] instance with the given `Dio` client.
  ScienceNewsNotifier(this._dioRef) : super(_dioRef);

  @override
  Future<News> getData({String? query}) async {
    final api = Api(_dioRef);
    try {
      final response = await api.get(
          'everything', 'q=science&langauge=en&sortby=popularity');
      state = News.fromJson(response.data)
        ..articles!.removeWhere((element) => element.urlToImage == null);
      _cacheStore.set('science', state);
      return state;
    } catch (e) {
      final cachedNews = await _cacheStore.get('science');
      state = cachedNews ?? News.fromJson({});
      return state;
    }
  }
}

/// A [StateNotifierProvider] that provides a [ScienceNewsNotifier] instance.
///
/// Example usage:
///
/// ```dart
/// final scienceNews = ref.read(scienceNewsProvider);
/// final news = await scienceNews.getData();
/// ```
final scienceNewsProvider = StateNotifierProvider<INewsNotifier, News>((ref) {
  final dio = ref.watch(dioProvider);
  return ScienceNewsNotifier(dio);
});
