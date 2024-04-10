import'package:flutter/material.dart';
import 'my_home_page.dart';
import 'autorization/autorization_page.dart';
import 'autorization/login_page.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

      return MaterialApp(
      initialRoute: '/', // Устанавливаем начальный маршрут
      routes: {
        '/': (context) => const NavigationExample(),
        '/login': (context) => LoginPage(), // Назначаем маршрут для страницы логина
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
    final ThemeData theme = Theme.of(context);
    return Scaffold(

      bottomNavigationBar: NavigationBar(
        height: 50, // Установите желаемую высоту здесь
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        indicatorColor: Colors.amber,
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.home),
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Badge(child: Icon(Icons.account_circle)),
            label: 'Authorization',
          ),
        ],
      ),
      body: <Widget>[
        MyHomePage(), // Ваш виджет для домашней страницы
        AutorizationPage(), // Ваш виджет для страницы авторизации
      ][currentPageIndex],
    );
  }
}

