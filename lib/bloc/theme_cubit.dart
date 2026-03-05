import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:homefe/persistence/persistent_storage.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  ThemeMode? _mode;

  ThemeCubit({ThemeMode? mode}) : super(mode ?? ThemeMode.system) {
    _load().then((value) {
      if (value != null) {
        _mode = ThemeMode.values.firstWhere((e) => e.name == value);
      }
    });
  }

  ThemeMode get mode => _mode ?? ThemeMode.system;

  void toggleTheme() {
    _mode = _mode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    _persistIfNotExist({'theme_mode': _mode!.name});
    emit(_mode!);
  }

  void setTheme(ThemeMode mode) {
    _persistIfNotExist({'theme_mode': mode.name});
    _mode = mode;
    emit(_mode!);
  }
}

Future<String?> _load() async {
  return await PersistentStorage.read('theme_mode');
}

Future<void> _persistIfNotExist(Map<String, dynamic> data) async {
  final existing = await PersistentStorage.read(data.entries.first.key);
  if (existing == null) {
    await PersistentStorage.write(
      data.entries.first.key,
      data.entries.first.value.toString(),
    );
  }
}
