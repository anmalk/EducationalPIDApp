import 'package:EducationalApp/models/object_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Task {
  final String category;
  final List<ImageData> images;

  Task({required this.category, required this.images});
}

class ImageData {
  final String id;
  final String name;
  final String category;
  final String url;

  ImageData({required this.id, required this.name, required this.category, required this.url});
}



class TaskController_more {
  static List<Task> tasks = [];
  static int currentTaskIndex = 0;
  static double currentValue = 0;
  static int length = 0;
  static Category? category;
  static int score = 0;
  static User? user;


  static Future<List<Task>> fetchTasks() async {
    List<Task> tasks = [];

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('tasks_2').get();

    for (QueryDocumentSnapshot doc in querySnapshot.docs) {
      List<ImageData> images = [];

      List<dynamic> imageIds = doc['images'];

      for (String imageId in imageIds) {
        DocumentSnapshot imageDoc = await FirebaseFirestore.instance.collection('objects').doc(imageId).get();
        if (imageDoc.exists) {
          images.add(ImageData(
            id: imageDoc.id,
            category: imageDoc['category'],
            name: imageDoc['name'],
            url: imageDoc['url'],
          ));
        }
      }

      tasks.add(Task(
        category: doc['category'],
        images: images,
      ));
    }

    return tasks;
  }

  static void showNextTask() {
    currentTaskIndex = (currentTaskIndex + 1);
  }


  static void countValue(){
    currentValue = (currentTaskIndex/length);
  }

}