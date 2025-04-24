class SettingsModel {
  int workTime = 25;
  int shortBreakTime = 5;
  int longBreakTime = 25;

  SettingsModel({
    this.workTime = 25,
    this.shortBreakTime = 5,
    this.longBreakTime = 25,
  });

  SettingsModel.fromJson(Map<String, dynamic> json)
      : workTime = json['workTime'] ?? 25,
        shortBreakTime = json['shortBreakTime'] ?? 5,
        longBreakTime = json['longBreakTime'] ?? 25;

  Map<String, dynamic> toJson() {
    return {
      'workTime': workTime,
      'shortBreakTime': shortBreakTime,
      'longBreakTime': longBreakTime,
    };
  }
}
