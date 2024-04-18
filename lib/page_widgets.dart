import 'package:flutter/material.dart';
import 'package:EducationalApp/services/db.dart';
import 'models/task_controller.dart';
import 'widgets/helpiconbutton.dart';
import 'widgets/textcategorystatefulwidget.dart';
import 'widgets/categoryiconbutton.dart';
import 'widgets/functions.dart';
import 'models/object_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


Widget buildHomePage(Map<String, dynamic>? pageData) {

  if (pageData == null || pageData.isEmpty) {
    return Center(
      child: Text('Page data is empty.'),
    );
  }

  return SingleChildScrollView(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: 40), // Пустое пространство наверху экрана
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: PrevNextWidget(
                prevData: pageData['Home page']['Next/Prev'],
                nextData: pageData['Home page']['Next/Prev'],
                helpImageUrlData: pageData['Home page']['help_image'],
                categoryOneImageUrlData: pageData['Home page']['image_category1'],
                categoryTwoImageUrlData: pageData['Home page']['image_category2'],
                textData: pageData['Home page']['Text_category'],
                textData2: pageData['Home page']['Text_object'],
                textData3: pageData['Home page']['Text_category1'],
                textData4: pageData['Home page']['Text_category2'],

              ),
            ),
          ],
        ),
        SizedBox(height: 10), // Пустое пространство наверху экрана

        ProgressBarWidget(progressBarData: pageData['Home page']['Progress Bar'], currentTaskIndex: TaskController.currentTaskIndex, totalImages: TaskController.length),
      ],
    ),
  );
}

class PrevNextWidget extends StatefulWidget {
  final Map<String, dynamic>? prevData;
  final Map<String, dynamic>? nextData;
  final Map<String, dynamic>? helpImageUrlData;
  final Map<String, dynamic>? categoryOneImageUrlData;
  final Map<String, dynamic>? categoryTwoImageUrlData;
  final Map<String, dynamic>? textData;
  final Map<String, dynamic>? textData2;
  final Map<String, dynamic>? textData3;
  final Map<String, dynamic>? textData4;


  PrevNextWidget({
    this.prevData,
    this.nextData,
    this.helpImageUrlData,
    this.categoryOneImageUrlData,
    this.categoryTwoImageUrlData,
    this.textData,
    this.textData2,
    this.textData3,
    this.textData4,
  });

  @override
  _PrevNextWidgetState createState() => _PrevNextWidgetState();
}

