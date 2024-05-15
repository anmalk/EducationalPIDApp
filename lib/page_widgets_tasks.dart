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


Widget buildTasksPage(Map<String, dynamic>? pageData) {
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
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            HelpIconButton(onPressed:() {

            },
              helpImageUrlData: pageData['Task page']['help_image'],), // Ваша кнопка HelpButton
          ],
        ),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.network(
              TaskController_more.tasks[0].objectsDataDiffCategories[0].values.elementAt(0)['url'],
              width: 190, // Задайте ширину изображения
              height: 190, // Задайте высоту изображения
            ),
            Image.network(
              TaskController_more.tasks[0].objectsDataDiffCategories[0].values.elementAt(1)['url'],
              width: 190, // Задайте ширину изображения
              height: 190, // Задайте высоту изображения
            ),
          ],
        ),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.network(
              TaskController_more.tasks[0].objectsDataDiffCategories[0].values.elementAt(2)['url'],
              width: 190, // Задайте ширину изображения
              height: 190, // Задайте высоту изображения
            ),
            Image.network(
              'https://img.lovepik.com/element/40117/2354.png_860.png',
              width: 190, // Задайте ширину изображения
              height: 190, // Задайте высоту изображения
            ),
          ],
        ),
        SizedBox(height: 70),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 8.0,
          children: [
            Image.network(
              TaskController_more.tasks[0].objectsDataOneCategory[0].values.elementAt(0)['url'],
              width: 120, // Задайте ширину изображения
              height: 120, // Задайте высоту изображения
            ),
            Image.network(
              TaskController_more.tasks[0].objectsDataOneCategory[0].values.elementAt(1)['url'],
              width: 120, // Задайте ширину изображения
              height: 120, // Задайте высоту изображения
            ),
            Image.network(
              TaskController_more.tasks[0].objectsDataOneCategory[0].values.elementAt(2)['url'],
              width: 120, // Задайте ширину изображения
              height: 120, // Задайте высоту изображения
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


