import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'services/storage_service.dart';  // Импортируйте ваш StorageService
import 'page_widgets.dart';
import 'models/task_controller.dart';
import 'models/object_model.dart';
import 'package:EducationalApp/services/db.dart';
import 'my_home_page.dart';
import 'choice_category_page.dart';
import 'my_app.dart';

class ResultPage extends StatefulWidget {
  @override
  _ResultPageState createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  late Map<String, dynamic> jsonData;
  final StorageService storageService = StorageService(); // Создайте экземпляр StorageService
  late String id = ''; // замените 'id' на актуальное поле из ответа сервера


  @override
  void initState() {
    super.initState();
    DatabaseService.initFirebase();
    jsonData = {};
    fetchData();

    print(TaskController.currentTaskIndex);
    print('Задачи загружены:');
    for (Object task in TaskController.tasks) {
      print('ID: ${task.id_objects}');
      print('Name: ${task.name}');
      print('Category Name: ${task.name_categories}');
      print('URL: ${task.url}');
      print('--------------------');
    }
  }

  Future<void> fetchData() async {
    try {
      // Извлеките токен из хранилища
      final String? token = await storageService.getToken();
      try {
        final response = await http.post(
          Uri.parse(
              'https://ait2-vladislav001.amvera.io/api/v1/information/pid'),
          headers: {
            'x-access-token': '$token',
            'Content-Type': 'application/json',
            // Укажите тип контента, если это приложение/JSON
          },
        );

        if (response.statusCode == 200) {
          final Map<String, dynamic> responseData = json.decode(response.body);
          id =
          responseData['_id']; // замените 'id' на актуальное поле из ответа сервера
          print('ID: $id');
        } else {
          print('Error: ${response.statusCode}');
        }
      } catch (error) {
        print('Error: $error');
      }

      final response = await http.get(
        Uri.parse(
            'https://ait2-vladislav001.amvera.io/api/configuration_module/settings/item/66153763bca893857e412279/$id'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        setState(() {
          jsonData = json.decode(response.body);
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (error) {
      print('Error fetching data: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    print(jsonData);
    return Scaffold(
      body: jsonData == null || jsonData.isEmpty
          ? Center(
        child: CircularProgressIndicator(),
      )
          : buildChoicePage(context, jsonData['item']['settings']?['pages']),
    );
  }

  Widget buildChoicePage(BuildContext context, Map<String, dynamic>? pageData) {
    if (pageData == null || pageData.isEmpty) {
      return Center(
        child: Text('Page data is empty.'),
      );
    }
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 200),

          SizedBox(height: 40),
          // Пустое пространство для отступа
          Center(
            child: ChoiceButton(
              onPressed: () {
                // Обработчик нажатия кнопки
              },
              ChoiceData: pageData['Result page']['result_image']['params']['Image'],
            ),
          ),
          SizedBox(height: 20),
          // Пустое пространство между кнопкой и карточками
          // Здесь будет иконка завершения и текстовая надпись
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Иконка завершения
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: TextResultStatefulWidget(fontSize: 30,
                      textData: pageData['Result page']['Text_result']['params']['Is visible']),
                ),
                // Текстовая надпись с отступами по краям
              ],
            ),
          ),
          SizedBox(height: 20),
          // Добавляем кнопку закрытия страницы
          ChoiceButton(
            onPressed: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => MyApp()),
              );
            },
            ChoiceData: pageData['Result page']['close_image']['params']['Image'],
          ),
        ],
      ),
    );
  }
}

class TextResultStatefulWidget extends StatefulWidget {
  static _TextResultStatefulWidgetState? _textResultStatefulWidgetState;
  final double fontSize; // Поле для размера текста
  final Map<String, dynamic>? textData;

  TextResultStatefulWidget({required this.fontSize, required this.textData});

  @override
  _TextResultStatefulWidgetState createState() {
    _textResultStatefulWidgetState = _TextResultStatefulWidgetState();
    return _textResultStatefulWidgetState!;
  }
}

class _TextResultStatefulWidgetState extends State<TextResultStatefulWidget> {
  @override
  Widget build(BuildContext context) {
    bool isVisible = widget.textData?['value'] ?? false;

    return Visibility(
      visible: isVisible, // Используем параметр visible для управления видимостью
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Center(
          child: AnimatedContainer(
            duration: Duration(milliseconds: 500),
            curve: Curves.easeInOut,
            decoration: BoxDecoration(
              color: Colors.blueGrey.shade100, // Используем более приятный цвет
              borderRadius: BorderRadius.circular(20.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, 3), // изменение тени вниз
                ),
              ],
            ),
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Поздравляю! Ты прошёл тренажёр!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: widget.fontSize,
                color: Colors.black87,
                fontWeight: FontWeight.bold, // Добавим жирный шрифт для выделения текста
              ),
            ),
          ),
        ),
      )
    );
  }
  void updateText() {
    setState(() {});
  }
}


class ChoiceButton extends StatefulWidget {
  final VoidCallback onPressed;
  final Map<String, dynamic>? ChoiceData;

  const ChoiceButton({required this.onPressed, this.ChoiceData});

  @override
  _ChoiceButtonState createState() => _ChoiceButtonState();
}

class _ChoiceButtonState extends State<ChoiceButton> {
  double _size = 120.0;

  @override
  Widget build(BuildContext context) {
    String helpImageUrl = widget.ChoiceData?['value'];
    print('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!');
    print(helpImageUrl);
    print('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!');
    return GestureDetector(
      onTapDown: (_) {
        setState(() {
          _size = 100.0; // Уменьшаем размер при нажатии
        });
        widget.onPressed();
      },
      onTapUp: (_) {
        setState(() {
          _size = 120.0; // Возвращаем размер обратно при отпускании
        });
      },
      onTapCancel: () {
        setState(() {
          _size = 120.0; // Возвращаем размер обратно при отпускании
        });
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200), // Длительность анимации
        width: _size,
        height: _size,
        child: Material(
          child: Ink.image(
            image: NetworkImage(helpImageUrl),
            width: _size,
            height: _size,
            child: InkWell(
              onTap: () {
                widget.onPressed();
              },
            ),
          ),
        ),
      ),
    );
  }
}