import 'package:flutter/material.dart';
import 'package:theming/core/local_notification/task_notification_adapter.dart';

import '../core/error/error.dart';

import '../data/repositories/repositories.dart';
import '../models/models.dart';

class TaskController extends ChangeNotifier {
  final TaskNotificationAdapter notificationService;
  final TaskRepository repository;

  TaskController({required this.notificationService, required this.repository});

  String? _errorMessage;
  bool _hasError = false;
  bool _isSuccess = false;

  String? get errorMessage => _errorMessage;
  bool get hasError => _hasError;
  bool get isSuccess => _isSuccess;

  Future<List<Task>> get tasks async {
    final failureOrTasks = await repository.getAllTaks();
    List<Task> tasks = [];
    failureOrTasks.fold(
        (failure) => setErrorMessage(_mapFailureToMessage(failure)),
        (success) => tasks = success);
    return tasks;
  }

  void saveTask(Task task) async {
    final failureOrId = await repository.saveTask(task);

    failureOrId.fold(
        (failure) => setErrorMessage(_mapFailureToMessage(failure)), (success) {
      _isSuccess = true;
      if (task.scheduledDate != null) {
        Task newTask = task.id == null ? task.copyWith(id: success) : task;

        _registerNotification(newTask);
      }
    });

    notifyListeners();
  }

  void removeTask(Task task) async {
    final failureOrDelete = await repository.deleteTask(task);
    failureOrDelete
        .fold((failure) async => setErrorMessage(_mapFailureToMessage(failure)),
            (success) async {
      _isSuccess = true;
      if (task.scheduledDate != null) {
        await _cancelNotification(task);
      }
    });

    notifyListeners();
  }

  void removeAll() async {
    final failureOrDeleteAll = await repository.deleteAllTasks();
    failureOrDeleteAll
        .fold((failure) async => setErrorMessage(_mapFailureToMessage(failure)),
            (success) async {
      _isSuccess = true;
      await _cancelAllNotification();
    });

    notifyListeners();
  }

  void onCompletedToggled(bool isCompleted, Task task) async {
    final newTask = task.copyWith(isCompleted: isCompleted);

    final failureOrId = await repository.saveTask(newTask);

    failureOrId
        .fold((failure) => setErrorMessage(_mapFailureToMessage(failure)),
            (success) async {
      _isSuccess = true;
      if (newTask.scheduledDate != null) {
        await _cancelNotification(newTask);
      }
    });

    notifyListeners();
  }

  void setErrorMessage(String value) {
    _errorMessage = value;
    _hasError = true;
    notifyListeners();
  }

  void clearErrorState() {
    _errorMessage = "";
    _hasError = false;

    notifyListeners();
  }

  void clearSuccessState() {
    _isSuccess = false;
    notifyListeners();
  }

  _registerNotification(Task task) async {
    if (task.frequence.isDaily) {
      await _scheduleDailyNotification(task);
    } else if (task.frequence.isMonthly) {
      await _scheduleMonthlyNotification(task);
    } else if (task.frequence.isWeekly) {
      await _scheduleWeeklyNotification(task);
    } else {
      await _scheduleNotification(task);
    }
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case SaveOperationFailure:
        return "Houve um erro ao tentar salvar a Tarefa!";
      case DeleteAllOperationFailure:
        return "Houve um erro ao tentar excluir as Tarefas!";
      case DeleteOperationFailure:
        return "Houve um erro ao tentar excluir a Tarefa!";
      case GetAllOperationFailure:
        return "Houve um erro ao tentar obter as Tarefas!";
      default:
        return "Unexpected Error";
    }
  }

  _cancelNotification(Task task) async {
    try {
      if (task.scheduledDate != null) {
        await notificationService.cancelNotification(task.id!);
      }
    } catch (e) {
      setErrorMessage(e.toString());
    }
  }

  _cancelAllNotification() async {
    try {
      await notificationService.cancelAllNotifications();
    } catch (e) {
      setErrorMessage(e.toString());
    }
  }

  _scheduleDailyNotification(Task task) async {
    try {
      await notificationService.scheduleDailyNotification(task);
    } catch (e) {
      setErrorMessage(e.toString());
    }
  }

  _scheduleWeeklyNotification(Task task) async {
    try {
      await notificationService.scheduleWeeklyNotification(task);
    } catch (e) {
      setErrorMessage(e.toString());
    }
  }

  _scheduleMonthlyNotification(Task task) async {
    try {
      await notificationService.scheduleMonthlyNotification(task);
    } catch (e) {
      setErrorMessage(e.toString());
    }
  }

  _scheduleNotification(Task task) async {
    try {
      await notificationService.scheduledNotification(task);
    } catch (e) {
      setErrorMessage(e.toString());
    }
  }
}
