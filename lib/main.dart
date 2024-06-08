import 'package:flutter/material.dart';
import 'my_app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:EducationalApp/services/firebase_options.dart';

void main() async {
  // Гарантия инициализации виджетов Flutter
  WidgetsFlutterBinding.ensureInitialized();
  // Инициализация Firebase приложение
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,  // Использование настройки Firebase для текущей платформы
  );
  // Запуск
  runApp(MyApp());
}
