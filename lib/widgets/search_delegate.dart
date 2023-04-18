import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:news_app/core/extensions/news_extension.dart';
import 'package:news_app/providers/saerch_news.dart';

class NewsSearchDelegate extends SearchDelegate {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          if (query.isEmpty) {
            close(context, null);
          }
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Consumer(builder: (_, WidgetRef ref, __) {
      return ref.watch(searchNewsProvider(query)).when(
            data: (data) => data.articlesWidget(),
            error: (_, __) => const Text('Error somthing went wrong'),
            loading: () => const Center(child: CircularProgressIndicator()),
          );
    });
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Consumer(builder: (_, WidgetRef ref, __) {
      return query.isEmpty
          ? Container()
          : ref.watch(searchNewsProvider(query)).when(
                data: (data) => data.articlesWidget(),
                error: (_, __) => const Text('Error somthing went wrong'),
                loading: () => const Center(child: CircularProgressIndicator()),
              );
    });
  }
}
