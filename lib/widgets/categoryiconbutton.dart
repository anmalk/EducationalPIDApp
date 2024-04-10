import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:untitled3/models/task_controller.dart';

class CategoryOneIconButton extends StatefulWidget {
  final Map<String, dynamic>? categoryOneImageUrlData;
  final bool isCategoryEqual;

  const CategoryOneIconButton({
    required this.isCategoryEqual,
    this.categoryOneImageUrlData,
  });

  @override
  _CategoryOneIconButtonState createState() => _CategoryOneIconButtonState();
}

class _CategoryOneIconButtonState extends State<CategoryOneIconButton> {
  double _size = 110.0;
  late bool _isCategoryEqual;
  late Color _borderColor; // Цвет обводки кнопки

  @override
  void initState() {
    super.initState();
    _isCategoryEqual = widget.isCategoryEqual;
  }

  @override
  Widget build(BuildContext context) {
    String categoryOneImageUrl = widget.categoryOneImageUrlData!['params']['Image']['value'];

    return GestureDetector(
      onTapDown: (_) {
        setState(() {
          _size = 80.0; // Уменьшаем размер при нажатии
        });
        Future.delayed(Duration(milliseconds: 200), () {
          compareCategories(context); // Вызываем функцию сравнения категорий после небольшой задержки
        }); // Вызываем функцию сравнения категорий
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
            categoryOneImageUrl,
            width: 110,
            height: 110,
          ),
        ),
      ),
    );
  }



}
void compareCategories(BuildContext context) async {
  String? categoryFromFirestore = await TaskController.tasks[TaskController.currentTaskIndex].name_categories;
  bool areEqual = areCategoriesEqual(categoryFromFirestore);

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('Результат'),
      content: Text(
        areEqual ? 'Ты выбрал правильный ответ!' : 'Ты выбрал неправильный ответ!',
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
      backgroundColor: areEqual ? Colors.green[100] : Colors.red[100], // Цвет фона AlertDialog
    ),
  );
}

void compareCategories2(BuildContext context) async {
  String? categoryFromFirestore = await TaskController.tasks[TaskController.currentTaskIndex].name_categories;
  bool areEqual = areCategoriesEqual2(categoryFromFirestore);

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('Результат'),
      content: Text(
        areEqual ? 'Ты выбрал правильный ответ!' : 'Ты выбрал неправильный ответ!',
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
      backgroundColor: areEqual ? Colors.green[100] : Colors.red[100], // Цвет фона AlertDialog

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

bool areCategoriesEqual2(String? categoryFromFirestore) {
  String? categoryFromImageData = TaskController.category?.name;

  if (categoryFromFirestore != null && categoryFromImageData != null) {
    return categoryFromFirestore != categoryFromImageData;
  } else {
    return false;
  }
}

class CategoryTwoIconButton extends StatefulWidget {
  final bool isCategoryEqual;
  final Map<String, dynamic>? categoryTwoImageUrlData;

  const CategoryTwoIconButton({required this.isCategoryEqual, this.categoryTwoImageUrlData});

  @override
  _CategoryTwoIconButtonState createState() => _CategoryTwoIconButtonState();
}

class _CategoryTwoIconButtonState extends State<CategoryTwoIconButton> {
  double _size = 110.0;

  @override
  Widget build(BuildContext context) {
    String categoryTwoImageUrl = widget.categoryTwoImageUrlData!['params']['Image']['value'];
    return GestureDetector(
      onTapDown: (_) {
        setState(() {
          _size = 80.0; // Уменьшаем размер при нажатии
        });
        Future.delayed(Duration(milliseconds: 200), () {
          compareCategories2(context); // Вызываем функцию сравнения категорий после небольшой задержки
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
            categoryTwoImageUrl,
            width: 110,
            height: 110,
          ),
        ),
      ),
    );
  }
}
