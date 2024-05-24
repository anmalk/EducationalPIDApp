import 'package:flutter/material.dart';
import 'package:EducationalApp/services/db.dart';
import 'models/task_more_controller.dart';
import 'widgets/helpiconbutton.dart';
import 'widgets/functions.dart';
import 'models/object_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'result_page.dart';
import 'dart:async';
import 'tasks_page.dart';
import 'page_widgets.dart';

class GamePage extends StatefulWidget {
  final Map<String, dynamic>? pageData;

  GamePage({Key? key, this.pageData}) : super(key: key);

  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  bool _isPulsating = true;

  @override
  Widget build(BuildContext context) {
    if (widget.pageData == null || widget.pageData!.isEmpty) {
      return Center(
        child: Text('Page data is empty.'),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Game'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 20),
              Text(
                'Find the matching image',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Wrap(
                alignment: WrapAlignment.spaceEvenly,
                spacing: 10,
                runSpacing: 20,
                children: [
                  for (int i = 0; i < 3; i++)
                    GestureDetector(
                      onTap: () {
                        // Обработка нажатия
                      },
                      child: ImageWidget(
                        url: TaskController_more.tasks[TaskController_more.currentTaskIndex].images[i].url,
                      ),
                    ),
                  SizedBox(width: 20),
                  GestureDetector(
                    onTap: () {
                      // Обработка нажатия
                    },
                    child: PulsatingImage(),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Text(
                'Select one of these:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Wrap(
                alignment: WrapAlignment.spaceEvenly,
                spacing: 100,
                runSpacing: 20,
                children: [
                  for (int i = 3; i < 6; i++)
                    AnimatedImageWidget(
                      url: TaskController_more.tasks[TaskController_more.currentTaskIndex].images[i].url,
                      onTap: () {
                        if (TaskController_more.tasks[TaskController_more.currentTaskIndex].category ==
                            TaskController_more.tasks[TaskController_more.currentTaskIndex].images[i].category) {
                          _showCorrectAnimation(context);
                        } else {
                          _showIncorrectAnimation(context);
                        }
                      },
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showCorrectAnimation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Correct!'),
          content: Text('You found the matching image.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                TaskController_more.showNextTask();
                print(TaskController_more.currentTaskIndex);
                print(TaskController_more.length);
                if (TaskController_more.currentTaskIndex == TaskController_more.tasks.length) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ResultPage()),
                  );
                }
                if (TaskController_more.currentTaskIndex <= TaskController_more.tasks.length - 1) {
                  TaskController_more.countValue();
                  setState(() {}); // Обновляем состояние страницы
                }
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showIncorrectAnimation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Incorrect!'),
          content: Text('Sorry, try again.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}

class PulsatingImage extends StatefulWidget {
  @override
  _PulsatingImageState createState() => _PulsatingImageState();
}

class _PulsatingImageState extends State<PulsatingImage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 150, end: 120).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return SizedBox(
          width: 160,
          height: 160,
          child: Stack(
            children: [
              Positioned.fill(
                child: Center(
                  child: Container(
                    width: _animation.value,
                    height: _animation.value,
                    child: Image.network(
                      'https://w7.pngwing.com/pngs/389/472/png-transparent-mark-question-information-sign-new-year-s-hand-drawn-basic-icon.png',
                      width: 150,
                      height: 150,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class ImageWidget extends StatefulWidget {
  final String url;
  ImageWidget({required this.url});

  @override
  _ImageWidgetState createState() => _ImageWidgetState();
}

class _ImageWidgetState extends State<ImageWidget> {
  @override
  Widget build(BuildContext context) {
    if (TaskController_more.tasks.isNotEmpty) {
      return Image.network(
        widget.url,
        height: 150,
        width: 150,
      );
    } else {
      return CircularProgressIndicator();
    }
  }
}

class AnimatedImageWidget extends StatefulWidget {
  final String url;
  final VoidCallback onTap;

  AnimatedImageWidget({required this.url, required this.onTap});

  @override
  _AnimatedImageWidgetState createState() => _AnimatedImageWidgetState();
}

class _AnimatedImageWidgetState extends State<AnimatedImageWidget> {
  double _size = 150.0;

  void _handleTapDown(TapDownDetails details) {
    setState(() {
      _size = 120.0;
    });
    Future.delayed(Duration(milliseconds: 200), () {
      widget.onTap();
    });
  }

  void _handleTapUp(TapUpDetails details) {
    setState(() {
      _size = 150.0;
    });
  }

  void _handleTapCancel() {
    setState(() {
      _size = 150.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        width: _size,
        height: _size,
        child: Image.network(
          widget.url,
          width: 150,
          height: 150,
        ),
      ),
    );
  }
}

Widget buildTasksPage(BuildContext context, Map<String, dynamic>? pageData) {
  return GamePage(pageData: pageData);
}
