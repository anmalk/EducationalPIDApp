import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:EducationalApp/models/object_model.dart';
import 'package:EducationalApp/models/task_controller.dart';

// Сервис для работы с базой данных Firestore
class DatabaseService {
  // Метод для загрузки данных из Firestore и сохранения их в список объектов
  static Future<List<Object>> getObjects(String name) async {
    List<Object> objects = [];

    try {
      // Получаем доступ к коллекции объектов в Firestore и выбираем объекты по категории
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore.instance
          .collection('objects')
          .where('category', whereIn: [name])
          .get();

      // Перебираем все документы в коллекции и добавляем их в список объектов
      querySnapshot.docs.forEach((doc) {
        objects.add(Object(
          id_objects: doc['id'],
          name: doc['name'],
          name_categories: doc['category'],
          url: doc['imageUrl'],
        ));
      });

      return objects; // Возвращаем список объектов
    } catch (e) {
      // Обработка ошибок, например, если произошла ошибка доступа к Firestore
      print('Error loading objects: $e');
      return []; // Возвращаем пустой список в случае ошибки
    }
  }

  // Метод для инициализации Firebase
  static initFirebase() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
  }

  // Метод для получения количества объектов в коллекции
  Future<int> getCountOfObjects() async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
    await FirebaseFirestore.instance.collection('objects').get();

    int count = querySnapshot.size; // Получаем количество документов в коллекции
    print('Количество документов в коллекции "objects": $count');

    return count;
  }

  // Метод для получения данных категории из Firestore
  static Future<Category?> getCategoryData(String name) async {
    try {
      // Запрос к коллекции категорий для получения данных по имени категории
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('categories')
          .where('name', isEqualTo: name) // Замените 'ваше_значение_name' на фактическое имя
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Если найден хотя бы один документ, берем первый и создаем объект Category
        DocumentSnapshot snapshot = querySnapshot.docs.first;
        return Category(
          id: snapshot.id,
          name: snapshot['name'],
          category1: snapshot['category1'],
          category2: snapshot['category2'],
        );
      } else {
        print('Document does not exist');
        return null;
      }
    } catch (e) {
      print('Error reading document: $e');
      return null;
    }
  }
}
