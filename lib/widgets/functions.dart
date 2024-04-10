import 'package:flutter/material.dart';

double getSizeProgressBarData(String sizeValue) {
  switch (sizeValue) {
    case 'tiny':
      return 10;
    case 'small':
      return 25;
    case 'medium':
      return 40;
    case 'large':
      return 55;
    case 'big':
      return 70;
    default:
      return 40;
  }
}

IconData getPrevIconData(String iconValue) {
  switch (iconValue) {
    case 'arrow':
      return Icons.arrow_back;
    case 'arrow circle':
      return Icons.arrow_circle_left_outlined;
    case 'angle':
      return Icons.arrow_back_ios_new;
    default:
      return Icons.arrow_back;
  }
}

IconData getNextIconData(String iconValue) {
  switch (iconValue) {
    case 'arrow':
      return Icons.arrow_forward;
    case 'arrow circle':
      return Icons.arrow_circle_right_outlined;
    case 'angle':
      return Icons.arrow_forward_ios;
    default:
      return Icons.arrow_forward;
  }
}

String getOptionText(List<dynamic> options, String value) {
  for (var option in options) {
    if (option['value'] == value) {
      return option['text'];
    }
  }
  return '';
}

IconData getIconData(String iconValue) {
  switch (iconValue.toLowerCase()) {
    case 'arrow_forward':
      return Icons.arrow_forward;
    case 'arrow_back':
      return Icons.arrow_back;
  // Добавьте другие иконки по необходимости
    default:
      return Icons.error; // Иконка по умолчанию, если ни одна из иконок не совпадает
  }
}

Color getColorFromString(String colorName) {
  switch (colorName.toLowerCase()) {
    case 'green':
      return Colors.green;
    case 'orange':
      return Colors.orange;
    case 'red':
      return Colors.red;
    case 'yellow':
      return Colors.yellow;
    case 'olive':
      return Colors.yellow.shade400;
    case 'teal':
      return Colors.teal;
    case 'blue':
      return Colors.blue;
    case 'violet':
      return Colors.purple.shade600;
    case 'purple':
      return Colors.purple;
    case 'pink':
      return Colors.pink;
    case 'brown':
      return Colors.brown;
    case 'grey':
      return Colors.grey;
    case 'black':
      return Colors.black;
  // Добавьте другие цвета по необходимости
    default:
      return Colors.black; // Цвет по умолчанию, если ни один из цветов не совпадает
  }
}


