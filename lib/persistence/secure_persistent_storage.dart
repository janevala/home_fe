import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:homefe/logger/logger.dart';

abstract class SecurePersistentStorage {
  static const IOSOptions iosOptions = IOSOptions.defaultOptions;
  static const MacOsOptions macOsOptions = MacOsOptions.defaultOptions;
  static const AndroidOptions androidOptions = AndroidOptions(
    keyCipherAlgorithm: KeyCipherAlgorithm.RSA_ECB_OAEPwithSHA_256andMGF1Padding,
    storageCipherAlgorithm: StorageCipherAlgorithm.AES_GCM_NoPadding,
    encryptedSharedPreferences: true,
    sharedPreferencesName: "schaeffleroptime",
    preferencesKeyPrefix: "schaeffleroptime",
  );

  //https://github.com/mogol/flutter_secure_storage?tab=readme-ov-file#important-notice-for-web
  static const WebOptions webOptions = WebOptions.defaultOptions;

  static const FlutterSecureStorage _instance = FlutterSecureStorage(
    iOptions: iosOptions,
    aOptions: androidOptions,
    mOptions: macOsOptions,
    webOptions: webOptions,
  );

  static FlutterSecureStorage get instance {
    return _instance;
  }

  /// Decrypts and returns the value for the given [key] or null if [key] is not in the storage.
  static Future<String?> read(String key) async {
    try {
      return await _instance.read(key: key);
    } catch (e) {
      if (e is PlatformException) {
        // This seems to be some kind of an issue with certain android models
        // https://github.com/juliansteenbakker/flutter_secure_storage/issues/541#issuecomment-1619765229
        // lets see if this fixes it... basically if this is encountered, delete the key and return null as if the key didnt exist in the first place
        // since its probably unrecoverable anyways
        await delete(key);
        return null;
      } else {
        logger.e("SecurePersistentStorage: Read error:");
        logger.e(e.toString());
        rethrow;
      }
    }
  }

  /// Decrypts and returns all keys with associated values.
  static Future<Map<String, String>> readAll() async {
    return await _instance.readAll();
  }

  /// Deletes associated value for the given [key].
  /// If the given [key] does not exist, nothing will happen.
  static Future<void> delete(String key) async {
    try {
      return await _instance.delete(key: key);
    } catch (e) {
      logger.e("SecurePersistentStorage: Delete error:");
      logger.e(e.toString());
      rethrow;
    }
  }

  /// Deletes all keys with associated values.
  static Future<void> deleteAll() async {
    return await _instance.deleteAll();
  }

  /// Encrypts and saves the [key] with the given [value].
  /// If the key was already in the storage, its associated value is changed. If the value is null, deletes associated value for the given [key].
  static Future<void> write(String key, String? value) async {
    try {
      return await _instance.write(key: key, value: value);
    } catch (e) {
      logger.e("SecurePersistentStorage: Write error:");
      logger.e(e.toString());
      rethrow;
    }
  }
}
