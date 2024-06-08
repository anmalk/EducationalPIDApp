import 'package:flutter/material.dart';

// Кнопка помощи
class HelpIconButton extends StatefulWidget {
  final VoidCallback onPressed;
  final Map<String, dynamic>? helpImageUrlData;

  const HelpIconButton({required this.onPressed, this.helpImageUrlData});

  @override
  _HelpIconButtonState createState() => _HelpIconButtonState();
}

class _HelpIconButtonState extends State<HelpIconButton> {
  double _size = 100.0;

  @override
  Widget build(BuildContext context) {
    String helpImageUrl = widget.helpImageUrlData!['params']['Image']['value'];
    return GestureDetector(
      onTapDown: (_) {
        setState(() {
          _size = 80.0; // Уменьшаем размер при нажатии
        });
        widget.onPressed();
      },
      onTapUp: (_) {
        setState(() {
          _size = 100.0; // Возвращаем размер обратно при отпускании
        });
      },
      onTapCancel: () {
        setState(() {
          _size = 100.0; // Возвращаем размер обратно при отпускании
        });
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200), // Длительность анимации
        width: _size,
        height: _size,
        child: Material(
          child: Ink.image(
            image: NetworkImage(helpImageUrl),
            width: _size,
            height: _size,
            child: InkWell(
              onTap: () {
                widget.onPressed();
              },
            ),
          ),
        ),
      ),
    );
  }
}

