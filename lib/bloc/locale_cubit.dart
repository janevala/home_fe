import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:homefe/persistence/persistent_storage.dart';

class LocaleCubit extends Cubit<Locale> {
  bool changed = false;
  LocaleCubit() : super(const Locale('en'));

  Future<void> changeLocaleTo(Locale locale) async {
    changed = true;
    emit(locale);

    _persist({'language_code': locale.languageCode});
  }

  bool wasLocaleChanged() {
    return changed;
  }
}

Future<void> _persist(Map<String, dynamic> data) async {
  await PersistentStorage.delete(data.entries.first.key);
  await PersistentStorage.write(
    data.entries.first.key,
    data.entries.first.value.toString(),
  );
}
