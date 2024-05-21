import'package:flutter/material.dart';
import 'my_home_page.dart';
import 'autorization/autorization_page.dart';
import 'autorization/login_page.dart';
import 'choice_category_page.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

      return MaterialApp(
      initialRoute: '/', // Устанавливаем начальный маршрут
      routes: {
        '/': (context) => const NavigationExample(),
        '/login': (context) => LoginPage(), // Назначаем маршрут для страницы логина
        '/choice': (context) => ChoiceCategoryPage(), // Назначаем маршрут для страницы логина
      },
    );
  }
}

class NavigationExample extends StatefulWidget {
  const NavigationExample({super.key});

  @override
  State<NavigationExample> createState() => _NavigationExampleState();
}

class _NavigationExampleState extends State<NavigationExample> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        height: 56, // Устанавливаем желаемую высоту
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        indicatorColor: Colors.amber,
        selectedIndex: currentPageIndex,
        destinations: <Widget>[
          NavigationDestination(
            icon: Padding(
              padding: const EdgeInsets.only(top: 4.0), // Добавляем отступ сверху
              child: Badge(child: Icon(Icons.category, size: 40)), // Увеличиваем размер иконки
            ),
            label: '', // Убираем текстовую метку
          ),
          NavigationDestination(
            icon: Padding(
              padding: const EdgeInsets.only(top: 4.0), // Добавляем отступ сверху
              child: Badge(child: Icon(Icons.account_circle, size: 40)), // Увеличиваем размер иконки
            ),
            label: '', // Убираем текстовую метку
          ),
        ],
      ),
      body: <Widget>[
        ChoiceCategoryPage(), // Ваш виджет для домашней страницы
        AutorizationPage(), // Ваш виджет для страницы авторизации
      ][currentPageIndex],
    );
  }
}