class _PrevNextWidgetState extends State<PrevNextWidget> {
  bool _isCategoryEqual = false; // Пример значения сравнения категорий

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            PrevWidget(prevData: widget.prevData),
            Spacer(), // Равномерно распределить пространство между Prev и Next
            TextCategoryStatefulWidget(value: TaskController.category!.name, fontSize: 40, textData: widget.textData, currentTaskIndex: TaskController.currentTaskIndex), // Новый stateful виджет текстового поля
            Spacer(), // Равномерно распределить пространство между Next и новым виджетом
            NextWidget(nextData: widget.nextData),
          ],
        ),
        SizedBox(height: 10), // Вы можете настроить нужный вам вертикальный отступ
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0), // Увеличиваем отступы слева и справа
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end, // Выравнивание элементов по правому краю
            children: [
              Stack(
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: HelpIconButton(
                      onPressed: () {
                        // Обработчик нажатия кнопки
                      },
                      helpImageUrlData: widget.helpImageUrlData,
                    ),
                  ),
                  SizedBox(
                    width: 110, // Ширина виджета HelpIconButton
                    height: 110, // Высота виджета HelpIconButton
                  ),
                ],
              ),
              SizedBox(height: 10), // Отступ между кнопкой помощи и изображением
              Center(
                child: Column(
                  children: [
                    TextStatefulWidget(fontSize: 30, textData: widget.textData2, currentTaskIndex: TaskController.currentTaskIndex), // TextStatefulWidget над изображением
                    ImageWidget(currentTaskIndex: TaskController.currentTaskIndex)
                  ],
                ),
              ),

              SizedBox(height: 1), // Отступ между изображением и кнопками категорий
              Row(
                mainAxisAlignment: MainAxisAlignment.center, // Выравнивание кнопок по центру
                children: [
                  Column(
                    children: [
                      TextCategoryStatefulWidget(value: TaskController.category!.category1, fontSize: 20, textData: widget.textData3, currentTaskIndex: TaskController.currentTaskIndex), // Виджет TextStatefulWidget над первой кнопкой категории
                      CategoryIconButton(
                        isCategoryEqual: _isCategoryEqual,
                        categoryImageUrlData: widget.categoryOneImageUrlData,
                          areCategoriesEqual: areCategoriesEqual,
                      ),
                    ],
                  ),
                  SizedBox(width: 40), // Отступ между кнопками
                  Column(
                    children: [
                      TextCategoryStatefulWidget(value: TaskController.category!.category2, fontSize: 20, textData: widget.textData4, currentTaskIndex: TaskController.currentTaskIndex), // Виджет TextStatefulWidget над второй кнопкой категории
                      CategoryIconButton(
                        isCategoryEqual: _isCategoryEqual,
                        categoryImageUrlData: widget.categoryTwoImageUrlData,
                        areCategoriesEqual: areCategoriesNotEqual,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}



class TextStatefulWidget extends StatefulWidget {
  static _TextStatefulWidgetState? _textStatefulWidgetState;
  final double fontSize; // Поле для размера текста
  final Map<String, dynamic>? textData;
  int currentTaskIndex;


  TextStatefulWidget({required this.fontSize, required this.textData, required this.currentTaskIndex});

  @override
  _TextStatefulWidgetState createState() {
    _textStatefulWidgetState = _TextStatefulWidgetState();
    return _textStatefulWidgetState!;
  }
}

class _TextStatefulWidgetState extends State<TextStatefulWidget> {
  @override
  void initState() {
    super.initState();
    // Загрузка текстовых данных из базы данных Firestore
    //loadTextDataFromFirestore();
  }



  @override
  Widget build(BuildContext context) {
    bool isVisible = widget.textData?['params']?['Is visible']?['value'] ?? false;

    // Проверяем, что textValue не пустой, прежде чем отображать текст
    if ( TaskController.tasks.isNotEmpty) {
      return Visibility(
        visible: isVisible,
        child: Text(
          TaskController.tasks[TaskController.currentTaskIndex].name,
          style: TextStyle(
            fontSize: widget.fontSize,
          ),
        ),
      );
    } else {
      // Если textValue пустой, отображаем какое-то заглушечное значение или индикатор загрузки
      return CircularProgressIndicator(); // пример заглушки
    }
  }

  // Метод для обновления текста при изменении состояния
  void updateText() {
    setState(() {
    });
  }
}

class PrevWidget extends StatefulWidget {
  final Map<String, dynamic>? prevData;

  PrevWidget({this.prevData});

  @override
  _PrevWidgetState createState() => _PrevWidgetState();
}

class _PrevWidgetState extends State<PrevWidget> {
  @override
  Widget build(BuildContext context) {
    if (widget.prevData == null || widget.prevData!.isEmpty) {
      return Container();
    }

    String iconValue = widget.prevData!['params']['Icon']['value'];
    String iconText = getOptionText(widget.prevData!['params']['Icon']['options'], iconValue);
    String colorName = widget.prevData!['params']['Color']['value']; // Convert color value to Color object
    Color customColor = getColorFromString(colorName);
    //print(customColor);
    return Padding(
      padding: EdgeInsets.only(left: 16.0),
      child: RawMaterialButton(
        onPressed: () {
          setState(() {
            TaskController.showPrevImage();
            ImageWidget._imageWidgetState?.updateImage();
            TaskController.countValue();
            TextStatefulWidget._textStatefulWidgetState?.updateText();
            ProgressBarWidget._progressBarWidgetState?.updateProgressBar();
          });
        },
        padding: EdgeInsets.all(16.0), // Отступы внутри кнопки
        constraints: BoxConstraints(minWidth: 60.0, minHeight: 60.0), // Установка минимального размера
        materialTapTargetSize: MaterialTapTargetSize.padded, // Увеличение области нажатия
        shape: CircleBorder(),
        fillColor: customColor,
        child: Icon(getPrevIconData(iconValue), color: Colors.white),
      ),
    );
  }
}


class NextWidget extends StatefulWidget {
  final Map<String, dynamic>? nextData;

  NextWidget({this.nextData});

  @override
  _NextWidgetState createState() => _NextWidgetState();
}

class _NextWidgetState extends State<NextWidget> {
  @override
  Widget build(BuildContext context) {
    if (widget.nextData == null || widget.nextData!.isEmpty) {
      return Container();
    }

    String iconValue = widget.nextData!['params']['Icon']['value'];
    String iconText =
    getOptionText(widget.nextData!['params']['Icon']['options'], iconValue);
    String colorName = widget.nextData!['params']['Color']['value']; // Convert color value to Color object
    Color customColor = getColorFromString(colorName);

    return Padding(
      padding: EdgeInsets.only(right: 16.0),
      child: RawMaterialButton(
        onPressed: () {
          setState(() {
            TaskController.showNextImage();
            TaskController.countValue();
            ImageWidget._imageWidgetState?.updateImage();
            TextStatefulWidget._textStatefulWidgetState?.updateText();
            ProgressBarWidget._progressBarWidgetState?.updateProgressBar();
          });
        },
        shape: CircleBorder(),
        padding: EdgeInsets.all(16.0), // Отступы внутри кнопки
        constraints: BoxConstraints(minWidth: 60.0, minHeight: 60.0), // Установка минимального размера
        materialTapTargetSize: MaterialTapTargetSize.padded, // Увеличение области нажатия
        fillColor: customColor,
        child: Icon(getNextIconData(iconValue), color: Colors.white),
      ),
    );
  }
}

class ImageWidget extends StatefulWidget {
  static _ImageWidgetState? _imageWidgetState;
  final int currentTaskIndex; // Добавлено поле currentTaskIndex

  ImageWidget({required this.currentTaskIndex}); // Добавлен конструктор

  @override
  _ImageWidgetState createState() {
    _imageWidgetState = _ImageWidgetState();
    return _imageWidgetState!;
  }
}


class _ImageWidgetState extends State<ImageWidget> {

  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    // Проверяем, что imageUrl не пустой, прежде чем отображать изображение
    if (TaskController.tasks.isNotEmpty) {
      return Image.network(
        TaskController.tasks[TaskController.currentTaskIndex].url.toString(),
        height: 300,
        width: 300,
      );
    } else {
      // Если imageUrl пустой, отображаем какое-то заглушечное изображение или индикатор загрузки
      return CircularProgressIndicator(); // пример заглушки
    }
  }

  // Метод для обновления изображения при изменении состояния
  void updateImage() {
    setState(() {
    });
  }
}


class ProgressBarWidget extends StatefulWidget {
  static _ProgressBarWidgetState? _progressBarWidgetState;
  final Map<String, dynamic> progressBarData;
  int currentTaskIndex;
  int totalImages;

  ProgressBarWidget({
    required this.progressBarData,
    required this.currentTaskIndex,
    required this.totalImages,
  });

  @override
  _ProgressBarWidgetState createState() {
    _progressBarWidgetState = _ProgressBarWidgetState();
    return _progressBarWidgetState!;
  }
}

class _ProgressBarWidgetState extends State<ProgressBarWidget> {
  @override
  Widget build(BuildContext context) {
    bool isVisible = widget.progressBarData['params']['Is visible']['value'];
    String colorName = widget.progressBarData!['params']['Color']['value']; // Convert color value to Color object
    Color customColor = getColorFromString(colorName);
    String sizeValue = widget.progressBarData!['params']['Size']['value'];

    return Visibility(
      visible: isVisible,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.0), // Измените значения по своему усмотрению
        child: LinearProgressIndicator(
          color: customColor,
          // Дополнительные параметры для настройки индикатора прогресса
          minHeight: getSizeProgressBarData(sizeValue),
          borderRadius: BorderRadius.circular(10),
          value: TaskController.currentValue,
        ),
      ),
    );
  }

  void updateProgressBar() {
    setState(() {});
    print(TaskController.currentValue);
    print(TaskController.tasks[TaskController.currentTaskIndex].id_objects);
    print(TaskController.tasks[TaskController.currentTaskIndex].name);
    print(TaskController.tasks[TaskController.currentTaskIndex].name_categories);
    print(TaskController.tasks[TaskController.currentTaskIndex].url);
    print(TaskController.tasks[TaskController.currentTaskIndex].isAnswered);
    print(TaskController.tasks[TaskController.currentTaskIndex].isTrueAnswer);

  }
}