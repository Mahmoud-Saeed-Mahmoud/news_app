import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/article_content.dart';
import '../../datasource/local/image_cach_manager.dart';
import '../../models/news.dart';

extension NewsExtension on News {
  Widget articlesWidget() {
    return articles == null
        ? Center(
            child: Text(
              'news not found\n you might have lost connection to internet',
              style: TextStyle(
                color: Colors.red.shade200,
                fontSize: 15,
              ),
            ),
          )
        : Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
            ),
            child: ListView.separated(
              separatorBuilder: (_, __) => const Divider(),
              itemCount: articles!.length,
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: () {
                    try {
                      navigateToArticle(context, articles![index].url!);
                    } on Exception {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'something went wrong',
                          ),
                        ),
                      );
                    }
                  },
                  leading: Consumer(
                    builder: (_, ref, __) {
                      final imageCacheManager = ref.watch(
                          imageCacheManagerProvider(
                              articles![index].urlToImage!));
                      return imageCacheManager.when(
                        data: (file) => Image.file(
                          file,
                        ),
                        loading: () => const CircularProgressIndicator(),
                        error: (_, __) => const Icon(Icons.error),
                      );
                    },
                  ),
                  title: Text(
                    articles![index].title!,
                  ),
                  subtitle: Text(
                    articles![index].publishedAt!,
                  ),
                );
              },
            ),
          );
  }
}
