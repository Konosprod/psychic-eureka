import 'package:flutter/material.dart';
import 'package:timotime/models/settings_model.dart';
import 'package:timotime/services/settings_service.dart';

class SettingsViewModel extends ChangeNotifier {
  final SettingsService _settingsService;
  late SettingsModel _settingsModel = SettingsModel();

  SettingsViewModel(this._settingsService);

  SettingsModel get settingsModel => _settingsModel;
  Duration get workDuration => Duration(minutes: _settingsModel.longBreakTime);
  Duration get shortBreakDuration =>
      Duration(minutes: _settingsModel.shortBreakTime);
  Duration get longBreakDuration =>
      Duration(minutes: _settingsModel.longBreakTime);

  int get workTime => _settingsModel.workTime;
  int get shortBreakTime => _settingsModel.shortBreakTime;
  int get longBreakTime => _settingsModel.longBreakTime;

  set workTime(int value) {
    _settingsModel.workTime = value;
    notifyListeners();
  }

  set shortBreakTime(int value) {
    _settingsModel.shortBreakTime = value;
    notifyListeners();
  }

  set longBreakTime(int value) {
    _settingsModel.longBreakTime = value;
    notifyListeners();
  }

  Future<void> load() async {
    _settingsModel = await _settingsService.loadSettings();
    notifyListeners();
  }

  Future<void> save() async {
    await _settingsService.saveSettings(_settingsModel);
    notifyListeners();
  }
}
