import 'package:get/get.dart';
import '/db/db_helper.dart';
import '/models/task.dart';

class TaskController extends GetxController {
  final RxList<Task> taskList = <Task>[].obs;

//==================== Insert Task To Databasae ====================
  Future<int> addTask({Task? task}) {
    return DBHelper.insert(task);
  }

//==================== Get Data From Databasae ====================
  Future<void> getTasks() async {
    final List<Map<String, dynamic>> tasks = await DBHelper.query();
    taskList.assignAll(tasks.map((data) => Task.fromJson(data)).toList());
  }

//==================== Delete Data From Databasae ====================
  void deleteTasks(Task task) async {
    await DBHelper.delete(task);
    getTasks();
  }

//==================== Delete All Data From Databasae ====================
  void deleteAllTasks() async {
    await DBHelper.deleteAll();
    getTasks();
  }

//==================== Update Data in Databasae ====================
  void markTaskCompleted(int id) async {
    await DBHelper.update(id);
    getTasks();
  }
}
