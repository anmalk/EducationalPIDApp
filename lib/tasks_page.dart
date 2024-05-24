import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'services/storage_service.dart';  // Импортируйте ваш StorageService
import 'page_widgets_tasks.dart';
import 'models/task_more_controller.dart';
import 'models/object_model.dart';
import 'package:EducationalApp/services/db.dart';

class TasksPage extends StatefulWidget {
  final String name;

  TasksPage({required this.name});

  @override
  _TasksPageState createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  late Map<String, dynamic> jsonData;
  final StorageService storageService = StorageService();  // Создайте экземпляр StorageService
  late String id = ''; // замените 'id' на актуальное поле из ответа сервера


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
      // Извлеките токен из хранилища
      final String? token = await storageService.getToken();
      try {
        final response = await http.post(
          Uri.parse('https://ait2-vladislav001.amvera.io/api/v1/information/pid'),
          headers: {
            'x-access-token': '$token',
            'Content-Type': 'application/json',  // Укажите тип контента, если это приложение/JSON
          },
        );

        if (response.statusCode == 200) {
          final Map<String, dynamic> responseData = json.decode(response.body);
          id = responseData['_id']; // замените 'id' на актуальное поле из ответа сервера
          print('ID: $id');
        } else {
          print('Error: ${response.statusCode}');
        }
      } catch (error) {
        print('Error: $error');
      }

      final response = await http.get(
        Uri.parse('https://ait2-vladislav001.amvera.io/api/configuration_module/settings/item/66153763bca893857e412279/$id'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        setState(() {
          jsonData = json.decode(response.body);
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (error) {
      print('Error fetching data: $error');
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