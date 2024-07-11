// phase_overview_screen.dart
import 'package:flutter/material.dart';
import 'models.dart'; // Import your data models
import 'phase_detail_screen.dart'; // Import PhaseDetailScreen

class PhaseOverviewScreen extends StatefulWidget {
  final Phase phase;

  PhaseOverviewScreen({required this.phase});

  @override
  _PhaseOverviewScreenState createState() => _PhaseOverviewScreenState();
}

class _PhaseOverviewScreenState extends State<PhaseOverviewScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<int> _characterCount;
  String _message = '';

  @override
  void initState() {
    super.initState();
    _message = "Hey! Let's start ${widget.phase.title}.";

    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    _characterCount = StepTween(begin: 0, end: _message.length)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.phase.title),
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(20),
            color: Colors.green,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'SECTION 1, UNIT 1',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  widget.phase.title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PhaseDetailScreen(phase: widget.phase),
                        ),
                      );
                    },
                    child: Column(
                      children: [
                        Image.asset('assets/image.png', width: 100, height: 100), // Adjust the path as needed
                        Text(
                          'START',
                          style: TextStyle(
                            color: Colors.green,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: AnimatedBuilder(
                      animation: _characterCount,
                      builder: (context, child) {
                        String text = _message.substring(0, _characterCount.value);
                        return Text(
                          text,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                          ),
                          textAlign: TextAlign.center,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
