import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'services/storage_service.dart';
import 'widgets/page_widgets_tasks.dart';
import 'widgets/task_more_controller.dart';
import 'package:EducationalApp/services/db.dart';
import 'services/api_service.dart';

class TasksPage extends StatefulWidget {
  final String name;

  TasksPage({required this.name});

  @override
  _TasksPageState createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  late Map<String, dynamic> jsonData;
  final StorageService storageService = StorageService();
  late String id = '';
  final ApiService apiService = ApiService();

  @override
  void initState() {
    TaskController_more.currentTaskIndex = 0;
    //TaskController_more.tasks.clear();
    TaskController_more.length = 0;
    TaskController_more.category = null;
    TaskController_more.currentValue = 0;

    super.initState();
    // Очищаем данные перед загрузкой новых
    TaskController_more.tasks.clear();

    // Вызываем метод для получения списка задач
    TaskController_more.fetchTasks().then((tasks) {
      // Обновляем состояние, когда данные получены
      setState(() {
        TaskController_more.tasks = tasks;
      });
    });


    jsonData = {};
    fetchData();

      print('Длина:');
      print(TaskController_more.length);
      print(TaskController_more.tasks);
      print('Печать');
      for (Task task in TaskController_more.tasks) {
        print('Task ID: ${task.images[0].url}');
      }

    print(TaskController_more.currentTaskIndex);

    DatabaseService.getCategoryData(widget.name).then((category) {
      setState(() {
        TaskController_more.category = category;
      });
    });
  }


  Future<void> fetchData() async {
    try {
      final Map<String, dynamic> data = await apiService.fetchData(); // Получение данных с помощью ApiService
      setState(() {
        jsonData = data; // Обновление данных при получении
      });
    } catch (error) {
      print('Error fetching data: $error'); // Вывод ошибки, если произошла ошибка получения данных
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: jsonData == null || jsonData.isEmpty || TaskController_more.tasks.isEmpty
          ? Center(
        child: CircularProgressIndicator(),
      )
          : buildTasksPage(context, jsonData['item']['settings']?['pages']),
    );
  }
}