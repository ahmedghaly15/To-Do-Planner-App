class Task {
  int? id;
  String? taskText;
  int? isCompleted;
  String? date;
  String? startTime;
  String? endTime;
  int? color;
  int? remind;
  String? repeat;

  Task({
    this.id,
    this.taskText,
    this.isCompleted,
    this.date,
    this.startTime,
    this.endTime,
    this.color,
    this.remind,
    this.repeat,
  });

//==================== Convert Data To Json ====================
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'taskText': taskText,
      'isCompleted': isCompleted,
      'date': date,
      'startTime': startTime,
      'endTime': endTime,
      'color': color,
      'remind': remind,
      'repeat': repeat,
    };
  }

//==================== Convert Data From Json To Real Fields ====================
  factory Task.fromJson(Map<String, dynamic> map) {
    return Task(
      id: map['id'] != null ? map['id'] as int : null,
      taskText: map['taskText'] != null ? map['taskText'] as String : null,
      isCompleted:
          map['isCompleted'] != null ? map['isCompleted'] as int : null,
      date: map['date'] != null ? map['date'] as String : null,
      startTime: map['startTime'] != null ? map['startTime'] as String : null,
      endTime: map['endTime'] != null ? map['endTime'] as String : null,
      color: map['color'] != null ? map['color'] as int : null,
      remind: map['remind'] != null ? map['remind'] as int : null,
      repeat: map['repeat'] != null ? map['repeat'] as String : null,
    );
  }
}
