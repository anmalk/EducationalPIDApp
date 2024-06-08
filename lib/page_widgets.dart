import 'package:flutter/material.dart';
import 'models/task_controller.dart';
import 'widgets/helpiconbutton.dart';
import 'widgets/textcategorystatefulwidget.dart';
import 'widgets/functions.dart';
import 'help_page.dart';
import 'result_page.dart';
import 'dart:async';
import 'package:audioplayers/audioplayers.dart';


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
                prevData: pageData['Home page']['Next/Prev'], nextData: pageData['Home page']['Next/Prev'],
                helpImageUrlData: pageData['Home page']['help_image'], categoryOneImageUrlData: pageData['Home page']['image_category1'],
                categoryTwoImageUrlData: pageData['Home page']['image_category2'], trueImageUrlData: pageData['Answer true page']['true_image'],
                falseImageUrlData: pageData['Answer false page']['true_image'], returnImageUrlData: pageData['Answer true page']['return_image'],
                textData: pageData['Home page']['Text_category'], textData2: pageData['Home page']['Text_object'],
                textData3: pageData['Home page']['Text_category1'], textData4: pageData['Home page']['Text_category2'],
                textData5: pageData['Answer true page']['Text_true'], textData6: pageData['Answer false page']['Text_false'],
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

// Виджет задания
class PrevNextWidget extends StatefulWidget {
  final Map<String, dynamic>? prevData;
  final Map<String, dynamic>? nextData;
  final Map<String, dynamic>? helpImageUrlData;
  final Map<String, dynamic>? categoryOneImageUrlData;
  final Map<String, dynamic>? categoryTwoImageUrlData;
  final Map<String, dynamic>? trueImageUrlData;
  final Map<String, dynamic>? falseImageUrlData;
  final Map<String, dynamic>? returnImageUrlData;
  final Map<String, dynamic>? textData;
  final Map<String, dynamic>? textData2;
  final Map<String, dynamic>? textData3;
  final Map<String, dynamic>? textData4;
  final Map<String, dynamic>? textData5;
  final Map<String, dynamic>? textData6;


  PrevNextWidget({
    this.prevData, this.nextData, this.helpImageUrlData, this.categoryOneImageUrlData, this.categoryTwoImageUrlData,
    this.trueImageUrlData, this.falseImageUrlData, this.returnImageUrlData, this.textData,
    this.textData2, this.textData3, this.textData4, this.textData5, this.textData6
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
            Expanded(
              child: PrevWidget(prevData: widget.prevData),
            ),
            Expanded(
              flex: 3, // Увеличьте этот flex, чтобы AutoScrollText занимал больше места
              child: Center(
                child: AutoScrollText(
                  text: TaskController.category!.name,
                  textStyle: TextStyle(fontSize: 40.0), // Размер шрифта по вашему выбору
                  scrollSpeed: 50.0, // Скорость прокрутки по вашему выбору
                ),
              ),
            ),
            Expanded(
              child: NextWidget(nextData: widget.nextData),
            ),
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
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return HelpDialog(
                              title: 'Помощь',
                              content: 'Выбери верный ответ, нажав на одну из кнопок!',
                            );
                          },
                        );
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
                        trueImageUrlData: widget.trueImageUrlData,
                        falseImageUrlData: widget.falseImageUrlData,
                        returnImageUrlData: widget.returnImageUrlData,
                        //trueTextUrlData: widget.textData5,
                        //falseTextUrlData: widget.textData6,
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
                        trueImageUrlData: widget.trueImageUrlData,
                        falseImageUrlData: widget.falseImageUrlData,
                        returnImageUrlData: widget.returnImageUrlData,
                        //trueTextUrlData: widget.textData5,
                        //falseTextUrlData: widget.textData6,
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

// Виджет автоматической прокрутки текста
class AutoScrollText extends StatefulWidget {
  final String text;
  final TextStyle textStyle;
  final double scrollSpeed;

  const AutoScrollText({
    Key? key,
    required this.text,
    this.textStyle = const TextStyle(fontSize: 16.0),
    this.scrollSpeed = 50.0, // Скорость прокрутки по умолчанию (пиксели в секунду)
  }) : super(key: key);

  @override
  _AutoScrollTextState createState() => _AutoScrollTextState();
}

class _AutoScrollTextState extends State<AutoScrollText> {
  late ScrollController _controller;
  late double _scrollPosition;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _controller = ScrollController();
    _scrollPosition = 0.0;

    // Создаем таймер для автоматической прокрутки текста
    _timer = Timer.periodic(Duration(milliseconds: 50), (timer) {
      setState(() {
        _scrollPosition += widget.scrollSpeed / 20.0; // Увеличиваем позицию прокрутки на основе скорости
        if (_scrollPosition > _controller.position.maxScrollExtent) {
          _scrollPosition = _controller.position.minScrollExtent;
        }
        _controller.jumpTo(_scrollPosition); // Прокручиваем текст до новой позиции
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel(); // Отменяем таймер при удалении виджета
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal, // Горизонтальная прокрутка
      controller: _controller,
      child: Text(
        widget.text,
        style: widget.textStyle,
      ),
    );
  }
}

// Виджет текста
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

// Виджет кнопки "Предыдущее"
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

// Виджет кнопки "Следующее"
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
            print(TaskController.currentTaskIndex);
            print(TaskController.length);
            if (TaskController.currentTaskIndex == TaskController.length) {
              setState(() {
                // Переход на страницу ResultPage
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ResultPage()),
                );
              });
            }
            if (TaskController.currentTaskIndex <= TaskController.length -1) {
              TaskController.countValue();
              ImageWidget._imageWidgetState?.updateImage();
              TextStatefulWidget._textStatefulWidgetState?.updateText();
              ProgressBarWidget._progressBarWidgetState?.updateProgressBar();
            }
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

// Виджет изображения
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

// Виджет индикатора прогресса выполнения заданий
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

