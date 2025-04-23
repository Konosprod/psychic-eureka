enum TimerStatus {
  running,
  paused,
  stopped,
}

class TimerModel {
  int _seconds;
  TimerStatus status;

  int get seconds => _seconds;
  int get minutes => _seconds ~/ 60;
  set seconds(int value) {
    if (value < 0) {
      throw ArgumentError('Seconds cannot be negative');
    }
    _seconds = value;
  }

  TimerModel({required int seconds, this.status = TimerStatus.stopped})
      : _seconds = seconds;
}
