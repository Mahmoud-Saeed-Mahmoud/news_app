import 'package:day_night_switcher/day_night_switcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/extensions/news_extension.dart';
import '../providers/news_type.dart';

import '../core/themes/theme_provider.dart';
import '../widgets/drawer_widget.dart';
import '../widgets/search_delegate.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Consumer(builder: (_, ref, __) {
          return Text(ref.watch(newsTypeProvider).title);
        }),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () =>
                showSearch(context: context, delegate: NewsSearchDelegate()),
            icon: const Icon(Icons.search),
          ),
          Consumer(
            builder: (_, WidgetRef ref, ___) => DayNightSwitcherIcon(
              isDarkModeEnabled: ref.watch(themeModeProvider),
              onStateChanged: (_) =>
                  ref.read(themeModeProvider.notifier).toggleThemeMode(),
            ),
          ),
        ],
      ),
      drawer: const DrawerWidget(),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10),
        child: Center(
          child: Consumer(
            builder: (_, ref, __) => ref.watch(selectedNewsProvider).when(
                  data: (data) => data.articlesWidget(),
                  error: (_, __) => const Text('Error somthing went wrong'),
                  loading: () => const CircularProgressIndicator(),
                ),
          ),
        ),
      ),
    );
  }
}
