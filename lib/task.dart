import 'taskDate.dart';

class Task {
  String title;
  String description;
  TaskDate taskDate;
  bool isDone;

  Task(this.title, this.description, this.taskDate, [this.isDone = false]);
}