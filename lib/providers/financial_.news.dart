import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'i_news.dart';

import '../datasource/local/hive_cache_store.dart';
import '../datasource/remote/dio_news_api.dart';
import '../models/news.dart';

/// A [INewsNotifier] implementation that fetches financial news.
///
/// This implementation uses the `Dio` HTTP client to make requests to the
/// News API, and a `HiveCacheStore` to cache the fetched news data. It overrides
/// the [INewsNotifier.getData] method to fetch and process news data specific
/// to finance.
///
/// Example usage:
///
/// ```dart
/// final financialNews = ref.read(financialNewsProvider);
/// final news = await financialNews.getData();
/// ```
class FinancialNewsNotifier extends INewsNotifier {
  final Dio _dioRef;
  final HiveCacheStore _cacheStore = HiveCacheStore(box: Hive.box('news'));

  /// Creates a new [FinancialNewsNotifier] instance with the given `Dio` client.
  FinancialNewsNotifier(this._dioRef) : super(_dioRef);

  @override
  Future<News> getData({String? query}) async {
    final api = Api(_dioRef);
    try {
      final response = await api.get(
          'everything', 'q=financial&langauge=en&sortby=popularity');
      state = News.fromJson(response.data)
        ..articles!.removeWhere((element) => element.urlToImage == null);
      _cacheStore.set('financial', state);
      return state;
    } catch (e) {
      final cachedNews = await _cacheStore.get('financial');
      state = cachedNews ?? News.fromJson({});
      return state;
    }
  }
}

/// A [StateNotifierProvider] that provides a [FinancialNewsNotifier] instance.
///
/// Example usage:
///
/// ```dart
/// final financialNews = ref.read(financialNewsProvider);
/// final news = await financialNews.getData();
/// ```
final financialNewsProvider = StateNotifierProvider<INewsNotifier, News>((ref) {
  final dio = ref.watch(dioProvider);
  return FinancialNewsNotifier(dio);
});
