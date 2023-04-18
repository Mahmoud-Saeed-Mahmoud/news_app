import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/news_type.dart';
import 'news_types_list_tile_widget.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Consumer(
        builder: (context, ref, __) {
          return ListView.separated(
            itemBuilder: ((context, index) => index == 0
                ? DrawerHeader(
                    child: Image.asset('assets/drawer_background.png'),
                  )
                : NewsTypesListTile(newsType: NewsTypeEnum.values[index - 1])),
            separatorBuilder: (_, __) => const Divider(),
            itemCount: NewsTypeEnum.values.length + 1,
          );
        },
      ),
    );
  }
}
