import 'dart:convert';
import 'package:EducationalApp/autorization/login_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:EducationalApp/services/storage_service.dart';
import 'package:EducationalApp/my_app.dart';

class AutorizationPage extends StatelessWidget {
  final StorageService storageService = StorageService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Добро пожаловать в приложение!',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Навигация к странице авторизации
                Navigator.pushNamed(context, '/login'); // Укажите нужный маршрут
              },
              child: Text('Войти в аккаунт'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                // Очистить токен и перейти на страницу авторизации
                await storageService.deleteToken();
                // После удаления токена переходим на страницу авторизации
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );              },
              child: Text('Выйти из аккаунта'),
            ),
          ],
        ),
      ),
    );
  }
}