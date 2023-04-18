import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/news.dart';

/// An abstract class that defines the common behavior of news notifiers.
///
/// This class extends `StateNotifier` and provides a default implementation
/// of the [StateNotifier.state] property and the `dispose` method. It also
/// defines an abstract [getData] method that should be implemented by
/// concrete subclasses to fetch news data.
///
/// Example usage:
///
/// ```dart
/// class MyNewsNotifier extends INewsNotifier {
///   MyNewsNotifier(Dio dioRef) : super(dioRef);
///
///   @override
///   Future<News> getData() async {
///     // ...
///   }
/// }
/// ```
abstract class INewsNotifier extends StateNotifier<News> {
  INewsNotifier(Dio dioRef) : super(News());

  /// Fetches news data and updates the [StateNotifier.state] property.
  ///
  /// This method should be implemented by concrete subclasses to fetch news
  /// data from a specific source and process it as necessary. It should return
  /// the fetched news data as a `News` object.
  Future<News> getData({String? query});

  @override
  void dispose() {
    state = News();
    super.dispose();
  }
}
