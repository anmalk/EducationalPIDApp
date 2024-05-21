import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
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
    print('Выбранная категория: ${widget.name}');
    DatabaseService.initFirebase();
    jsonData = {};
    fetchData();


    TaskController_more.tasks = [
      Task(
        id: '1',
        idCategory: 'category1',
        objectsDataDiffCategories: [
          {
            Object(id_objects: '1', name: 'Object 1', name_categories: 'category1', url: 'https://example.com/image1.jpg'): {
              'id_objects': '1',
              'name': 'Object 1',
              'name_categories': 'category1',
              'url': 'https://img.povar.ru/mobile/8b/4e/89/f5/uzbekskii_plov-4860.jpg'
            },
            Object(id_objects: '2', name: 'Object 2', name_categories: 'category1', url: 'https://example.com/image2.jpg'): {
              'id_objects': '2',
              'name': 'Object 2',
              'name_categories': 'category1',
              'url': 'https://static.insales-cdn.com/images/products/1/2038/401188854/kvarcevii_pesok.jpg'
            },
            Object(id_objects: '3', name: 'Object 3', name_categories: 'category1', url: 'https://example.com/image2.jpg'): {
              'id_objects': '3',
              'name': 'Object 3',
              'name_categories': 'category1',
              'url': 'https://www.tg-stroy.ru/wp-content/uploads/2021/08/Rectangle-25-2-570x360.jpg'
            },
          },
        ],
        objectsDataOneCategory: [
          {
            Object(id_objects: '4', name: 'Object 4', name_categories: 'category2', url: 'https://upload.wikimedia.org/wikipedia/commons/0/0c/Two-parts_stone_nikogda_takih_ne_videl_vot.JPG'): {
              'id_objects': '4',
              'name': 'Object 4',
              'name_categories': 'category2',
              'url': 'https://upload.wikimedia.org/wikipedia/commons/0/0c/Two-parts_stone_nikogda_takih_ne_videl_vot.JPG'
            },
            Object(id_objects: '5', name: 'Object 5', name_categories: 'category1', url: 'https://aif-s3.aif.ru/images/019/734/a3e931c399f2ddb1e74ccdb2bda0b2e7.jpg'): {
              'id_objects': '5',
              'name': 'Object 5',
              'name_categories': 'category1',
              'url': 'https://aif-s3.aif.ru/images/019/734/a3e931c399f2ddb1e74ccdb2bda0b2e7.jpg'
            },
            Object(id_objects: '6', name: 'Object 6', name_categories: 'category2', url: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTYotOoL8JNtaChgVqbQDumZEuf1lhFO5Qk4UxHoFFRAw&s'): {
              'id_objects': '6',
              'name': 'Object 6',
              'name_categories': 'category2',
              'url': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTYotOoL8JNtaChgVqbQDumZEuf1lhFO5Qk4UxHoFFRAw&s'
            },
          },
        ],
      ),
      // Другие задачи здесь...
    ];

    // Вызываем метод загрузки задач из Firestore
    TaskController_more.fetchTasksFromFirestore().then((_) {
      // Делаем что-то после загрузки задач
      TaskController_more.length = TaskController_more.tasks.length;
      print('Длина:');
      print(TaskController_more.length);
      print(TaskController_more.tasks);
      print('Печать');
    });

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

      body: jsonData == null || jsonData.isEmpty
          ? Center(
        child: CircularProgressIndicator(),
      )
          : buildTasksPage(context, jsonData['item']['settings']?['pages']),
    );
  }
}