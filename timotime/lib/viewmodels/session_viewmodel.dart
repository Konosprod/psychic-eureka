import 'package:flutter/material.dart';
import 'package:timotime/models/session_model.dart';

class SessionViewmodel extends ChangeNotifier {
  SessionModel? _sessionModel = SessionModel();

  String get task => _sessionModel?.task ?? '';

  updateTask(String task) {
    _sessionModel?.task = task;
    notifyListeners();
  }
}
