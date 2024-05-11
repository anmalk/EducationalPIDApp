import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'services/storage_service.dart';  // Импортируйте ваш StorageService
import 'page_widgets.dart';
import 'models/task_controller.dart';
import 'models/object_model.dart';
import 'package:EducationalApp/services/db.dart';

class MyHomePage extends StatefulWidget {
  final String name;
  final String name_false_category;

  MyHomePage({required this.name, required this.name_false_category});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Map<String, dynamic> jsonData;
  final StorageService storageService = StorageService();  // Создайте экземпляр StorageService
  late String id = ''; // замените 'id' на актуальное поле из ответа сервера


  @override
  void initState() {
    TaskController.currentTaskIndex = 0;
    TaskController.tasks.clear();
    TaskController.length = 0;
    TaskController.category = null;
    TaskController.currentValue = 0;

    super.initState();
    print('Выбранная категория: ${widget.name}');
    DatabaseService.initFirebase();
    jsonData = {};
    fetchData();




    // Вызываем метод загрузки задач из Firestore
    TaskController.loadTasksFromFirestore(widget.name, widget.name_false_category).then((_) {
      // Делаем что-то после загрузки задач
      TaskController.length = TaskController.tasks.length;
    });

    print(TaskController.currentTaskIndex);

    DatabaseService.getCategoryData(widget.name).then((category) {
      setState(() {
        TaskController.category = category;
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
      appBar: AppBar(
        // Добавляем кнопку "назад" на верхней панели навигации
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop(); // Возвращает на предыдущий экран
          },
        ),
        title: Text('EducationalApp'),
      ),
      body: jsonData == null || jsonData.isEmpty
          ? Center(
        child: CircularProgressIndicator(),
      )
          : buildHomePage(jsonData['item']['settings']?['pages']),
    );
  }
}