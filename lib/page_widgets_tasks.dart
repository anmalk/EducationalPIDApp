import 'package:flutter/material.dart';
import 'package:EducationalApp/services/db.dart';
import 'models/task_more_controller.dart';
import 'widgets/helpiconbutton.dart';
import 'widgets/functions.dart';
import 'models/object_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'result_page.dart';
import 'dart:async';
import 'tasks_page.dart';
import 'page_widgets.dart';


Widget buildTasksPage(BuildContext context, Map<String, dynamic>? pageData) {
  if (pageData == null || pageData.isEmpty) {
    return Center(
      child: Text('Page data is empty.'),
    );
  }

  return Scaffold(
    appBar: AppBar(
      title: Text('Game'),
    ),
    body: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 20),
          Text(
            'Find the matching image',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              for (int i = 0; i < 3; i++)
                GestureDetector(
                  onTap: () {
                  },
                  child: Image.network(
                    TaskController_more.tasks[TaskController_more.currentTaskIndex].images[i].url,
                    width: 100,
                    height: 100,
                  ),
                ),
            ],
          ),
          SizedBox(height: 20),
          Text(
            'Select one of these:',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              for (int i = 3; i < 6; i++)
                GestureDetector(
                  onTap: () {
                    if (TaskController_more.tasks[TaskController_more.currentTaskIndex].category ==
                        TaskController_more.tasks[TaskController_more.currentTaskIndex].images[i].category) {
                      _showCorrectAnimation(context);
                    } else {
                      _showIncorrectAnimation(context);
                    }
                  },
                  child: Image.network(
                    TaskController_more.tasks[TaskController_more.currentTaskIndex].images[i].url,
                    width: 100,
                    height: 100,
                  ),
                ),
            ],
          ),
        ],
      ),
    ),
  );
}

void _showCorrectAnimation(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Correct!'),
        content: Text('You found the matching image.'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('OK'),
          ),
        ],
      );
    },
  );
}

void _showIncorrectAnimation(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Incorrect!'),
        content: Text('Sorry, try again.'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('OK'),
          ),
        ],
      );
    },
  );
}
