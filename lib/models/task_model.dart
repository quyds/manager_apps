class Task {
  late final int id;
  late final String title;
  late final String description;
  late final String estimateTime;
  late final String completeTime;
  late final String date;
  late final String state;
  late final String employee;

  Task(this.id, this.title, this.description, this.estimateTime,
      this.completeTime, this.date);

  @override
  String toString() {
    return '$title $description $estimateTime $completeTime';
  }
}
