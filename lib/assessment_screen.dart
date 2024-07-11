// assessment_screen.dart
import 'package:flutter/material.dart';
import 'models.dart'; // Import your data models

class AssessmentScreen extends StatefulWidget {
  final List<Map<String, dynamic>> questions;
  final Phase phase; // Pass the phase for navigation back

  AssessmentScreen({required this.questions, required this.phase});

  @override
  _AssessmentScreenState createState() => _AssessmentScreenState();
}

class _AssessmentScreenState extends State<AssessmentScreen> {
  int currentQuestionIndex = 0;
  bool isAnswered = false;
  String selectedOption = '';
  Color selectedColor = Colors.grey;
  bool showHint = false;

  void checkAnswer(String answer) {
    setState(() {
      isAnswered = true;
      selectedOption = answer;
      if (answer == widget.questions[currentQuestionIndex]['correct_answer']) {
        selectedColor = Colors.green;
      } else {
        selectedColor = Colors.red;
      }
    });
  }

  void previousQuestion() {
    if (currentQuestionIndex > 0) {
      setState(() {
        currentQuestionIndex--;
        resetState();
      });
    }
  }

  void nextQuestion() {
    if (currentQuestionIndex < widget.questions.length - 1) {
      setState(() {
        currentQuestionIndex++;
        resetState();
      });
    }
  }

  void resetState() {
    setState(() {
      selectedOption = '';
      showHint = false;
      isAnswered = false;
      selectedColor = Colors.grey;
    });
  }

  void skipQuestion() {
    nextQuestion();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.questions.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Assessment'),
        ),
        body: Center(
          child: Text(
            'No questions available for this module.',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      );
    }

    Map<String, dynamic> question = widget.questions[currentQuestionIndex];
    return Scaffold(
      appBar: AppBar(
        title: Text('Assessment'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              question['question'],
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            for (var option in question['options'])
              GestureDetector(
                onTap: () {
                  if (!isAnswered) {
                    checkAnswer(option);
                  }
                },
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 8),
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: selectedOption == option ? selectedColor : Colors.grey[200],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(option),
                ),
              ),
            SizedBox(height: 20),
            if (showHint)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  'Hint: ${question['hint']}',
                  style: TextStyle(color: Colors.blue, fontStyle: FontStyle.italic),
                ),
              ),
            Spacer(),
            Align(
              alignment: Alignment.bottomRight,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (currentQuestionIndex > 0)
                    ElevatedButton(
                      onPressed: previousQuestion,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        foregroundColor: Colors.white, // Text color
                      ),
                      child: Text('Previous'),
                    ),
                  SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context, false);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white, // Text color
                    ),
                    child: Text('End Test'),
                  ),
                  SizedBox(width: 10),
                  IconButton(
                    icon: Icon(Icons.lightbulb_outline),
                    color: Colors.yellow,
                    onPressed: () {
                      setState(() {
                        showHint = !showHint;
                      });
                    },
                  ),
                  SizedBox(width: 10),
                  if (currentQuestionIndex < widget.questions.length - 1)
                    ElevatedButton(
                      onPressed: skipQuestion,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple,
                        foregroundColor: Colors.white, // Text color
                      ),
                      child: Text('Skip'),
                    ),
                  SizedBox(width: 10),
                  if (currentQuestionIndex < widget.questions.length - 1)
                    ElevatedButton(
                      onPressed: nextQuestion,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white, // Text color
                      ),
                      child: Text('Next'),
                    ),
                  if (currentQuestionIndex == widget.questions.length - 1)
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context, true);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white, // Text color
                      ),
                      child: Text('Finish'),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
