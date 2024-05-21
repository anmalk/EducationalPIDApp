import 'package:flutter/material.dart';
import 'package:EducationalApp/services/db.dart';
import 'models/task_more_controller.dart';
import 'widgets/helpiconbutton.dart';
import 'widgets/textcategorystatefulwidget.dart';
import 'widgets/categoryiconbutton.dart';
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
  return SingleChildScrollView(
    padding: EdgeInsets.all(20.0),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            HelpIconButton(onPressed:() {

            },
              helpImageUrlData: pageData['Task page']['help_image'],), // Ваша кнопка HelpButton
          ],
        ),
        SizedBox(height: 0),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10), // Задайте радиус для создания закругленных углов
            border: Border.all(
              color: Colors.black, // Задайте цвет рамки
              width: 2, // Задайте толщину рамки
            ),
          ),
          child: Container(

            padding: EdgeInsets.all(10), // Отступы для контейнера с изображениями
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.network(
                      TaskController_more.tasks[0].objectsDataDiffCategories[0].values.elementAt(0)['url'],
                      width: 190,
                      height: 190,
                    ),
                    Image.network(
                      TaskController_more.tasks[0].objectsDataDiffCategories[0].values.elementAt(1)['url'],
                      width: 190,
                      height: 190,
                    ),
                  ],
                ),
                SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.network(
                      TaskController_more.tasks[0].objectsDataDiffCategories[0].values.elementAt(2)['url'],
                      width: 190,
                      height: 190,
                    ),
                    Image.network(
                      'https://img.lovepik.com/element/40117/2354.png_860.png',
                      width: 150,
                      height: 150,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 10),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 8.0,
          children: [
            ElevatedButton(
              onPressed: () {
                //print(TaskController_more.tasks[0].objectsDataDiffCategories[0].values.elementAt(2)['name_category']);
                //print(TaskController_more.tasks[0].objectsDataOneCategory[0].values.elementAt(1)['name_category']);

                if(TaskController_more.tasks[0].objectsDataDiffCategories[0].values.elementAt(0)['name_category'] != TaskController_more.tasks[0].objectsDataOneCategory[0].values.elementAt(2)['name_category'])
                {

                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ResultPage()),
                  );
                }
              },
              child: Image.network(
                TaskController_more.tasks[0].objectsDataOneCategory[0].values.elementAt(0)['url'],
                width: 150,
                height: 150,
              ),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10), // Задайте радиус для создания закругленных углов кнопки
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                if(TaskController_more.tasks[0].objectsDataDiffCategories[0].values.elementAt(1)['name_category'] == TaskController_more.tasks[0].objectsDataOneCategory[0].values.elementAt(2)['name_category'])
                {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ResultPage()),
                  );
                }
              },
              child: Image.network(
                TaskController_more.tasks[0].objectsDataOneCategory[0].values.elementAt(1)['url'],
                width: 150,
                height: 150,
              ),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10), // Задайте радиус для создания закругленных углов кнопки
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                if(TaskController_more.tasks[0].objectsDataDiffCategories[0].values.elementAt(2)['name_category'] != TaskController_more.tasks[0].objectsDataOneCategory[0].values.elementAt(2)['name_category'])
                  {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ResultPage()),
                    );
                  }
              },
              child: Image.network(
                TaskController_more.tasks[0].objectsDataOneCategory[0].values.elementAt(2)['url'],
                width: 150,
                height: 150,
              ),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10), // Задайте радиус для создания закругленных углов кнопки
                ),
              ),
            ),
            // Добавьте столько изображений, сколько вам нужно
          ],
        ),
        SizedBox(height: 20),
        ProgressBarWidget(progressBarData: pageData['Task page']['Progress Bar'], currentTaskIndex: TaskController_more.currentTaskIndex, totalImages: TaskController_more.length),
      ],
    ),
  );
}


