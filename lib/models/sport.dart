import 'package:flutter/material.dart';

class Sport {
  final String id;
  final String name;
  final IconData icon;

  Sport({
    required this.id,
    required this.name,
    required this.icon,
  });
}

final List<Sport> sportsList = [
  Sport(id: 'running', name: 'Running', icon: Icons.directions_run),
  Sport(id: 'cycling', name: 'Cycling', icon: Icons.directions_bike),
  Sport(id: 'hiking', name: 'Hiking', icon: Icons.terrain),
  Sport(id: 'swimming', name: 'Swimming', icon: Icons.person),
  Sport(id: 'soccer', name: 'Soccer', icon: Icons.sports_soccer),
  Sport(id: 'basketball', name: 'Basketball', icon: Icons.sports_basketball),
  Sport(id: 'baseball', name: 'Baseball', icon: Icons.sports_baseball),
];