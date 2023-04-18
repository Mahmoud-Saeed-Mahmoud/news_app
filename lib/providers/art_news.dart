import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'i_news.dart';

import '../datasource/local/hive_cache_store.dart';
import '../datasource/remote/dio_news_api.dart';
import '../models/news.dart';

/// A [INewsNotifier] implementation that fetches news about art.
///
/// This implementation uses the `Dio` HTTP client to make requests to the
/// News API, and a `HiveCacheStore` to cache the fetched news data. It overrides
/// the [INewsNotifier.getData] method to fetch and process news data specific
/// to art.
///
/// Example usage:
///
/// ```dart
/// final artNews = ref.read(artNewsProvider);
/// final news = await artNews.getData();
/// ```
class ArtNewsNotifier extends INewsNotifier {
  final Dio _dioRef;
  final HiveCacheStore _cacheStore = HiveCacheStore(box: Hive.box('news'));

  /// Creates a new [ArtNewsNotifier] instance with the given `Dio` client.
  ArtNewsNotifier(this._dioRef) : super(_dioRef);

  @override
  Future<News> getData({String? query}) async {
    final api = Api(_dioRef);
    try {
      final response =
          await api.get('everything', 'q=art&langauge=en&sortby=popularity');
      state = News.fromJson(response.data)
        ..articles!.removeWhere((element) => element.urlToImage == null);
      _cacheStore.set('art', state);
      return state;
    } catch (e) {
      final cachedNews = await _cacheStore.get('art');
      state = cachedNews ?? News.fromJson({});
      return state;
    }
  }
}

/// A [StateNotifierProvider] that provides an [ArtNewsNotifier] instance.
///
/// Example usage:
///
/// ```dart
/// final artNews = ref.read(artNewsProvider);
/// final news = await artNews.getData();
/// ```
final artNewsProvider = StateNotifierProvider<INewsNotifier, News>((ref) {
  final dio = ref.watch(dioProvider);
  return ArtNewsNotifier(dio);
});
