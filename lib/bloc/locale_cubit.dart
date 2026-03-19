import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:homefe/persistence/secure_persistent_storage.dart';

class LocaleCubit extends Cubit<Locale> {
  bool changed = false;
  LocaleCubit() : super(const Locale('en')) {
    _loadStoredLocale();
  }

  Future<void> changeLocaleTo(Locale locale) async {
    changed = true;
    emit(locale);

    _persist({'language_code': locale.languageCode});
  }

  bool wasLocaleChanged() {
    return changed;
  }

  Future<void> _loadStoredLocale() async {
    final storedLanguage = await SecurePersistentStorage.read('language_code');
    if (storedLanguage != null) {
      emit(Locale(storedLanguage));
    }
  }
}

Future<void> _persist(Map<String, dynamic> data) async {
  await SecurePersistentStorage.delete(data.entries.first.key);
  await SecurePersistentStorage.write(
    data.entries.first.key,
    data.entries.first.value.toString(),
  );
}
