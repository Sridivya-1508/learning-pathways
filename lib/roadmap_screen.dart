// roadmap_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
import 'models.dart'; // Import your data models
import 'phase_detail_screen.dart'; // Import PhaseDetailScreen

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
    String jsonString = await rootBundle.loadString(assetPath);
    Map<String, dynamic> jsonData = jsonDecode(jsonString);
    return LearningPath.fromJson(jsonData['LearningPath']);
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
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 1,
      ),
      itemCount: learningPath.phases.length,
      itemBuilder: (context, phaseIndex) {
        Phase phase = learningPath.phases[phaseIndex];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PhaseDetailScreen(phase: phase),
              ),
            );
          },
          child: Card(
            color: _getPhaseColor(phaseIndex),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Center(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      phase.title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 10),
                    Text(
                      phase.duration,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white70,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
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
