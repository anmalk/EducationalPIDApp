import 'package:EducationalApp/models/object_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

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

class TaskController {

  static List<Object> tasks = [];
  static int currentTaskIndex = 0;
  static double currentValue = 0;
  static int length = 0;
  static Category? category;
  static int score = 0;
  static User? user;

  static Future<void> loadTasksFromFirestore(String nameCategory) async {
    try {
      // Получаем документы из коллекции tasks, где name_category равно заданному значению
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore.instance
          .collection('tasks')
          .where('name_category', isEqualTo: nameCategory)
          .get();

      tasks.clear(); // Очищаем список перед загрузкой новых данных

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

  static void showNextImage() {
    currentTaskIndex = (currentTaskIndex + 1);
  }

  static void showPrevImage() {
    currentTaskIndex = (currentTaskIndex - 1 + length) % length;
  }
  static void countValue(){
    currentValue = (currentTaskIndex/length);
  }

}