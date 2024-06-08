import 'package:flutter/material.dart';
import '../services/storage_service.dart';
import '../services/api_service.dart';

// Основной виджет для страницы авторизации
class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Переменные для хранения данных
  late Map<String, dynamic> jsonData;
  int selectedPictogramIndex = -1;
  List<Map<String, dynamic>> selectedLoginPictograms = [];
  int selectedPasswordPictogramIndex = -1;
  List<Map<String, dynamic>> selectedPasswordPictograms = [];
  bool isLoginSelected = true;
  String selectedLoginValues = '';
  String selectedPasswordValues = '';
  String? token;

  // Инициализация сервисов хранения и API
  final StorageService storageService = StorageService();
  final ApiService apiService = ApiService();

  @override
  void initState() {
    super.initState();
    jsonData = {};
    fetchData();
  }

  // Получения данных пиктограмм с сервера
  Future<void> fetchData() async {
    try {
      jsonData = await apiService.fetchPictograms();
      setState(() {});
    } catch (error) {
      print('Error fetching data: $error');
    }
  }

  // Выполнения авторизации
  Future<void> performLogin() async {
    final String login = selectedLoginValues;
    final String password = selectedPasswordValues;

    try {
      token = await apiService.login(login, password);
      //Сохранение токена в защищенное хранилище
      await storageService.saveToken(token!);

      print('Token: $token');
      navigateToHomePage();
    } catch (error) {
      print('Error: $error');
      showLoginDialog();
    }
  }

  // Переход на домашнюю страницу после успешной авторизации
  void navigateToHomePage() {
    Navigator.pushReplacementNamed(context, '/');
  }

  // Показ диалогового окна в случае ошибки авторизации
  void showLoginDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.red,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Ошибка',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 8.0),
              Text(
                'Введённые логин и/или пароль неверен или отсутствует интернет-соединение! Пожалуйста, проверьте ваше интернет-соединение или введите верный логин и пароль!',
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 16.0),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Закрыть сообщение'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Страница авторизации'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/');
              },
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          SizedBox(height: 16.0),
          Text(
            'Выбранные пиктограммы для ${isLoginSelected ? 'логина' : 'пароля'}:',
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8.0),
          // Отображение выбранных пиктограмм
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: isLoginSelected
                  ? selectedLoginPictograms.map((pictogram) {
                return buildPictogramContainer(pictogram);
              }).toList()
                  : selectedPasswordPictograms.map((pictogram) {
                return buildPictogramContainer(pictogram);
              }).toList(),
            ),
          ),
          SizedBox(height: 16.0),
          Expanded(
            // Отображение списка пиктограмм
            child: jsonData.isEmpty
                ? Center(
              child: const Text('Это страница авторизации'),
            )
                : buildPictogramList(),
          ),
          SizedBox(height: 16.0),
          // Кнопка переключения между вводом логина и пароля
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  isLoginSelected = !isLoginSelected;
                });
              },
              child: Text(
                  isLoginSelected ? 'Введи пароль' : 'Введи логин'),
            ),
          ),
          SizedBox(height: 16.0),
          // Кнопка для авторизации
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: ElevatedButton(
              onPressed: () {
                performLogin();
              },
              child: Text('Авторизоваться'),
            ),
          ),
        ],
      ),
    );
  }

  // Метод для создания списка пиктограмм
  Widget buildPictogramList() {
    final List<dynamic> pictograms = (jsonData['pictograms'] as List<dynamic>?) ?? [];

    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 8.0,
        crossAxisSpacing: 8.0,
        childAspectRatio: 1.0,
      ),
      itemCount: pictograms.length,
      itemBuilder: (BuildContext context, int index) {
        final Map<String, dynamic> pictogram = pictograms[index];
        return InkWell(
          onTap: () {
            setState(() {
              if (isLoginSelected) {
                selectedPictogramIndex = index;
                selectedLoginPictograms.add(pictogram);
              } else {
                selectedPasswordPictogramIndex = index;
                selectedPasswordPictograms.add(pictogram);
              }
            });
            updateSelectedValues();
          },
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: isLoginSelected
                    ? (selectedPictogramIndex == index ? Colors.blue : Colors.transparent)
                    : (selectedPasswordPictogramIndex == index ? Colors.blue : Colors.transparent),
                width: 2.0,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Отображение изображения пиктограммы
                Image.network('https://${pictogram['image']?.toString() ?? ''}', height: 50, width: 50),
                SizedBox(height: 4.0),
                // Отображение значения пиктограммы
                Text(pictogram['value']?.toString() ?? ''),
              ],
            ),
          ),
        );
      },
    );
  }

  // Метод для обновления выбранных значений логина и пароля
  void updateSelectedValues() {
    setState(() {
      if (isLoginSelected) {
        selectedLoginValues =
            selectedLoginPictograms.map((pictogram) => pictogram['value']?.toString() ?? '').join('');
      } else {
        selectedPasswordValues =
            selectedPasswordPictograms.map((pictogram) => pictogram['value']?.toString() ?? '').join('');
      }
    });
    print('Selected Login Values: $selectedLoginValues');
    print('Selected Password Values: $selectedPasswordValues');
  }

  // Метод для создания контейнера пиктограммы
  Widget buildPictogramContainer(Map<String, dynamic> pictogram) {
    return InkWell(
      onTap: () {
        // Ваш код для обработки нажатия на выбранную пиктограмму
      },
      child: Container(
        margin: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.blue, width: 2.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network('https://${pictogram['image']?.toString() ?? ''}', height: 50, width: 50),
            SizedBox(height: 4.0),
          ],
        ),
      ),
    );
  }
}
