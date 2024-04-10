import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class AutorizationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome to Your App!',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Навигация к странице авторизации
                Navigator.pushNamed(context, '/login'); // Укажите нужный маршрут
              },
              child: Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}