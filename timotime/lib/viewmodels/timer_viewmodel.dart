import 'dart:async';

import 'package:flutter/material.dart';
import 'package:timotime/services/notification_service.dart';
import 'package:timotime/viewmodels/settings_viewmodel.dart';

import '../models/timer_model.dart';

enum PomodoroState {
  work,
  shortBreak,
  longBreak,
}

class TimerViewmodel extends ChangeNotifier {
  TimerModel _timer = TimerModel(seconds: 0);
  Timer? _ticker;
  SettingsViewModel _settingsViewModel;
  NotificationService _notificationService;

  TimerViewmodel(
      {required SettingsViewModel settingsViewModel,
      required NotificationService notificationService})
      : _settingsViewModel = settingsViewModel,
        _notificationService = notificationService;

  static const Duration oneSecond = Duration(seconds: 1);
  Duration get shortBreakDuration {
    return _settingsViewModel.shortBreakDuration;
  }

  Duration get longBreakDuration {
    return _settingsViewModel.longBreakDuration;
  }

  Duration get workTimeDuration {
    return _settingsViewModel.workDuration;
  }

  int step = 0;
  int workStep = 0;
  List<(PomodoroState, Duration)> _steps = [
    (PomodoroState.work, Duration(minutes: 25)),
    (PomodoroState.shortBreak, Duration(minutes: 5)),
    (PomodoroState.work, Duration(minutes: 25)),
    (PomodoroState.shortBreak, Duration(minutes: 5)),
    (PomodoroState.work, Duration(minutes: 25)),
    (PomodoroState.shortBreak, Duration(minutes: 5)),
    (PomodoroState.work, Duration(minutes: 25)),
    (PomodoroState.longBreak, Duration(minutes: 25)),
  ];

  void initSteps() {
    _steps = [
      (PomodoroState.work, _settingsViewModel.workDuration),
      (PomodoroState.shortBreak, _settingsViewModel.shortBreakDuration),
      (PomodoroState.work, _settingsViewModel.workDuration),
      (PomodoroState.shortBreak, _settingsViewModel.shortBreakDuration),
      (PomodoroState.work, _settingsViewModel.workDuration),
      (PomodoroState.shortBreak, _settingsViewModel.shortBreakDuration),
      (PomodoroState.work, _settingsViewModel.workDuration),
      (PomodoroState.longBreak, _settingsViewModel.longBreakDuration),
    ];
  }

  String get formattedTime {
    final minutes = _timer.minutes;
    final seconds = _timer.seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  int get progressPercent {
    final totalSteps = _steps.length;
    return (step / totalSteps * 100).toInt();
  }

  bool get isRunning => _timer.status == TimerStatus.running;
  bool get isPaused => _timer.status == TimerStatus.paused;
  bool get isStopped => _timer.status == TimerStatus.stopped;
  int get workSteps =>
      _steps.where((step) => step.$1 == PomodoroState.work).length;
  int get breakSteps =>
      _steps.where((step) => step.$1 != PomodoroState.work).length;
  PomodoroState get state => _steps[step].$1;
  int get maxSteps => _steps.length;

  void startTime() {
    initSteps();

    switch (_timer.status) {
      case TimerStatus.running:
        return;
      case TimerStatus.paused:
        _ticker = Timer.periodic(oneSecond, (timer) {
          _timer.seconds++;
          notifyListeners();
        });
        _timer.status = TimerStatus.running;
        break;
      case TimerStatus.stopped:
        _timer = TimerModel(
            seconds: _steps[step].$2.inSeconds, status: TimerStatus.running);
        _notificationService.showNotification(
            'Time to ${state == PomodoroState.work ? "work" : "take a break"}');
        _ticker = Timer.periodic(oneSecond, (timer) {
          _timer.seconds--;

          // Start next Timer
          if (_timer.seconds <= 0) {
            _ticker?.cancel();
            _ticker = null;
            _timer = TimerModel(seconds: 0, status: TimerStatus.stopped);

            // Check if we are at the end of the steps
            if (step >= _steps.length - 1) {
              step = 0;
              workStep = 0;
            } else {
              if (state == PomodoroState.work) {
                workStep++;
              }
              step++;
            }
            startTime();
            notifyListeners();
          }

          notifyListeners();
        });
        break;
    }
  }

  void pauseTime() {
    if (_timer.status == TimerStatus.running) {
      _ticker?.cancel();
      _ticker = null;
      _timer = TimerModel(seconds: _timer.seconds, status: TimerStatus.paused);
      notifyListeners();
    }
  }

  void stopTime() {
    _ticker?.cancel();
    _ticker = null;
    _timer = TimerModel(seconds: 0, status: TimerStatus.stopped);
    step = 0;
    workStep = 0;
    notifyListeners();
  }
}
