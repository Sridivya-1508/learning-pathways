// lib/roadmap_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
import 'models.dart'; // Import your data models
import 'phase_overview_screen.dart'; // Import PhaseOverviewScreen

class RoadmapScreen extends StatefulWidget {
  @override
  _RoadmapScreenState createState() => _RoadmapScreenState();
}

class _RoadmapScreenState extends State<RoadmapScreen> {
  late Future<LearningPath> _learningPathFuture;

  @override
  void initState() {
    super.initState();
    _learningPathFuture = loadLearningPathFromJson('assets/data/learning_path.json');
  }

  Future<LearningPath> loadLearningPathFromJson(String assetPath) async {
    try {
      String jsonString = await rootBundle.loadString(assetPath);
      Map<String, dynamic> jsonData = jsonDecode(jsonString);
      return LearningPath.fromJson(jsonData['LearningPath']);
    } catch (e) {
      throw Exception('Failed to load learning path: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Project Manager Roadmap')),
      body: FutureBuilder<LearningPath>(
        future: _learningPathFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            LearningPath learningPath = snapshot.data!;
            return _buildRoadmapContent(learningPath);
          } else {
            return Center(child: Text('No data found.'));
          }
        },
      ),
    );
  }

  Widget _buildRoadmapContent(LearningPath learningPath) {
    return GridView.builder(
      padding: EdgeInsets.all(10),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio:  3, // Adjusted aspect ratio
      ),
      itemCount: learningPath.phases.length,
      itemBuilder: (context, phaseIndex) {
        Phase phase = learningPath.phases[phaseIndex];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PhaseOverviewScreen(phase: phase),
              ),
            );
          },
          child: Card(
            color: _getPhaseColor(phaseIndex),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    phase.title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    phase.duration,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white70,  
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Color _getPhaseColor(int index) {
    List<Color> colors = [
      Colors.red,
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.cyan,
      Colors.pink,
      Colors.teal,
    ];
    return colors[index % colors.length];
  }
}
