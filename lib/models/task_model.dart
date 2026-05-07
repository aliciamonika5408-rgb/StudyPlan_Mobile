enum TaskPriority { rendah, sedang, tinggi }
enum TaskStatus { belumSelesai, selesai }
enum ReminderOption { satujam, satuHari, tigaHari, none }

class Task {
  final String id;
  String title;
  String subject;
  String description;
  DateTime deadline;
  TaskPriority priority;
  ReminderOption reminderOption;
  TaskStatus status;
  final DateTime createdAt;

  Task({
    required this.id,
    required this.title,
    required this.subject,
    this.description = '',
    required this.deadline,
    this.priority = TaskPriority.sedang,
    this.reminderOption = ReminderOption.satuHari,
    this.status = TaskStatus.belumSelesai,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'subject': subject,
      'description': description,
      'deadline': deadline.toIso8601String(),
      'priority': priority.index,
      'reminderOption': reminderOption.index,
      'status': status.index,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Task.fromMap(Map<dynamic, dynamic> map) {
    return Task(
      id: map['id'] as String,
      title: map['title'] as String,
      subject: map['subject'] as String,
      description: map['description'] as String? ?? '',
      deadline: DateTime.parse(map['deadline'] as String),
      priority: TaskPriority.values[map['priority'] as int],
      reminderOption: ReminderOption.values[map['reminderOption'] as int],
      status: TaskStatus.values[map['status'] as int],
      createdAt: DateTime.parse(map['createdAt'] as String),
    );
  }

  bool get isCompleted => status == TaskStatus.selesai;
  bool get isUrgent => priority == TaskPriority.tinggi;

  bool get isOverdue {
    return !isCompleted && deadline.isBefore(DateTime.now());
  }

  Duration get timeUntilDeadline {
    return deadline.difference(DateTime.now());
  }

  String get priorityLabel {
    switch (priority) {
      case TaskPriority.rendah: return 'Rendah';
      case TaskPriority.sedang: return 'Sedang';
      case TaskPriority.tinggi: return 'Urgent';
    }
  }

  String get reminderLabel {
    switch (reminderOption) {
      case ReminderOption.satujam: return '1 jam sebelum deadline';
      case ReminderOption.satuHari: return '1 hari sebelum deadline';
      case ReminderOption.tigaHari: return '3 hari sebelum deadline';
      case ReminderOption.none: return 'Tidak ada pengingat';
    }
  }

  String get statusLabel {
    switch (status) {
      case TaskStatus.belumSelesai: return 'Belum Selesai';
      case TaskStatus.selesai: return 'Selesai';
    }
  }

  Task copyWith({
    String? title,
    String? subject,
    String? description,
    DateTime? deadline,
    TaskPriority? priority,
    ReminderOption? reminderOption,
    TaskStatus? status,
  }) {
    return Task(
      id: id,
      title: title ?? this.title,
      subject: subject ?? this.subject,
      description: description ?? this.description,
      deadline: deadline ?? this.deadline,
      priority: priority ?? this.priority,
      reminderOption: reminderOption ?? this.reminderOption,
      status: status ?? this.status,
      createdAt: createdAt,
    );
  }
}
