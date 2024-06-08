import 'package:flutter/material.dart';
import 'autorization/profil_page.dart';
import 'autorization/login_page.dart';
import 'choice_category_page.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/', // Установка начального маршрута
      routes: {
        '/': (context) => const NavigationWidget(), // Маршрут для навигации
        '/login': (context) => LoginPage(), // Маршрут для страницы входа
        '/choice': (context) => ChoiceCategoryPage(), // Маршрут для страницы выбора категории
      },
    );
  }
}

class NavigationWidget extends StatefulWidget {
  const NavigationWidget({Key? key}) : super(key: key);

  @override
  State<NavigationWidget> createState() => _NavigationWidgetState();
}

class _NavigationWidgetState extends State<NavigationWidget> {
  int currentPageIndex = 0; // Индекс текущей страницы

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        height: 56, // Высота нижней навигационной панели
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index; // Обновление индекса текущей страницы
          });
        },
        indicatorColor: Colors.amber, // Цвет индикатора выбранной страницы
        selectedIndex: currentPageIndex, // Установка выбранного индекса
        destinations: <Widget>[
          NavigationDestination(
            icon: Padding(
              padding: const EdgeInsets.only(top: 4.0), // Отступ сверху
              child: Badge(child: Icon(Icons.category, size: 40)), // Иконка категорий
            ),
            label: '', // Убираем текстовую метку
          ),
          NavigationDestination(
            icon: Padding(
              padding: const EdgeInsets.only(top: 4.0), // Отступ сверху
              child: Badge(child: Icon(Icons.account_circle, size: 40)), // Иконка профиля
            ),
            label: '', // Убираем текстовую метку
          ),
        ],
      ),
      body: <Widget>[
        ChoiceCategoryPage(), // Виджет для выбора категории
        ProfilPage(), // Виджет для профиля
      ][currentPageIndex], // Отображение виджета в соответствии с текущим индексом страницы
    );
  }
}
