// models.dart
import 'dart:convert';

class LearningPath {
  String title;
  String description;
  List<Phase> phases;

  LearningPath({required this.title, required this.description, required this.phases});

  factory LearningPath.fromJson(Map<String, dynamic> json) {
    return LearningPath(
      title: json['Title'],
      description: json['Description'],
      phases: (json['Phases'] as List)
          .map((phaseJson) => Phase.fromJson(phaseJson))
          .toList(),
    );
  }
}

class Phase {
  String title;
  String duration;
  String focus;
  List<Module> modules;

  Phase(
      {required this.title,
      required this.duration,
      required this.focus,
      required this.modules});

  factory Phase.fromJson(Map<String, dynamic> json) {
    return Phase(
      title: json['Title'],
      duration: json['Duration'],
      focus: json['Focus'],
      modules: (json['Modules'] as List)
          .map((moduleJson) => Module.fromJson(moduleJson))
          .toList(),
    );
  }
}

class Module {
  int number;
  String title;
  String description;
  String focusArea;

  Module(
      {required this.number,
      required this.title,
      required this.description,
      required this.focusArea});

  factory Module.fromJson(Map<String, dynamic> json) {
    return Module(
      number: json['Number'],
      title: json['Title'],
      description: json['Description'],
      focusArea: json['FocusArea'],
    );
  }
}
