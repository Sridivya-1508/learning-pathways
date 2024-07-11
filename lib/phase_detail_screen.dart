import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
import 'models.dart'; // Import your data models
import 'assessment_screen.dart'; // Import AssessmentScreen

class PhaseDetailScreen extends StatefulWidget {
  final Phase phase;

  PhaseDetailScreen({required this.phase});

  @override
  _PhaseDetailScreenState createState() => _PhaseDetailScreenState();
}

class _PhaseDetailScreenState extends State<PhaseDetailScreen> {
  Set<int> _completedModules = Set(); // Track completed modules
  Map<int, List<Map<String, dynamic>>> _questions = {};

  @override
  void initState() {
    super.initState();
    loadQuestions();
  }

  Future<void> loadQuestions() async {
    try {
      String questionsJsonString = await rootBundle.loadString('assets/data/questions.json');
      Map<String, dynamic> questionsJsonData = jsonDecode(questionsJsonString);
      setState(() {
        _questions = (questionsJsonData['questions'] as Map<String, dynamic>).map((key, value) {
          return MapEntry(int.parse(key.split('_')[1]), List<Map<String, dynamic>>.from(value));
        });
        
      });
    } catch (e) {
      print('Error loading questions: $e');
    }
  }

  void _completeAssessment(int index) {
    setState(() {
      _completedModules.add(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.phase.title),
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(10),
        itemCount: widget.phase.modules.length,
        itemBuilder: (context, index) {
          Module module = widget.phase.modules[index];
          int moduleNumber = module.number;
          List<Map<String, dynamic>> questions = _questions[moduleNumber] ?? [];

          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      if (_completedModules.contains(index))
                        Icon(Icons.check_circle, color: Colors.green),
                      SizedBox(width: 8),
                      Text(
                        module.title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                  Text(
                    module.description,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.black54,
                    ),
                  ),
                  SizedBox(height: 10),
                  _buildModuleActions(moduleNumber, index, questions),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildModuleActions(int moduleNumber, int index, List<Map<String, dynamic>> questions) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ElevatedButton(
          onPressed: () {
            // Handle coursework logic here
          },
          style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
          child: Text('Coursework', style: TextStyle(color: Colors.white)),
        ),
        ElevatedButton(
          onPressed: questions.isEmpty
            ? null
            : () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AssessmentScreen(
                      questions: questions,
                      phase: widget.phase,
                    ),
                  ),
                ).then((result) {
                  if (result == true) {
                    _completeAssessment(index);
                  }
                });
              },
          style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
          child: Text('Assessment', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}
