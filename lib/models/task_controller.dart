import 'package:EducationalApp/models/object_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

// Класс Task представляет собой задачу, которая содержит идентификатор категории,
// список объектов из разных категорий и список объектов из одной категории
class Task {
  String idCategory;
  List<String> idObjectsDiffCategories;
  List<String> idObjectsOneCategory;

  Task({
    required this.idCategory,
    required this.idObjectsDiffCategories,
    required this.idObjectsOneCategory,
  });
}

// Контроллер TaskController управляет загрузкой задач из Firestore,
// а также обработкой текущих задач, индексов и значений
class TaskController {
  static List<Object> tasks = []; // Список задач
  static int currentTaskIndex = 0; // Текущий индекс задачи
  static double currentValue = 0; // Текущее значение прогресса
  static int length = 0; // Общая длина задач
  static Category? category; // Текущая категория
  static int score = 0; // Очки пользователя
  static User? user; // Информация о пользователе

  // Асинхронный метод для загрузки заданий из Firestore
  static Future<void> loadTasksFromFirestore(String nameCategory) async {
    try {
      // Получаем документы из коллекции tasks, где name_category равно заданному значению
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore.instance
          .collection('tasks')
          .where('name_category', isEqualTo: nameCategory)
          .get();

      tasks.clear();

      // Для каждого документа в полученных результатах
      for (QueryDocumentSnapshot<Map<String, dynamic>> doc in querySnapshot.docs) {
        // Получаем массив id_objects из документа
        List<dynamic> idObjects = doc['id_objects'];

        // Загружаем объекты из коллекции objects по id_objects
        for (var id in idObjects) {
          DocumentSnapshot<Map<String, dynamic>> objectDoc = await FirebaseFirestore.instance
              .collection('objects')
              .doc(id)
              .get();

          // Если документ существует, создаем объект и добавляем его в список tasks
          if (objectDoc.exists) {
            Object object = Object(
              id_objects: objectDoc.id ?? '',
              name: objectDoc['name'] ?? '',
              name_categories: objectDoc['category'] ?? '',
              url: objectDoc['url'] ?? '',
            );
            tasks.add(object);
          }
        }
      }

      print('Tasks loaded successfully.');
    } catch (e) {
      print('Error loading tasks: $e');
    }
  }

  // Метод для показа следующего изображения (увеличивает текущий индекс задачи)
  static void showNextImage() {
    currentTaskIndex = (currentTaskIndex + 1);
  }

  // Метод для показа предыдущего изображения (уменьшает текущий индекс задачи)
  static void showPrevImage() {
    currentTaskIndex = (currentTaskIndex - 1 + length) % length;
  }

  // Метод добавления количества очков
  static void addScore(){
     score = score++;
  }

  // Метод для вычисления текущего значения прогресса
  static void countValue() {
    currentValue = (currentTaskIndex / length);
  }
}
