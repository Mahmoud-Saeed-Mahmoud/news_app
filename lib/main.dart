import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hive/hive.dart';
import 'core/themes/app_theme_data_light.dart';
import 'datasource/local/news_adapter.dart';
import 'screens/home_screen.dart';
import 'package:path_provider/path_provider.dart';

import 'core/themes/app_theme_data_dark.dart';
import 'core/themes/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent,
    ),
  );
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  await GetStorage.init();

  var path = await getApplicationSupportDirectory();

  Hive
    ..init('${path.path}hive')
    ..registerAdapter(NewsAdapter());
  await Hive.openBox('news');

  await Hive.openBox<int>('expected_content_length_cache');

  runApp(const ProviderScope(child: _MyApp()));
}

class _MyApp extends ConsumerStatefulWidget {
  const _MyApp();

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends ConsumerState<_MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached) {
      ref
          .read(themeModeProvider.notifier)
          .writeThemeMode(ref.read(themeModeProvider));
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode:
          ref.watch(themeModeProvider) ? ThemeMode.dark : ThemeMode.light,
      theme: AppThemeDataLight.theme,
      darkTheme: AppThemeDataDark.theme,
      home: const HomePage(),
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}
