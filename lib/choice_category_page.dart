import 'dart:convert';
import 'package:EducationalApp/tasks_page.dart';
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

class ChoiceCategoryPage extends StatefulWidget {
  @override
  _ChoiceCategoryPageState createState() => _ChoiceCategoryPageState();
}

class _ChoiceCategoryPageState extends State<ChoiceCategoryPage> {
  late Map<String, dynamic> jsonData;
  final StorageService storageService = StorageService();  // Создайте экземпляр StorageService
  late String id = ''; // замените 'id' на актуальное поле из ответа сервера


  @override
  void initState() {
    super.initState();
    DatabaseService.initFirebase();
    jsonData = {};
    fetchData();

    // print(TaskController.currentTaskIndex);
    // print('Задачи загружены:');
    // for (Object task in TaskController.tasks) {
    //   print('ID: ${task.id_objects}');
    //   print('Name: ${task.name}');
    //   print('Category Name: ${task.name_categories}');
    //   print('URL: ${task.url}');
    //   print('--------------------');
    // }
  }

  Future<void> fetchData() async {
    try {
      // Извлеките токен из хранилища
      final String? token = await storageService.getToken();
      try {
        final response = await http.post(
          Uri.parse('https://ait2-vladislav001.amvera.io/api/v1/information/pid'),
          headers: {
            'x-access-token': '$token',
            'Content-Type': 'application/json',  // Укажите тип контента, если это приложение/JSON
          },
        );

        if (response.statusCode == 200) {
          final Map<String, dynamic> responseData = json.decode(response.body);
          id = responseData['_id']; // замените 'id' на актуальное поле из ответа сервера
          User.id = responseData['_id'];
          User.name = responseData['name'];
          User.age = responseData['age'];
          User.sex = responseData['gender'];
          print('ID: $id');

        } else {
          print('Error: ${response.statusCode}');
        }
      } catch (error) {
        print('Error: $error');
      }

      final response = await http.get(
        Uri.parse('https://ait2-vladislav001.amvera.io/api/configuration_module/settings/item/66153763bca893857e412279/$id'),
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
    //print(jsonData);
    return Scaffold(
      body: jsonData == null || jsonData.isEmpty
          ? Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(10.0),
              border: Border.all(
                color: Colors.grey.shade400,
                width: 1.0,
              ),
            ),
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 64.0,
                  color: Colors.red,
                ),
                SizedBox(height: 16.0),
                Text(
                  'Пожалуйста, помогите пользователю авторизоваться под его аккаунтом для загрузки интерфейса, настроенного под него, или проверьте интернет-соединение!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18.0,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ),
      )
          : buildChoicePage(context, jsonData['item']['settings']?['pages']),
    );
  }
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
        SizedBox(height: 100),
        TextChoiceStatefulWidget(textValue: 'Выбери категорию', fontSize: 30,
            textData: pageData['Select category']['Text_category']['params']['Is visible']),
        SizedBox(height: 40),
        Center(
          child: ChoiceButton(
            onPressed: () {
              // Обработчик нажатия кнопки
            },
            ChoiceData: pageData['Select category']['choise_image']['params']['Image'],
          ),
        ),
        SizedBox(height: 20),
        FutureBuilder<QuerySnapshot>(
          future: FirebaseFirestore.instance.collection('categories').get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            }
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }
            final List<DocumentSnapshot> documents = snapshot.data!.docs;
            return ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: documents.length,
              itemBuilder: (context, index) {
                final Map<String, dynamic> data = documents[index]
                    .data() as Map<String, dynamic>;
                return Card(
                  child: ListTile(
                    title: TextChoiceStatefulWidget(textValue: data['name'], fontSize: 28,
                      textData: pageData['Select category']['Text_card']['params']['Is visible'],),
                    subtitle: Image.network(data['url']),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MyHomePage(name: data['name']),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          },
        ),
        SizedBox(height: 20), // Пустое пространство после ListView.builder
        // Ваш новый виджет здесь
        TextChoiceStatefulWidget(textValue: 'Попробуй новый тренажёр!', fontSize: 30,
            textData: pageData['Select category']['Text_tasks']['params']['Is visible']),
        SizedBox(height: 40),
        Center(
          child: ChoiceButton(
            onPressed: () {
              // Обработчик нажатия кнопки
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TasksPage(name: 'Задача'),
                ),
              );
            },
            ChoiceData: pageData['Select category']['task_image']['params']['Image'],
          ),
        ),
        SizedBox(height: 20),
      ],
    ),
  );
}


class TextChoiceStatefulWidget extends StatefulWidget {
  static _TextChoiceStatefulWidgetState? _textChoiceStatefulWidgetState;
  final double fontSize; // Поле для размера текста
  final Map<String, dynamic>? textData;
  final String textValue;

  TextChoiceStatefulWidget({required this.fontSize, required this.textData, required this.textValue});

  @override
  _TextChoiceStatefulWidgetState createState() {
    _textChoiceStatefulWidgetState = _TextChoiceStatefulWidgetState();
    return _textChoiceStatefulWidgetState!;
  }
}

class _TextChoiceStatefulWidgetState extends State<TextChoiceStatefulWidget> {
  @override
  Widget build(BuildContext context) {
    bool isVisible = widget.textData?['value'] ?? false;
    String textValue = widget.textValue;
    return Visibility(
      visible: isVisible, // Используем параметр visible для управления видимостью
      child: Text(
        textValue,
        style: TextStyle(
          fontSize: widget.fontSize,
        ),
      ),
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