import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:EducationalApp/models/object_model.dart';
import 'package:EducationalApp/models/task_controller.dart';


class DatabaseService {
  // Метод для загрузки данных из Firestore и сохранения их в список объектов
  static Future<List<Object>> getObjects(String name, String name_false_category) async {
    List<Object> objects = [];

    try {
      // Получаем доступ к коллекции объектов в Firestore
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore.instance
          .collection('objects')
          .where('category', whereIn: [name, name_false_category])
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

      return objects;
    } catch (e) {
      // Обработка ошибок, например, если произошла ошибка доступа к Firestore
      print('Error loading objects: $e');
      return []; // Возвращаем пустой список в случае ошибки
    }
  }

  static initFirebase() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
  }

  Future<int> getCountOfObjects() async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
    await FirebaseFirestore.instance.collection('objects').get();

    int count = querySnapshot.size; // Получаем количество документов в коллекции
    print('Количество документов в коллекции "objects": $count');

    return count;
  }

  static Future<Category?> getCategoryData() async {
    try {
      DocumentReference documentReference =
      FirebaseFirestore.instance.collection('categories').doc('1');

      DocumentSnapshot snapshot = await documentReference.get();

      if (snapshot.exists) {
        // Документ существует, создаем объект Category и возвращаем его
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








