import 'package:untitled3/models/object_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class TaskController {

  static List<Object> tasks = [];
  static int currentTaskIndex = 0;
  static double currentValue = 0;
  static int length = 0;
  static Category? category;
  int score = 0;

  static Future<void> loadTasksFromFirestore() async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
      await FirebaseFirestore.instance.collection('objects').get();

      tasks.clear(); // Очищаем список перед загрузкой новых данных

      querySnapshot.docs.forEach((doc) {
        Object object = Object(
          id_objects: doc.id ?? '',
          name: doc['name'] ?? '',
          name_categories: doc['category'] ?? '',
          url: doc['url'] ?? '',
        );
        tasks.add(object);
      });

      print('Tasks loaded successfully.');
    } catch (e) {
      print('Error loading tasks: $e');
    }
  }

  static void showNextImage() {
    currentTaskIndex = (currentTaskIndex + 1) % length;
  }

  static void showPrevImage() {
    currentTaskIndex = (currentTaskIndex - 1 + length) % length;
  }
  static void countValue(){
    currentValue = (currentTaskIndex/length);
  }

}