  // Метод обновления индикатора прогресса
  void updateProgressBar() {
    setState(() {
    });
  }
}

// Виджет кнопок ответов - категорий
class CategoryIconButton extends StatefulWidget {
  final bool isCategoryEqual;
  final Map<String, dynamic>? categoryImageUrlData;
  final Map<String, dynamic>? trueImageUrlData;
  final Map<String, dynamic>? falseImageUrlData;
  final Map<String, dynamic>? returnImageUrlData;
  final bool Function(String?) areCategoriesEqual;

  const CategoryIconButton({
    required this.isCategoryEqual,
    this.categoryImageUrlData,
    this.trueImageUrlData,
    this.falseImageUrlData,
    this.returnImageUrlData,
    required this.areCategoriesEqual,
  });

  @override
  _CategoryIconButtonState createState() => _CategoryIconButtonState();
}

class _CategoryIconButtonState extends State<CategoryIconButton> {
  double _size = 110.0;

  @override
  Widget build(BuildContext context) {
    String categoryImageUrl = widget.categoryImageUrlData!['params']['Image']['value'];
    String trueImageUrl = widget.trueImageUrlData!['params']['Image']['value'];
    String falseImageUrl = widget.falseImageUrlData!['params']['Image']['value'];
    String returnImageUrl = widget.returnImageUrlData!['params']['Image']['value'];

    return GestureDetector(
      onTapDown: (_) {
        setState(() {
          _size = 80.0;
        });
        Future.delayed(Duration(milliseconds: 200), () {
          compareCategories(context, widget.areCategoriesEqual, trueImageUrl, falseImageUrl, returnImageUrl);
        });
      },
      onTapUp: (_) {
        setState(() {
          _size = 110.0;
        });
      },
      onTapCancel: () {
        setState(() {
          _size = 110.0;
        });
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        width: _size,
        height: _size,
        child: MaterialButton(
          minWidth: 110,
          height: 110,
          splashColor: Colors.transparent,
          onPressed: () {},
          child: Image.network(
            categoryImageUrl,
            width: 110,
            height: 110,
          ),
        ),
      ),
    );
  }
}

// Определение верности ответа
void compareCategories(BuildContext context, bool Function(String?) areCategoriesEqual, String imageTrue, String imageFalse, String imageReturn) async {
  String? categoryFromFirestore = TaskController.tasks[TaskController.currentTaskIndex].name_categories;
  bool result = areCategoriesEqual(categoryFromFirestore);

  TaskController.tasks[TaskController.currentTaskIndex].isAnswered = true;

  if (result) {
    TaskController.tasks[TaskController.currentTaskIndex].isTrueAnswer = true;
    TaskController.score++;
    print("Correct Answer. Score: ${TaskController.score}");
  } else {
    TaskController.tasks[TaskController.currentTaskIndex].isTrueAnswer = false;
    print("Incorrect Answer. Score: ${TaskController.score}");
  }

  final player = AudioPlayer();

  if (result) {
    await player.play(AssetSource('sounds/true.mp3'));
  } else {
    await player.play(AssetSource('sounds/false.mp3'));
  }

  showResultDialog(context, result, imageTrue, imageFalse, imageReturn);
}

// Показ результата с звуковым эффектом
void showResultDialog(BuildContext context, bool result, String imageTrue, String imageFalse, String imageReturn) {
  showDialog(
    context: context,
    builder: (context) {
      bool visible = false;

      return AlertDialog(
        title: Text(''),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.network(
              result ? imageTrue : imageFalse,
              height: 100,
            ),
            SizedBox(height: 16),
            Visibility(
              visible: visible,
              child: Text(
                result ? 'Ты выбрал правильный ответ!' : 'Ты выбрал неправильный ответ!',
                style: TextStyle(fontSize: 20),
              ),
            ),
          ],
        ),
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
              if(result) {
                TaskController.showNextImage();
                print(TaskController.currentTaskIndex);
                print(TaskController.length);
                if (TaskController.currentTaskIndex == TaskController.length) {

                    // Переход на страницу ResultPage
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ResultPage()),
                    );

                }
                if (TaskController.currentTaskIndex <= TaskController.length -1) {
                  TaskController.countValue();
                  ImageWidget._imageWidgetState?.updateImage();
                  TextStatefulWidget._textStatefulWidgetState?.updateText();
                  ProgressBarWidget._progressBarWidgetState?.updateProgressBar();
                }
              }
            },
            child: Image.network(
              imageReturn,
              height: 50,
            ),
          ),
        ],
        backgroundColor: result ? Colors.green[100] : Colors.red[100],
      );
    },
  );
}

bool areCategoriesEqual(String? categoryFromFirestore) {
  String? categoryFromImageData = TaskController.category?.name;

  if (categoryFromFirestore != null && categoryFromImageData != null) {
    return categoryFromFirestore == categoryFromImageData;
  } else {
    return false;
  }
}

bool areCategoriesNotEqual(String? categoryFromFirestore) {
  String? categoryFromImageData = TaskController.category?.name;

  if (categoryFromFirestore != null && categoryFromImageData != null) {
    return categoryFromFirestore != categoryFromImageData;
  } else {
    return false;
  }
}