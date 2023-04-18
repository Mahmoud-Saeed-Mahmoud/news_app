import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'i_news.dart';

import '../datasource/local/hive_cache_store.dart';
import '../datasource/remote/dio_news_api.dart';
import '../models/news.dart';

/// A [INewsNotifier] implementation that fetches news related to sports.
///
/// This implementation uses the `Dio` HTTP client to make requests to the
/// News API, and a `HiveCacheStore` to cache the fetched news data. It overrides
/// the [INewsNotifier.getData] method to fetch and process news data specific
/// to sports.
///
/// Example usage:
///
/// ```dart
/// final sportNews = ref.read(sportNewsProvider);
/// final news = await sportNews.getData();
/// ```
class SportNewsNotifier extends INewsNotifier {
  final Dio _dioRef;
  final HiveCacheStore _cacheStore = HiveCacheStore(box: Hive.box('news'));

  /// Creates a new [SportNewsNotifier] instance with the given `Dio` client.
  SportNewsNotifier(this._dioRef) : super(_dioRef);

  @override
  Future<News> getData({String? query}) async {
    final api = Api(_dioRef);
    try {
      final response =
          await api.get('everything', 'q=sport&langauge=en&sortby=popularity');
      state = News.fromJson(response.data)
        ..articles!.removeWhere((element) => element.urlToImage == null);
      _cacheStore.set('sport', state);
      return state;
    } catch (e) {
      final cachedNews = await _cacheStore.get('sport');
      state = cachedNews ?? News.fromJson({});
      return state;
    }
  }
}

/// A [StateNotifierProvider] that provides a [SportNewsNotifier] instance.
///
/// Example usage:
///
/// ```dart
/// final sportNews = ref.read(sportNewsProvider);
/// final news = await sportNews.getData();
/// ```
final sportNewsProvider = StateNotifierProvider<INewsNotifier, News>((ref) {
  final dio = ref.watch(dioProvider);
  return SportNewsNotifier(dio);
});
