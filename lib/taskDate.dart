class TaskDate {
  DateTime startDate;
  DateTime endDate;
  bool isAllDay;

  TaskDate(this.startDate, this.endDate, [this.isAllDay = false]);
}