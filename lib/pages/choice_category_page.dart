import 'package:EducationalApp/pages/tasks_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../services/storage_service.dart';
import 'package:EducationalApp/services/db.dart';
import './my_home_page.dart';
import '../../services/api_service.dart';


class ChoiceCategoryPage extends StatefulWidget {
  @override
  _ChoiceCategoryPageState createState() => _ChoiceCategoryPageState();
}

class _ChoiceCategoryPageState extends State<ChoiceCategoryPage> {
  late Map<String, dynamic> jsonData; // Переменная для хранения данных
  final StorageService storageService = StorageService();  // Экземпляр StorageService
  late String id = ''; // Переменная для хранения ID
  final ApiService apiService = ApiService(); // Экземпляр ApiService


  @override
  void initState() {
    super.initState();
    DatabaseService.initFirebase(); // Инициализация Firebase
    jsonData = {}; // Инициализация переменной данных
    fetchData(); // Вызов метода для получения данных
  }

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
    // Проверка наличия данных, отображение заглушки, если данные отсутствуют
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
          : buildChoicePage(context, jsonData['item']['settings']?['pages']), // Построение страницы выбора категории
    );
  }
}

// Виджет для построения страницы выбора категории
Widget buildChoicePage(BuildContext context, Map<String, dynamic>? pageData) {
  // Проверка наличия данных
  if (pageData == null || pageData.isEmpty) {
    return Center(
      child: Text('Page data is empty.'), // Отображение сообщения об отсутствии данных
    );
  }

  // Построение интерфейса выбора категории
  return SingleChildScrollView(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: 100),
        // Виджет для отображения текста "Выбери категорию"
        TextChoiceStatefulWidget(
            textValue: 'Выбери категорию',
            fontSize: 30,
            textData: pageData['Select category']['Text_category']['params']['Is visible']
        ),
        SizedBox(height: 40),
        Center(
          // Виджет для отображения кнопки выбора категории
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
                final Map<String, dynamic> data = documents[index].data() as Map<String, dynamic>;
                return Card(
                  child: ListTile(
                    title: TextChoiceStatefulWidget(
                      textValue: data['name'],
                      fontSize: 28,
                      textData: pageData['Select category']['Text_card']['params']['Is visible'],
                    ),
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
        // Виджет для отображения текста "Попробуй новый тренажёр!"
        TextChoiceStatefulWidget(
            textValue: 'Попробуй новый тренажёр!',
            fontSize: 30,
            textData: pageData['Select category']['Text_tasks']['params']['Is visible']
        ),
        SizedBox(height: 40),
        Center(
          // Виджет для отображения кнопки перехода к тренажёрам
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

// Виджет для отображения текста с возможностью управления видимостью
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

// Виджет для кнопки выбора
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