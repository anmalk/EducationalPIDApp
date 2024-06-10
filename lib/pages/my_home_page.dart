import 'package:flutter/material.dart';
import 'package:EducationalApp/services/storage_service.dart';
import 'page_widgets.dart';
import 'package:EducationalApp/models/task_controller.dart';
import 'package:EducationalApp/services/db.dart';
import 'package:EducationalApp/services/api_service.dart';

class MyHomePage extends StatefulWidget {
  final String name; // Имени категории

  MyHomePage({required this.name}); // Конструктор

  @override
  _MyHomePageState createState() => _MyHomePageState(); // Создание состояния для домашней страницы
}

class _MyHomePageState extends State<MyHomePage> {
  late Map<String, dynamic> jsonData; // Переменная для хранения данных JSON
  final StorageService storageService = StorageService(); // StorageService
  late String id = ''; // Идентификатор
  final ApiService apiService = ApiService(); // Создаем экземпляр ApiService

  @override
  void initState() {
    // Инициализация состояния виджета
    TaskController.currentTaskIndex = 0;
    TaskController.tasks.clear();
    TaskController.length = 0;
    TaskController.category = null;
    TaskController.currentValue = 0;

    super.initState(); // Вызыв метода initState у родительского класса
    print('Выбранная категория: ${widget.name}');
    DatabaseService.initFirebase(); // Инициализация Firebase
    jsonData = {}; // Инициализацияя JSON с информацией о параметрах интерфейса
    fetchData(); // Загрузка данные

    // Загрузка заданий из Firestore для выбранной категории
    TaskController.loadTasksFromFirestore(widget.name).then((_) {
      // Выполнение действий после загрузки задач
      TaskController.length = TaskController.tasks.length; // Установка длины списка задач
    });

    // Получение данных категории из базы данных
    DatabaseService.getCategoryData(widget.name).then((category) {
      setState(() {
        TaskController.category = category;
      });
    });
  }

  Future<void> fetchData() async {
    try {
      final Map<String, dynamic> data = await apiService.fetchData(); // Получение данные о параметрах интерфейса с помощью ApiService
      setState(() {
        jsonData = data; // Обновление данных при получении
      });
    } catch (error) {
      print('Error fetching data: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: jsonData == null || jsonData.isEmpty // Если данные пустые или равны null
          ? Center(
        child: CircularProgressIndicator(), // Отображение индикатор загрузки
      )
          : buildHomePage(jsonData['item']['settings']?['pages']), // Построение страницы с учетом полученных данных
    );
  }
}
