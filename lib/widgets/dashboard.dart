// A small dashboard card displayed at the top of the homepage.
// Currently shows the number of pending tasks passed from the parent.
import 'package:flutter/material.dart';

class Dashboard extends StatelessWidget {
  final int pendingCount; 
  const Dashboard({super.key, required this.pendingCount});

  // The dashboard is visual only and doesn't manage any state. For
  // future improvements this could be expanded to show completed tasks,
  // focus sessions, or productivity streaks.
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
