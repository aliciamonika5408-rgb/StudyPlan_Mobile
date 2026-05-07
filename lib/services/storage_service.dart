import 'package:hive_ce_flutter/hive_flutter.dart';
import '../models/task_model.dart';

class StorageService {
  static const String _boxName = 'tasks';
  static late Box _taskBox;

  static Future<void> init() async {
    await Hive.initFlutter();
    _taskBox = await Hive.openBox(_boxName);
  }

  // Create
  static Future<void> addTask(Task task) async {
    await _taskBox.put(task.id, task.toMap());
  }

  // Read all
  static List<Task> getAllTasks() {
    final tasks = <Task>[];
    for (var key in _taskBox.keys) {
      final map = _taskBox.get(key);
      if (map != null) {
        tasks.add(Task.fromMap(Map<dynamic, dynamic>.from(map)));
      }
    }
    // Sort by deadline (nearest first)
    tasks.sort((a, b) => a.deadline.compareTo(b.deadline));
    return tasks;
  }

  // Read single
  static Task? getTask(String id) {
    final map = _taskBox.get(id);
    if (map != null) {
      return Task.fromMap(Map<dynamic, dynamic>.from(map));
    }
    return null;
  }

  // Update
  static Future<void> updateTask(Task task) async {
    await _taskBox.put(task.id, task.toMap());
  }

  // Delete
  static Future<void> deleteTask(String id) async {
    await _taskBox.delete(id);
  }

  // Get pending tasks
  static List<Task> getPendingTasks() {
    return getAllTasks()
        .where((t) => t.status == TaskStatus.belumSelesai)
        .toList();
  }

  // Get completed tasks
  static List<Task> getCompletedTasks() {
    return getAllTasks()
        .where((t) => t.status == TaskStatus.selesai)
        .toList();
  }

  // Get tasks by date
  static List<Task> getTasksByDate(DateTime date) {
    return getAllTasks().where((t) {
      return t.deadline.year == date.year &&
          t.deadline.month == date.month &&
          t.deadline.day == date.day;
    }).toList();
  }

  // Get task count
  static int get totalTasks => getAllTasks().length;
  static int get pendingCount => getPendingTasks().length;
  static int get completedCount => getCompletedTasks().length;

  // Mark task complete
  static Future<void> markComplete(String id) async {
    final task = getTask(id);
    if (task != null) {
      task.status = TaskStatus.selesai;
      await updateTask(task);
    }
  }

  // Mark task incomplete
  static Future<void> markIncomplete(String id) async {
    final task = getTask(id);
    if (task != null) {
      task.status = TaskStatus.belumSelesai;
      await updateTask(task);
    }
  }
}
