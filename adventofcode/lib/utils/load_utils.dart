import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

Future<String> get _localPath async {
  final directory = await getApplicationDocumentsDirectory();
  return directory.path;
}

Future<String> loadFileAsString(int year, int day, String fileName) async {
  final path = await _localPath;
  final file = File('$path/data/$year/$day/$fileName');
  return file.readAsString();
}

Future<String> loadAssetFileAsString(String fileName) async {
  return await rootBundle.loadString('assets/data/$fileName');
}
