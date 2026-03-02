import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:homefe/logger/logger.dart';
import 'package:homefe/persistence/persistent_storage.dart';

class LocaleCubit extends Cubit<Locale> {
  bool userChangedLanguage = false;
  LocaleCubit() : super(const Locale('en'));

  Future<void> changeLocaleTo(Locale locale) async {
    logger.d('LocaleCubit changeLocaleTo: $locale');
    userChangedLanguage = true;
    emit(locale);

    _persist({'user_language': locale.languageCode});
  }

  bool hasUserChangedLanguage() {
    return userChangedLanguage;
  }
}

Future<void> _persist(Map<String, dynamic> data) async {
  await PersistentStorage.delete(data.entries.first.key);
  await PersistentStorage.write(
    data.entries.first.key,
    data.entries.first.value.toString(),
  );
}
