import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:EducationalApp/models/task_controller.dart';
import 'package:audioplayers/audioplayers.dart';

class CategoryIconButton extends StatefulWidget {
  final bool isCategoryEqual;
  final Map<String, dynamic>? categoryImageUrlData;
  final bool Function(String?) areCategoriesEqual; // Функция для сравнения категорий

  const CategoryIconButton({
    required this.isCategoryEqual,
    this.categoryImageUrlData,
    required this.areCategoriesEqual, // Обязательный параметр
  });

  @override
  _CategoryIconButtonState createState() => _CategoryIconButtonState();
}

class _CategoryIconButtonState extends State<CategoryIconButton> {
  double _size = 110.0;

  @override
  Widget build(BuildContext context) {
    String categoryImageUrl = widget.categoryImageUrlData!['params']['Image']['value'];
    return GestureDetector(
      onTapDown: (_) {
        setState(() {
          _size = 80.0; // Уменьшаем размер при нажатии
        });
        Future.delayed(Duration(milliseconds: 200), () {
          compareCategories(context, widget.areCategoriesEqual); // Вызываем переданную функцию сравнения категорий после небольшой задержки
        });

      },
      onTapUp: (_) {
        setState(() {
          _size = 110.0; // Возвращаем размер обратно при отпускании
        });
      },
      onTapCancel: () {
        setState(() {
          _size = 110.0; // Возвращаем размер обратно при отпускании
        });
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200), // Длительность анимации
        width: _size,
        height: _size,
        child: MaterialButton(
          minWidth: 110,
          height: 110,
          splashColor: Colors.transparent, // Установка цвета эффекта подъема
          onPressed: () {}, // Пустая функция onPressed, так как обработка нажатия происходит в onTapDown
          child: Image.network(
            categoryImageUrl,
            width: 110,
            height: 110,
          ),
        ),
      ),
    );
  }
}

void compareCategories(BuildContext context, bool Function(String?) areCategoriesEqual) async {
  String? categoryFromFirestore = await TaskController.tasks[TaskController.currentTaskIndex].name_categories;
  bool result = areCategoriesEqual(categoryFromFirestore);
  TaskController.tasks[TaskController.currentTaskIndex].isAnswered = true;
  if(result) {
    TaskController.tasks[TaskController.currentTaskIndex].isTrueAnswer = true;
    TaskController.score++;
    print(TaskController.score);
  }

  final player = AudioPlayer();


  if (result) {
    await player.play(AssetSource('sounds/true.mp3'));
  } else {
    await player.play(AssetSource('sounds/false.mp3'));
  }


  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('Результат'),
      content: Text(
        result ? 'Ты выбрал правильный ответ!' : 'Ты выбрал неправильный ответ!',
        style: TextStyle(fontSize: 20), // Установите желаемый размер шрифта здесь
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('OK'),
        ),
      ],
      backgroundColor: result ? Colors.green[100] : Colors.red[100], // Цвет фона AlertDialog
    ),
  );
}

bool areCategoriesEqual(String? categoryFromFirestore) {
  String? categoryFromImageData = TaskController.category?.name;

  if (categoryFromFirestore != null && categoryFromImageData != null) {
    return categoryFromFirestore == categoryFromImageData;
  } else {
    return false;
  }
}

bool areCategoriesNotEqual(String? categoryFromFirestore) {
  String? categoryFromImageData = TaskController.category?.name;

  if (categoryFromFirestore != null && categoryFromImageData != null) {
    return categoryFromFirestore != categoryFromImageData;
  } else {
    return false;
  }
}
