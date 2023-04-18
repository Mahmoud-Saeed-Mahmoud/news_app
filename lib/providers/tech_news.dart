import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

import '../datasource/local/hive_cache_store.dart';
import '../datasource/remote/dio_news_api.dart';
import '../models/news.dart';
import 'i_news.dart';

/// A [INewsNotifier] implementation that fetches news related to technology.
///
/// This implementation uses the `Dio` HTTP client to make requests to the
/// News API, and a `HiveCacheStore` to cache the fetched news data. It overrides
/// the [INewsNotifier.getData] method to fetch and process news data specific
/// to technology.
///
/// Example usage:
///
/// ```dart
/// final techNews = ref.read(techNewsProvider);
/// final news = await techNews.getData();
/// ```
class TechNewsNotifier extends INewsNotifier {
  final Dio _dioRef;
  final HiveCacheStore _cacheStore = HiveCacheStore(box: Hive.box('news'));

  /// Creates a new [TechNewsNotifier] instance with the given `Dio` client.
  TechNewsNotifier(this._dioRef) : super(_dioRef);

  @override
  Future<News> getData({String? query}) async {
    final api = Api(_dioRef);
    try {
      final response =
          await api.get('everything', 'q=tech&langauge=en&sortby=popularity');
      state = News.fromJson(response.data)
        ..articles!.removeWhere((element) => element.urlToImage == null);
      _cacheStore.set('tech', state);
      return state;
    } catch (e) {
      final cachedNews = await _cacheStore.get('tech');
      state = cachedNews ?? News.fromJson({});
      return state;
    }
  }
}

/// A [StateNotifierProvider] that provides a [TechNewsNotifier] instance.
///
/// Example usage:
///
/// ```dart
/// final techNews = ref.read(techNewsProvider);
/// final news = await techNews.getData();
/// ```
final techNewsProvider = StateNotifierProvider<INewsNotifier, News>((ref) {
  final dio = ref.watch(dioProvider);
  return TechNewsNotifier(dio);
});
