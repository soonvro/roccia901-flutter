import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/utils/app_logger.dart';

final appStorageProvider = Provider<IAppStorage>(
  (ref) => AppSharedStorage(SharedPreferences.getInstance()),
);

// final appStorageProvider = Provider<IAppStorage>(
//   (ref) => AppSecureStorage(FlutterSecureStorage()),
// );

abstract interface class IAppStorage {
  Future<void> write({required String key, required String value});
  Future<String?> read({required String key});
  Future<void> delete({required String key});
}

class AppSecureStorage implements IAppStorage {
  final FlutterSecureStorage _storage;

  AppSecureStorage(this._storage);

  @override
  Future<void> write({required String key, required String value}) async {
    try {
      await _storage.write(key: key, value: value);
    } catch (e) {
      throw _errorHandler(e);
    }
  }

  @override
  Future<String?> read({required String key}) async {
    try {
      return await _storage.read(key: key);
    } catch (e) {
      throw _errorHandler(e);
    }
  }

  @override
  Future<void> delete({required String key}) async {
    try {
      await _storage.delete(key: key);
    } catch (e) {
      throw _errorHandler(e);
    }
  }

  Exception _errorHandler(Object e) {
    logger.w("App Storage Error: ${e.toString()}");
    return e as Exception;
  }
}

class AppSharedStorage implements IAppStorage {
  final Future<SharedPreferences> _storage;

  AppSharedStorage(this._storage);

  @override
  Future<void> write({required String key, required String value}) async {
    try {
      final prefs = await _storage;
      await prefs.setString(key, value);
    } catch (e) {
      throw _errorHandler(e);
    }
  }

  @override
  Future<String?> read({required String key}) async {
    try {
      final prefs = await _storage;
      return await prefs.getString(key);
    } catch (e) {
      throw _errorHandler(e);
    }
  }

  @override
  Future<void> delete({required String key}) async {
    try {
      final prefs = await _storage;
      await prefs.remove(key);
    } catch (e) {
      throw _errorHandler(e);
    }
  }

  Exception _errorHandler(Object e) {
    logger.w("App Storage Error: ${e.toString()}");
    return e as Exception;
  }
}
