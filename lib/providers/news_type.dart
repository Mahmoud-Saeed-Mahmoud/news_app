import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'popular_news.dart';
import 'science_news.dart';
import 'sport_news.dart';
import 'tech_news.dart';
import 'world_news.dart';

import '../models/news.dart';
import 'art_news.dart';
import 'financial_.news.dart';

/// An enum that represents the different types of news categories.
///
/// Each enum value has a corresponding `title` property that returns a
/// human-readable title for the category.
enum NewsTypeEnum {
  world,
  science,
  popular,
  tech,
  financial,
  sport,
  art;

  /// Returns a human-readable title for the news category.
  String get title {
    switch (this) {
      case NewsTypeEnum.science:
        return 'Science News';
      case NewsTypeEnum.popular:
        return 'Popular News';
      case NewsTypeEnum.world:
        return 'World News';
      case NewsTypeEnum.tech:
        return 'Tech News';
      case NewsTypeEnum.financial:
        return 'Financial News';
      case NewsTypeEnum.sport:
        return 'Sport News';
      case NewsTypeEnum.art:
        return 'Art News';
      default:
        return '';
    }
  }
}

/// A [StateProvider] that provides the currently selected news category.
///
/// Example usage:
///
/// ```dart
/// final newsType = ref.watch(newsTypeProvider);
/// ```
final newsTypeProvider =
    StateProvider<NewsTypeEnum>((ref) => NewsTypeEnum.world);

/// A [FutureProvider] that provides the news data for the currently selected category.
///
/// This provider uses the `newsTypeProvider` to determine which news category
/// is currently selected, and returns the corresponding news data using one of
/// the `*_NewsNotifier` classes.
///
/// Example usage:
///
/// ```dart
/// final news = await ref.read(selectedNewsProvider.future);
/// ```
final selectedNewsProvider = FutureProvider<News>((ref) async {
  final newsType = ref.watch(newsTypeProvider);

  switch (newsType) {
    case NewsTypeEnum.world:
      return ref.watch(worldNewsProvider.notifier).getData();
    case NewsTypeEnum.popular:
      return ref.read(popularNewsProvider.notifier).getData();
    case NewsTypeEnum.tech:
      return ref.watch(techNewsProvider.notifier).getData();
    case NewsTypeEnum.science:
      return ref.watch(scienceNewsProvider.notifier).getData();
    case NewsTypeEnum.financial:
      return ref.watch(financialNewsProvider.notifier).getData();
    case NewsTypeEnum.sport:
      return ref.watch(sportNewsProvider.notifier).getData();
    case NewsTypeEnum.art:
      return ref.watch(artNewsProvider.notifier).getData();
    default:
      throw ArgumentError('Invalid news type: $newsType');
  }
});
