import 'package:equatable/equatable.dart';

enum Frequence {
  none('Nenhuma'),
  daily('Diariamente'),
  weekly('Semanalmente'),
  monthly('Mensalmente');

  const Frequence(this.description);
  final String description;

  bool get isNone => this == Frequence.none;

  bool get isDaily => this == Frequence.daily;

  bool get isWeekly => this == Frequence.weekly;

  bool get isMonthly => this == Frequence.monthly;
}

class Task extends Equatable {
  final int? id;
  final String title;
  final String description;
  final bool isCompleted;
  final DateTime? scheduledDate;
  final Frequence frequence;

  const Task(
      {this.id,
      required this.title,
      required this.description,
      this.isCompleted = false,
      this.scheduledDate,
      this.frequence = Frequence.none});

  @override
  List<Object?> get props =>
      [id, title, description, isCompleted, scheduledDate, frequence];

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
        id: json['id'],
        title: json['title'],
        description: json['description'],
        isCompleted: (json['isCompleted'] as int) == 1 ? true : false,
        scheduledDate: json['scheduledDate'] != null
            ? DateTime.fromMillisecondsSinceEpoch(json['scheduledDate'])
            : null,
        frequence: mapStringToEnum(json['frequence'] as String));
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "title": title,
      "description": description,
      "isCompleted": isCompleted ? 1 : 0,
      "scheduledDate": scheduledDate?.millisecondsSinceEpoch,
      "frequence": frequence.description
    };
  }

  Task copyWith(
      {int? id,
      String? title,
      String? description,
      bool? isCompleted,
      DateTime? scheduledDate,
      Frequence? frequence}) {
    return Task(
        id: id ?? this.id,
        title: title ?? this.title,
        description: description ?? this.description,
        isCompleted: isCompleted ?? this.isCompleted,
        scheduledDate: scheduledDate ?? this.scheduledDate,
        frequence: frequence ?? this.frequence);
  }
}

Frequence mapStringToEnum(String description) {
  switch (description) {
    case 'Diariamente':
      return Frequence.daily;
    case 'Semanalmente':
      return Frequence.weekly;
    case 'Mensalmente':
      return Frequence.monthly;
    default:
      return Frequence.none;
  }
}
