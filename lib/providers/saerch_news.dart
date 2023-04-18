import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:news_app/models/news.dart';
import 'package:news_app/providers/i_news.dart';

import '../datasource/remote/dio_news_api.dart';

/// A [INewsNotifier] subclass that fetches news articles based on a search query.
class SearcNewsNotifier extends INewsNotifier {
  /// The [Dio] client used to make HTTP requests.
  final Dio _dioRef;

  /// Creates a new [SearcNewsNotifier] instance with the given `Dio` client.

  SearcNewsNotifier(this._dioRef) : super(_dioRef);

  /// Fetches news articles based on a search query.
  ///
  /// This method uses the [Api] class to fetch news articles using the
  /// `everything` endpoint and the given search query. It returns the fetched
  /// news articles as a [News] object.
  ///
  /// If an error occurs during the fetch, this method will rethrow the error.
  ///
  /// The [query] parameter is an optional string that represents the search
  /// query to use when fetching news articles.
  @override
  Future<News> getData({String? query}) async {
    final api = Api(_dioRef);

    try {
      final response =
          await api.get('everything', 'q=$query&langauge=en&sortby=popularity');
      state = News.fromJson(response.data)
        ..articles!.removeWhere((element) => element.urlToImage == null);
      return state;
    } catch (e) {
      rethrow;
    }
  }
}

/// A [FutureProvider] that fetches news articles based on a search query.

final searchNewsProvider = FutureProvider.family<News, String>((ref, query) {
  final dio = ref.watch(dioProvider);
  return SearcNewsNotifier(dio).getData(query: query);
});
