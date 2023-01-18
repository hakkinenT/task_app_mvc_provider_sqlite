import 'package:dartz/dartz.dart';

import '../../core/error/error.dart';

import '../../models/task.dart' as t;
import '../database/database.dart';

abstract class TaskRepository {
  Future<Either<Failure, int>> saveTask(t.Task task);

  Future<Either<Failure, int>> deleteTask(t.Task task);

  Future<Either<Failure, int>> deleteAllTasks();

  Future<Either<Failure, List<t.Task>>> getAllTaks();
}

class TaskRepositoryImpl implements TaskRepository {
  final TaskDao taskDao;

  TaskRepositoryImpl({required this.taskDao});

  @override
  Future<Either<Failure, int>> saveTask(t.Task task) async {
    try {
      late int saved;
      if (task.id != null) {
        saved = await taskDao.update(task);
      } else {
        saved = await taskDao.add(task);
      }

      return Right(saved);
    } on SqliteOperationException {
      return Left(SaveOperationFailure());
    }
  }

  @override
  Future<Either<Failure, int>> deleteTask(t.Task task) async {
    try {
      final deleted = await taskDao.delete(task.id!);
      return Right(deleted);
    } on SqliteOperationException {
      return Left(DeleteOperationFailure());
    }
  }

  @override
  Future<Either<Failure, int>> deleteAllTasks() async {
    try {
      final deleteds = await taskDao.deleteAll();
      return Right(deleteds);
    } on SqliteOperationException {
      return Left(DeleteAllOperationFailure());
    }
  }

  @override
  Future<Either<Failure, List<t.Task>>> getAllTaks() async {
    try {
      final todos = await taskDao.getAll();
      return Right(todos);
    } on SqliteOperationException {
      return Left(GetAllOperationFailure());
    }
  }
}
