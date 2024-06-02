import 'dart:convert';
import 'package:EducationalApp/autorization/login_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:EducationalApp/services/storage_service.dart';
import 'package:EducationalApp/my_app.dart';
import 'package:EducationalApp/models/object_model.dart';

class AutorizationPage extends StatelessWidget {
  final StorageService storageService = StorageService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: User.name.isEmpty && User.sex.isEmpty && User.age.isEmpty
            ? LoginButton() // Страница с кнопкой "Войти в аккаунт"
            : UserInfoPage(), // Страница с информацией о пользователе
      ),
    );
  }
}

class LoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.app_registration,
            size: 120,
            color: Colors.blueAccent,
          ),
          SizedBox(height: 40),
          Text(
            'Добро пожаловать в приложение!',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Colors.blueAccent,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 30),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pushNamed(context, '/login');
            },
            icon: Icon(Icons.login, size: 30),
            label: Text(
              'Войти в аккаунт',
              style: TextStyle(fontSize: 24),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              textStyle: TextStyle(fontSize: 24),
            ),
          ),
        ],
      ),
    );
  }
}

class UserInfoPage extends StatelessWidget {
  final StorageService storageService = StorageService();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 60,
            backgroundColor: Colors.blueAccent,
            child: Icon(Icons.person, size: 60, color: Colors.white),
          ),
          SizedBox(height: 30),
          InfoRow(
            icon: Icons.person,
            label: 'Имя',
            value: User.name,
          ),
          SizedBox(height: 20),
          InfoRow(
            icon: Icons.accessibility,
            label: 'Пол',
            value: User.sex,
          ),
          SizedBox(height: 20),
          InfoRow(
            icon: Icons.cake,
            label: 'Возраст',
            value: User.age,
          ),
          SizedBox(height: 30),
          ElevatedButton.icon(
            onPressed: () async {
              // Очистить данные пользователя
              User.id = '';
              User.name = '';
              User.sex = '';
              User.age = '';
              // Очистить токен и перейти на страницу авторизации
              await storageService.deleteToken();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            },
            icon: Icon(Icons.logout, size: 30),
            label: Text(
              'Выйти из аккаунта',
              style: TextStyle(fontSize: 24),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              textStyle: TextStyle(fontSize: 24),
            ),
          ),
        ],
      ),
    );
  }
}

class InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 40, color: Colors.blueAccent),
        SizedBox(width: 15),
        Text(
          '$label: ',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(fontSize: 24),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: AutorizationPage(),
    routes: {
      '/login': (context) => LoginPage(),
      // Добавьте остальные маршруты
    },
  ));
}