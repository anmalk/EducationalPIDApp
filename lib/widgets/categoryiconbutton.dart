import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:EducationalApp/models/task_controller.dart';
import 'package:audioplayers/audioplayers.dart';
import 'helpiconbutton.dart';
import 'package:EducationalApp/page_widgets.dart';

class CategoryIconButton extends StatefulWidget {
  final bool isCategoryEqual;
  final Map<String, dynamic>? categoryImageUrlData;
  final Map<String, dynamic>? trueImageUrlData;
  final Map<String, dynamic>? falseImageUrlData;
  final Map<String, dynamic>? returnImageUrlData;
  final bool Function(String?) areCategoriesEqual;

  const CategoryIconButton({
    required this.isCategoryEqual,
    this.categoryImageUrlData,
    this.trueImageUrlData,
    this.falseImageUrlData,
    this.returnImageUrlData,
    required this.areCategoriesEqual,
  });

  @override
  _CategoryIconButtonState createState() => _CategoryIconButtonState();
}

class _CategoryIconButtonState extends State<CategoryIconButton> {
  double _size = 110.0;

  @override
  Widget build(BuildContext context) {
    String categoryImageUrl = widget.categoryImageUrlData!['params']['Image']['value'];
    String trueImageUrl = widget.trueImageUrlData!['params']['Image']['value'];
    String falseImageUrl = widget.falseImageUrlData!['params']['Image']['value'];
    String returnImageUrl = widget.returnImageUrlData!['params']['Image']['value'];

    return GestureDetector(
      onTapDown: (_) {
        setState(() {
          _size = 80.0;
        });
        Future.delayed(Duration(milliseconds: 200), () {
          compareCategories(context, widget.areCategoriesEqual, trueImageUrl, falseImageUrl, returnImageUrl);
        });
      },
      onTapUp: (_) {
        setState(() {
          _size = 110.0;
        });
      },
      onTapCancel: () {
        setState(() {
          _size = 110.0;
        });
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        width: _size,
        height: _size,
        child: MaterialButton(
          minWidth: 110,
          height: 110,
          splashColor: Colors.transparent,
          onPressed: () {},
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

void compareCategories(BuildContext context, bool Function(String?) areCategoriesEqual, String imageTrue, String imageFalse, String imageReturn) async {
  String? categoryFromFirestore = TaskController.tasks[TaskController.currentTaskIndex].name_categories;
  bool result = areCategoriesEqual(categoryFromFirestore);

  TaskController.tasks[TaskController.currentTaskIndex].isAnswered = true;

  if (result) {
    TaskController.tasks[TaskController.currentTaskIndex].isTrueAnswer = true;
    TaskController.score++;
    print("Correct Answer. Score: ${TaskController.score}");
  } else {
    TaskController.tasks[TaskController.currentTaskIndex].isTrueAnswer = false;
    print("Incorrect Answer. Score: ${TaskController.score}");
  }

  final player = AudioPlayer();

  if (result) {
    await player.play(AssetSource('sounds/true.mp3'));
  } else {
    await player.play(AssetSource('sounds/false.mp3'));
  }

  showResultDialog(context, result, imageTrue, imageFalse, imageReturn);
}

void showResultDialog(BuildContext context, bool result, String imageTrue, String imageFalse, String imageReturn) {
  showDialog(
    context: context,
    builder: (context) {
      bool visible = false;

      return AlertDialog(
        title: Text(''),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.network(
              result ? imageTrue : imageFalse,
              height: 100,
            ),
            SizedBox(height: 16),
            Visibility(
              visible: visible,
              child: Text(
                result ? 'Ты выбрал правильный ответ!' : 'Ты выбрал неправильный ответ!',
                style: TextStyle(fontSize: 20),
              ),
            ),
          ],
        ),
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Image.network(
              imageReturn,
              height: 50,
            ),
          ),
        ],
        backgroundColor: result ? Colors.green[100] : Colors.red[100],
      );
    },
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
