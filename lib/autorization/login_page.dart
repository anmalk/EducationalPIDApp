import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../services/storage_service.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late Map<String, dynamic> jsonData;
  int selectedPictogramIndex = -1;
  List<Map<String, dynamic>> selectedLoginPictograms = [];
  int selectedPasswordPictogramIndex = -1;
  List<Map<String, dynamic>> selectedPasswordPictograms = [];
  bool isLoginSelected = true;
  String selectedLoginValues = '';
  String selectedPasswordValues = '';
  String? token;

  // Инициализируйте сервис хранения
  final StorageService storageService = StorageService();

  @override
  void initState() {
    super.initState();
    jsonData = {};
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      // Извлеките токен из хранилища
      token = await storageService.getToken();

      final response = await http.get(
        Uri.parse('https://ait2-vladislav001.amvera.io/api/v1/login/get-pictograms'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        setState(() {
          jsonData = json.decode(response.body);
        });
      } else {
        print('Error fetching data: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching data: $error');
    }
  }

  Future<void> performLogin() async {
    final String login = selectedLoginValues;
    final String password = selectedPasswordValues;

    final Map<String, dynamic> data = {
      'login': login,
      'password': password,
    };

    try {
      final response = await http.post(
        Uri.parse('https://ait2-vladislav001.amvera.io/api/v1/login/pid'),
        body: json.encode(data),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        token = responseData['token'];

        // Сохраните токен в хранилище
        await storageService.saveToken(token!);

        print('Token: $token');
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  void navigateToHomePage() {
    // Ваш код для перехода на домашнюю страницу
    Navigator.pushReplacementNamed(context, '/');
  }

  void showLoginDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Login Details'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Selected Login Pictograms: $selectedLoginValues'),
              Text('Selected Password Pictograms: $selectedPasswordValues'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                navigateToHomePage();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login Page'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: 16.0),
          Text(
            'Selected Pictograms for ${isLoginSelected ? 'Login' : 'Password'}:',
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8.0),
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
            child: jsonData.isEmpty
                ? Center(
              child: const Text('This is the Login Page'),
            )
                : buildPictogramList(), // вызываем метод внутри класса
          ),
          SizedBox(height: 16.0),
          // Добавлен отступ от нижней грани кнопки
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  isLoginSelected = !isLoginSelected;
                });
              },
              child: Text(
                  isLoginSelected ? 'Select Password Pictograms' : 'Select Login Pictograms'),
            ),
          ),
          SizedBox(height: 16.0),
          // Добавлен отступ от нижней грани кнопки
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: ElevatedButton(
              onPressed: () {
                showLoginDialog();
                performLogin();
              },
              style: ElevatedButton.styleFrom(
                // Remove 'primary' as it is not a valid parameter
              ),
              child: Text('Login'),
            ),
          ),
        ],
      ),
    );
  }

  // Ваш метод buildPictogramList
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
                Image.network('https://${pictogram['image']?.toString() ?? ''}', height: 50, width: 50),
                SizedBox(height: 4.0),
                Text(pictogram['value']?.toString() ?? ''),
              ],
            ),
          ),
        );
      },
    );
  }

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

  Widget buildPictogramContainer(Map<String, dynamic> pictogram) {
    return InkWell(
      onTap: () {
        // Your code for handling the tap on a selected pictogram
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
            Text(pictogram['value']?.toString() ?? ''),
          ],
        ),
      ),
    );
  }
}
