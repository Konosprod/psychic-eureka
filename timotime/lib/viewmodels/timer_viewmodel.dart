import 'dart:async';

import 'package:flutter/material.dart';

import '../models/timer_model.dart';

enum PomodoroState {
  work,
  shortBreak,
  longBreak,
}

class TimerViewmodel extends ChangeNotifier {
  TimerModel _timer = TimerModel(seconds: 0);
  Timer? _ticker;

  static const oneSecond = Duration(seconds: 1);
  static const shortBreakDuration = Duration(seconds: 5);
  static const longBreakDuration = Duration(seconds: 15);
  static const workTimeDuration = Duration(seconds: 10);
  int step = 0;
  int workStep = 0;
  static const _steps = [
    (PomodoroState.work, workTimeDuration),
    (PomodoroState.shortBreak, shortBreakDuration),
    (PomodoroState.work, workTimeDuration),
    (PomodoroState.shortBreak, shortBreakDuration),
    (PomodoroState.work, workTimeDuration),
    (PomodoroState.shortBreak, shortBreakDuration),
    (PomodoroState.work, workTimeDuration),
    (PomodoroState.longBreak, shortBreakDuration),
  ];

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
        _timer = TimerModel(seconds: 0, status: TimerStatus.running);
        _ticker = Timer.periodic(oneSecond, (timer) {
          _timer.seconds++;

          // Start next Timer
          if (_timer.seconds >= _steps[step].$2.inSeconds) {
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
