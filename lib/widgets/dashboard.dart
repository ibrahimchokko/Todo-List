import 'dart:math';

import 'package:flutter/material.dart';

class Dashboard extends StatelessWidget {
  final int pendingCount; 
  const Dashboard({super.key, required this.pendingCount});

  // final List<String> _tasks = ["Finish Flutter project", "Buy groceries"];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        height: 250,
        child: Card(
          color: Colors.amberAccent,
          elevation: 10,
          margin: EdgeInsets.all(15),
          child: Center(
            child: Text(
            "You have $pendingCount pending tasks",
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    )
    );
  }
}
