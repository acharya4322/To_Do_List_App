class Task {
  String title;
  String description;
  bool isCompleted;
  DateTime dueDate;
  Priority priority;

  Task({
    required this.title,
    this.description = '',
    this.isCompleted = false,
    required this.dueDate,
    this.priority = Priority.low,
  });

  Map<String, dynamic> toJson() => {
        'title': title,
        'description': description,
        'isCompleted': isCompleted,
        'dueDate': dueDate.toIso8601String(),
        'priority': priority.index,
      };

  static Task fromJson(Map<String, dynamic> json) => Task(
        title: json['title'],
        description: json['description'],
        isCompleted: json['isCompleted'],
        dueDate: DateTime.parse(json['dueDate']),
        priority: Priority.values[json['priority']],
      );
}

enum Priority { low, medium, high }
