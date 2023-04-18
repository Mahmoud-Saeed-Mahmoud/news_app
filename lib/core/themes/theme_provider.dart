import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_storage/get_storage.dart';

final boxProvider = Provider<GetStorage>((_) => GetStorage());

class ThemeModeCache extends StateNotifier<bool> {
  ThemeModeCache(super.state, this._localCach);
  final GetStorage _localCach;

  void writeThemeMode(bool mode) async {
    _localCach.write('isDarkModeEnabled', mode);
    _localCach.save();
  }

  void toggleThemeMode() {
    state = !state;
  }
}

final themeModeProvider = StateNotifierProvider<ThemeModeCache, bool>(
  (ref) => ThemeModeCache(
      ref.read(boxProvider).read('isDarkModeEnabled') ?? false,
      ref.read(boxProvider)),
);
