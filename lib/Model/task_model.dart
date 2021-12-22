class Task {
  late final int id;
  late final String title;

  late final String time;

  late final String date;
  late final String status;
    bool isSelected = false;

  Task({
    required this.id,
    required this.title,
    required this.time,
    required this.date,
    required this.status,
  });

}