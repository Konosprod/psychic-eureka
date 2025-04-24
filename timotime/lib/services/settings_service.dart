import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:timotime/models/settings_model.dart';

class SettingsService {
  Future<String> _getSettingsFilePath() async {
    final directory = await getApplicationDocumentsDirectory();
    Directory finalDirectory =
        await Directory("${directory.path}/timotime/").create(recursive: true);
    return '${finalDirectory.path}/settings.json';
  }

  Future<SettingsModel> loadSettings() async {
    final filePath = await _getSettingsFilePath();
    final file = File(filePath);

    if (await file.exists()) {
      final jsonString = await file.readAsString();
      if (jsonString.isEmpty) {
        return SettingsModel(); // Return default settings if file is empty
      }
      return SettingsModel.fromJson(jsonDecode(jsonString));
    } else {
      return SettingsModel(); // Return default settings if file doesn't exist
    }
  }

  Future<void> saveSettings(SettingsModel settings) async {
    final filePath = await _getSettingsFilePath();
    final file = File(filePath);
    await file.writeAsString(jsonEncode(settings.toJson()));
  }
}
