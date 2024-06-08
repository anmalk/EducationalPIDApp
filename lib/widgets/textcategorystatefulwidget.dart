import 'package:flutter/material.dart';

// Кнопка текста категории задания
class TextCategoryStatefulWidget extends StatefulWidget {
  static _TextCategoryStatefulWidgetState? _textCategoryStatefulWidgetState;
  final String value;
  final double fontSize; // Поле для размера текста
  final Map<String, dynamic>? textData;
  int currentTaskIndex;

  TextCategoryStatefulWidget({required this.value, required this.fontSize, required this.textData, required this.currentTaskIndex});

  @override
  _TextCategoryStatefulWidgetState createState() {
    _textCategoryStatefulWidgetState = _TextCategoryStatefulWidgetState();
    return _textCategoryStatefulWidgetState!;
  }
}

class _TextCategoryStatefulWidgetState extends State<TextCategoryStatefulWidget> {
  @override
  Widget build(BuildContext context) {
    bool isVisible = widget.textData?['params']?['Is visible']?['value'] ?? false;

    return Visibility(
      visible: isVisible, // Используем параметр visible для управления видимостью
      child: Text(
        widget.value,
        style: TextStyle(
          fontSize: widget.fontSize,
        ),
      ),
    );
  }
  void updateText() {
    setState(() {});
  }
}
