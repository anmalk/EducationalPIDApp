import 'package:flutter/material.dart';
import 'services/storage_service.dart';  // Импортируйте ваш StorageService
import 'package:EducationalApp/services/db.dart';
import 'my_app.dart';
import 'services/api_service.dart';

// Страница результатов
class ResultPage extends StatefulWidget {
  @override
  _ResultPageState createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  late Map<String, dynamic> jsonData;
  final StorageService storageService = StorageService(); // Создайте экземпляр StorageService
  late String id = ''; // замените 'id' на актуальное поле из ответа сервера
  final ApiService apiService = ApiService(); // Экземпляр ApiService

  @override
  void initState() {
    super.initState();
    DatabaseService.initFirebase();
    jsonData = {};
    fetchData();
  }

  // Функция для получения данных с сервера
  Future<void> fetchData() async {
    try {
      final Map<String, dynamic> data = await apiService.fetchData(); // Получение данных с помощью ApiService
      setState(() {
        jsonData = data; // Обновление данных при получении
      });
    } catch (error) {
      print('Error fetching data: $error'); // Вывод ошибки, если произошла ошибка получения данных
    }
  }

  @override
  Widget build(BuildContext context) {
    // Вывод индикатор загрузки, если данных нет или они еще не загрузились
    return Scaffold(
      body: jsonData == null || jsonData.isEmpty
          ? Center(
        child: CircularProgressIndicator(),
      )
          : buildResultPage(context, jsonData['item']['settings']?['pages']),
    );
  }

  // Функция для построения страницы результатов
  Widget buildResultPage(BuildContext context, Map<String, dynamic>? pageData) {
    if (pageData == null || pageData.isEmpty) {
      return Center(
        child: Text('Page data is empty.'),
      );
    }
    // Построение страницы с кнопками и результатом
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 240),
          // Кнопка с изображением
          Center(
            child: ResultButton(
              onPressed: () {
              },
              ChoiceData: pageData['Result page']['result_image']['params']['Image'],
            ),
          ),
          SizedBox(height: 20),
          // Пустое пространство между кнопкой и карточками
          // Здесь иконки завершения и текстовая надпись
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
          // Кнопка перехода на выбор заданий
          ResultButton(
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

// Виджет для отображения текстового результата
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

// Кнопка выбора
class ResultButton extends StatefulWidget {
  final VoidCallback onPressed;
  final Map<String, dynamic>? ChoiceData;

  const ResultButton({required this.onPressed, this.ChoiceData});

  @override
  _ResultButtonState createState() => _ResultButtonState();
}

class _ResultButtonState extends State<ResultButton> {
  double _size = 120.0;

  @override
  Widget build(BuildContext context) {
    String helpImageUrl = widget.ChoiceData?['value'];
    return GestureDetector(
      onTapDown: (_) {
        setState(() {
          _size = 100.0; // Уменьшение размера при нажатии
        });
        widget.onPressed();
      },
      onTapUp: (_) {
        setState(() {
          _size = 120.0; // Возвращение размера обратно при отпускании
        });
      },
      onTapCancel: () {
        setState(() {
          _size = 120.0; // Возвращение размер обратно при отпускании
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