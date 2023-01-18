import 'package:flutter/material.dart';

import '../models/models.dart';

class TaskFormController extends ChangeNotifier {
  String _title = "";
  String _description = "";
  bool _isCompleted = false;
  DateTime _initialDate = DateTime.now();
  TimeOfDay _initialTime = TimeOfDay.now();
  bool _isDaily = false;
  bool _isMonthly = false;
  bool _isWeekly = false;
  bool _isNone = true;
  Frequence _frequence = Frequence.none;
  DateTime? _scheduledDate;

  String get title => _title;
  String get description => _description;
  bool get isCompleted => _isCompleted;
  DateTime get initialDate => _initialDate;
  TimeOfDay get initialTime => _initialTime;
  bool get isDaily => _isDaily;
  bool get isWeekly => _isWeekly;
  bool get isMonthly => _isMonthly;
  bool get isNone => _isNone;
  Frequence get frequence => _frequence;
  DateTime? get scheduledDate => _scheduledDate;

  void onInitialDateChanged(DateTime date) {
    _initialDate = date;
    notifyListeners();
  }

  void onInitialTimeChanged(TimeOfDay time) {
    _initialTime = time;
    notifyListeners();
  }

  void onNoneChanged(bool value) {
    if ((_isNone == true || value == true) &&
        (_isDaily == true || _isWeekly == true || _isMonthly == true)) {
      _isDaily = false;
      _isWeekly = false;
      _isMonthly = false;
    }

    _frequence = Frequence.none;
    _isNone = value;
    notifyListeners();
  }

  void onDailyChanged(bool value) {
    if (value == true &&
        (_isWeekly == true || _isMonthly == true || _isNone == true)) {
      _isWeekly = false;
      _isMonthly = false;
      _isNone = false;
    }
    _frequence = Frequence.daily;
    _isDaily = value;
    notifyListeners();
  }

  void onWeeklyChanged(bool value) {
    if (value == true && _isDaily == true ||
        _isMonthly == true ||
        _isNone == true) {
      _isDaily = false;
      _isMonthly = false;
      _isNone = false;
    }
    _frequence = Frequence.weekly;
    _isWeekly = value;
    notifyListeners();
  }

  void onMonthlyChanged(bool value) {
    if (value == true && _isWeekly == true ||
        _isDaily == true ||
        _isNone == true) {
      _isWeekly = false;
      _isDaily = false;
      _isNone = false;
    }
    _frequence = Frequence.monthly;
    _isMonthly = value;
    notifyListeners();
  }

  void onScheduledDate() {
    _scheduledDate = DateTime(_initialDate.year, _initialDate.month,
        _initialDate.day, _initialTime.hour, _initialTime.minute);

    notifyListeners();
  }

  void onTitleChanged(String value) {
    _title = value;
    notifyListeners();
  }

  void onDescriptionChanged(String value) {
    _description = value;
    notifyListeners();
  }

  void onCompletedChanged(bool value) {
    _isCompleted = value;

    notifyListeners();
  }

  void clear() {
    _title = "";
    _description = "";
    _isCompleted = false;
    _initialDate = DateTime.now();
    _initialTime = TimeOfDay.now();
    _isNone = true;
    _isDaily = false;
    _isWeekly = false;
    _isMonthly = false;
    _scheduledDate = null;
    _frequence = Frequence.none;
    notifyListeners();
  }

  void initializeEdittingFields(Task? task) {
    _title = task!.title;
    _description = task.description;
    _scheduledDate = task.scheduledDate;
    final date = task.scheduledDate;
    if (date != null) {
      _initialDate = DateTime(date.year, date.month, date.day);
      _initialTime = TimeOfDay.fromDateTime(date);
    }
    _frequence = task.frequence;
    _initializeSwitchFields(frequence);
  }

  _initializeSwitchFields(Frequence frequence) {
    switch (frequence) {
      case Frequence.daily:
        _isDaily = true;
        _isNone = false;
        _isWeekly = false;
        _isMonthly = false;
        break;
      case Frequence.weekly:
        _isDaily = false;
        _isNone = false;
        _isWeekly = true;
        _isMonthly = false;
        break;
      case Frequence.monthly:
        _isDaily = false;
        _isNone = false;
        _isWeekly = false;
        _isMonthly = true;
        break;
      default:
        _isDaily = false;
        _isNone = true;
        _isWeekly = false;
        _isMonthly = false;
        break;
    }
  }
}
