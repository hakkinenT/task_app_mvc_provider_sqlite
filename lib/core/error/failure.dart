import 'package:equatable/equatable.dart';

class Failure extends Equatable {
  @override
  List<Object?> get props => [];
}

class SaveOperationFailure extends Failure {}

class DeleteOperationFailure extends Failure {}

class DeleteAllOperationFailure extends Failure {}

class GetAllOperationFailure extends Failure {}
