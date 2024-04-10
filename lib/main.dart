import 'package:flutter/material.dart';
import 'my_app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:EducationalApp/services/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,  );
  runApp(MyApp());
}