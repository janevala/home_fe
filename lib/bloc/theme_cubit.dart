import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  ThemeMode? _mode;

  ThemeCubit({ThemeMode? theme}) : super(theme ?? ThemeMode.system) {
    _mode = theme;
  }

  ThemeMode get mode => _mode ?? ThemeMode.system;
  bool get hasUnsavedChanges => _mode != ThemeMode.system;

  void toggleTheme() {
    _mode = _mode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    emit(_mode!);
  }

  void reset() {
    _mode = ThemeMode.system;
    emit(_mode!);
  }
}
