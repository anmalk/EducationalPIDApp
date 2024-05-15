import 'package:EducationalApp/models/object_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class Task {
  final String id;
  final String idCategory;
  final List<Map<Object, dynamic>> objectsDataDiffCategories;
  final List<Map<Object, dynamic>> objectsDataOneCategory;

  Task({
    required this.id,
    required this.idCategory,
    required this.objectsDataDiffCategories,
    required this.objectsDataOneCategory,
  });
}

class TaskController_more {
  static List<Task> tasks = [];
  static int currentTaskIndex = 0;
  static double currentValue = 0;
  static int length = 0;
  static Category? category;
  static int score = 0;
  static User? user;

  static Future<List<Task>> fetchTasksFromFirestore() async {
    List<Task> tasks = [];

    try {
      QuerySnapshot tasksSnapshot = await FirebaseFirestore.instance.collection('tasks_more').get();

      for (QueryDocumentSnapshot taskDoc in tasksSnapshot.docs) {
        String idCategory = taskDoc['id_category'];
        List<String> idObjectsDiffCategories = List<String>.from(taskDoc['id_objects_diff_categories']);
        List<String> idObjectsOneCategory = List<String>.from(taskDoc['id_objects_one_category']);

        List<Map<Object, dynamic>> objectsDiffCategories = await fetchObjectsData(idObjectsDiffCategories);
        List<Map<Object, dynamic>> objectsOneCategory = await fetchObjectsData(idObjectsOneCategory);

        Task task = Task(
          id: taskDoc.id,
          idCategory: idCategory,
          objectsDataDiffCategories: objectsDiffCategories,
          objectsDataOneCategory: objectsOneCategory,
        );

        tasks.add(task);
      }
    } catch (e) {
      print('Error fetching tasks from Firestore: $e');
    }

    return tasks;
  }

  static  Future<List<Map<Object, dynamic>>> fetchObjectsData(List<String> objectIds) async {
    List<Map<Object, dynamic>> objectsData = [];

    try {
      QuerySnapshot objectsSnapshot = await FirebaseFirestore.instance.collection('objects').where(FieldPath.documentId, whereIn: objectIds).get();

      for (QueryDocumentSnapshot objectDoc in objectsSnapshot.docs) {
        Object object = Object(
          id_objects: objectDoc.id,
          name: objectDoc['name'],
          name_categories: objectDoc['category'],
          url: objectDoc['url'],
        );

        Map<Object, dynamic> objectData = {
          object: {
            'id_objects': object.id_objects,
            'name': object.name,
            'id_categories': object.name_categories,
            'url': object.url,
          }
        };

        objectsData.add(objectData);
      }
    } catch (e) {
      print('Error fetching objects data from Firestore: $e');
    }

    return objectsData;
  }

  static void showNextTask() {
    currentTaskIndex = (currentTaskIndex + 1);
  }

  static void showPrevTask() {
    currentTaskIndex = (currentTaskIndex - 1 + length) % length;
  }
  static void countValue(){
    currentValue = (currentTaskIndex/length);
  }

}