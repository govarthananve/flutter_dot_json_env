import 'dart:async';
import 'dart:convert'; // Import for JSON decoding
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show PlatformException, rootBundle;
import 'package:flutter/widgets.dart';

import 'errors.dart';
import 'parser.dart';

DotJSONEnv dotjsonenv = DotJSONEnv();

class DotJSONEnv {
  bool _isInitialized = false;
  final Map<String, String> _envMap = {};

  Map<String, String> get env {
    if (!_isInitialized) {
      throw NotInitializedError();
    }
    return _envMap;
  }

  bool get isInitialized => _isInitialized;

  void clean() => _envMap.clear();

  String get(String name, {String? fallback}) {
    final value = maybeGet(name, fallback: fallback);
    if (value == null) {
      throw Exception(
        '$name variable not found. A non-null fallback is required for missing entries',
      );
    }
    return value;
  }

  String? maybeGet(String name, {String? fallback}) => env[name] ?? fallback;

  Future<void> load({
    String fileName = 'local.json',
    Parser parser = const Parser(),
    Map<String, String> mergeWith = const {},
    bool isOptional = false,
  }) async {
    clean();
    Map<String, dynamic> jsonData;
    try {
      jsonData = await _getEntriesFromFile(fileName);
    } on FileNotFoundError {
      if (isOptional) {
        jsonData = {};
      } else {
        rethrow;
      }
    }

    final mapFromJson =
        jsonData.map((key, value) => MapEntry(key, value.toString()));
    final allEntries = {...mapFromJson, ...mergeWith};
    final envEntries = parser.parse(allEntries);
    _envMap.addAll(envEntries);
    _isInitialized = true;
  }

  void testLoad({
    String jsonInput = '{}',
    Parser parser = const Parser(),
    Map<String, String> mergeWith = const {},
  }) {
    clean();
    final jsonData = json.decode(jsonInput) as Map<String, dynamic>;
    final mapFromJson =
        jsonData.map((key, value) => MapEntry(key, value.toString()));
    final allEntries = {...mapFromJson, ...mergeWith};
    final envEntries = parser.parse(allEntries);
    _envMap.addAll(envEntries);
    _isInitialized = true;
  }

  bool isEveryDefined(Iterable<String> vars) =>
      vars.every((k) => _envMap[k]?.isNotEmpty ?? false);

  Future<Map<String, dynamic>> _getEntriesFromFile(String filename) async {
    try {
      WidgetsFlutterBinding.ensureInitialized();
      final jsonString = await rootBundle.loadString(filename);
      if (jsonString.isEmpty) {
        throw EmptyEnvFileError();
      }
      final jsonData = json.decode(jsonString) as Map<String, dynamic>;
      return jsonData;
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print('PlatformException: ${e.message}');
      }

      throw FileNotFoundError();
    } catch (e) {
      if (kDebugMode) {
        print('An unexpected error occurred: $e');
      }

      rethrow;
    }
  }
}
