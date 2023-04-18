import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/news_type.dart';

class NewsTypesListTile extends ConsumerWidget {
  const NewsTypesListTile({
    super.key,
    required this.newsType,
  });
  final NewsTypeEnum newsType;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      title: Text('${newsType.title} '),
      leading: Radio(
        value: newsType,
        groupValue: ref.watch(newsTypeProvider),
        onChanged: (value) {
          ref.read(newsTypeProvider.notifier).state = value!;
          Navigator.pop(context);
        },
      ),
      onTap: () {
        ref.read(newsTypeProvider.notifier).state = newsType;
        Navigator.pop(context);
      },
    );
  }
}
