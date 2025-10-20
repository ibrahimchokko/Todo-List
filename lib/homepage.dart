// Main homepage with task list and task model.
// This file contains the Homepage widget that manages an in-memory list
// of Task objects, UI to add/remove tasks, and a Task model with a
// simple countdown timer implemented using Timer and a StreamController.
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:todo_list/widgets/dashboard.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final List<Task> _tasks = [];

  // Add Task Logic
  void _addTask(String title, {int? durationInSeconds}) {
    setState(() {
      _tasks.add(Task(title: title, durationInSeconds: durationInSeconds));
    });
  }

  // Toggle Completion (Instant complete)
  void _toggleTaskCompletion(int index) {
    setState(() {
      final task = _tasks[index];
      task.isCompleted = !task.isCompleted;
      if (task.isCompleted) {
        // If the user marks the task completed, stop its timer (if any).
        task.stopTimer();
      } else if (task.durationInSeconds != null &&
          task.durationInSeconds! > 0) {
        // If unchecking a timed task, restart the countdown.
        task.restartTimer();
      }
    });
  }

  // Remove Task
  void _removeTask(int index) {
    setState(() {
      _tasks[index].dispose();
      _tasks.removeAt(index);
    });
  }

  // Show Input Dialog
  void _showAddTaskDialog() {
    String newTask = "";
    String timerMinutes = "";
    String timerSeconds = "";

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Add Task"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                onChanged: (value) => newTask = value,
                decoration: const InputDecoration(hintText: "Enter task name"),
              ),
              const SizedBox(height: 10),
              TextField(
                keyboardType: TextInputType.number,
                onChanged: (value) => timerMinutes = value,
                decoration: const InputDecoration(
                  hintText: "Minutes (optional)",
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                keyboardType: TextInputType.number,
                onChanged: (value) => timerSeconds = value,
                decoration: const InputDecoration(
                  hintText: "Seconds (optional)",
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                // Only add a task when a non-empty name is provided.
                if (newTask.trim().isNotEmpty) {
                  int totalSeconds = 0;
                  if (timerMinutes.isNotEmpty) {
                    totalSeconds += (int.tryParse(timerMinutes) ?? 0) * 60;
                  }
                  if (timerSeconds.isNotEmpty) {
                    totalSeconds += int.tryParse(timerSeconds) ?? 0;
                  }
                  _addTask(
                    newTask.trim(),
                    durationInSeconds: totalSeconds > 0 ? totalSeconds : null,
                  );
                }
                Navigator.pop(context);
              },
              child: const Text("Add"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
  // Calculate pending tasks for the dashboard widget.
  final int pendingCount = _tasks.where((task) => !task.isCompleted).length;

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTaskDialog,
        backgroundColor: Colors.greenAccent,
        elevation: 10,
        child: const Icon(Icons.add),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Dashboard(pendingCount: pendingCount),
            Expanded(
              child: _tasks.isEmpty
                  ? const Center(
                      child: Text(
                        "No tasks yet. Add one with the + button!",
                        style: TextStyle(fontSize: 16),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _tasks.length,
                      itemBuilder: (context, index) {
                        final task = _tasks[index];
                        // Each task is represented by a ListTile with a
                        // leading checkbox, title, optional timer subtitle
                        // and trailing actions (reset/delete).
                        return ListTile(
                          leading: Checkbox(
                            value: task.isCompleted,
                            onChanged: (value) => _toggleTaskCompletion(index),
                          ),
                          title: Text(
                            task.title,
                            style: TextStyle(
                              decoration: task.isCompleted
                                  ? TextDecoration.lineThrough
                                  : null,
                              color: task.isCompleted
                                  ? Colors.grey
                                  : Colors.black,
                            ),
                          ),
                          // If the task has a duration, show a live-updating
                          // timer using a StreamBuilder that listens to the
                          // Task.timerStream. Otherwise show a static "Completed"
                          // label when appropriate.
                          subtitle: task.durationInSeconds != null
                              ? StreamBuilder<int>(
                                  stream: task.timerStream,
                                  builder: (context, snapshot) {
                                    final remaining =
                                        snapshot.data ??
                                        task.remainingDuration ??
                                        task.durationInSeconds!;
                                    final minutes = remaining ~/ 60;
                                    final seconds = remaining % 60;
                                    return Text(
                                      task.isCompleted
                                          ? "Completed \u2705"
                                          : "Timer: ${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}",
                                    );
                                  },
                                )
                              : task.isCompleted
                              ? const Text("Completed \u2705")
                              : null,
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (task.durationInSeconds != null)
                                IconButton(
                                  icon: const Icon(
                                    Icons.refresh,
                                    color: Colors.blueAccent,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      task.restartTimer();
                                    });
                                  },
                                ),
                              IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.redAccent,
                                ),
                                onPressed: () => _removeTask(index),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

// Task Model with Timer
class Task {
  String title;
  bool isCompleted;
  int? durationInSeconds;
  int? remainingDuration;
  final StreamController<int> _timerController =
      StreamController<int>.broadcast();
  Stream<int> get timerStream => _timerController.stream;
  Timer? _timer;

  Task({
    required this.title,
    this.isCompleted = false,
    this.durationInSeconds,
  }) {
    if (durationInSeconds != null && durationInSeconds! > 0) {
      restartTimer();
    }
  }

  void restartTimer() {
    stopTimer();
    if (durationInSeconds != null && durationInSeconds! > 0) {
      remainingDuration = durationInSeconds!;
      isCompleted = false;
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (isCompleted) {
          timer.cancel();
          return;
        }
        if (remainingDuration! > 0) {
          remainingDuration = remainingDuration! - 1;
          _timerController.add(remainingDuration!);
        } else {
          timer.cancel();
          isCompleted = true;
          _timerController.add(0);
        }
      });
    }
  }

  void stopTimer() {
    _timer?.cancel();
  }

  void dispose() {
    stopTimer();
    _timerController.close();
  }
}
