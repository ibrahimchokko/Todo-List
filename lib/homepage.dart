import 'package:flutter/material.dart';
import 'package:todo_list/widgets/dashboard.dart';
import 'dart:async';

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

  // Toggle Completion
  void _toggleTaskCompletion(int index) {
    setState(() {
      _tasks[index].isCompleted = !_tasks[index].isCompleted;
    });
  }

  // Remove Task
  void _removeTask(int index) {
    setState(() {
      _tasks.removeAt(index);
    });
  }

  // Show Input Dialog (with timer input)
  void _showAddTaskDialog() {
    String title = "";
    int minutes = 0;
    int seconds = 0;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Add Task"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(labelText: "Task Title"),
                onChanged: (value) => title = value,
              ),
              const SizedBox(height: 10),
              TextField(
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "Minutes"),
                onChanged: (value) => minutes = int.tryParse(value) ?? 0,
              ),
              const SizedBox(height: 10),
              TextField(
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "Seconds"),
                onChanged: (value) => seconds = int.tryParse(value) ?? 0,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (title.isNotEmpty) {
                  setState(() {
                    _tasks.add(Task(
                      title: title,
                      minutes: minutes,
                      seconds: seconds,
                      remainingTime: Duration(minutes: minutes, seconds: seconds),
                    ));
                  });
                }
                Navigator.of(context).pop();
              },
              child: const Text("Add"),
            ),
          ],
        );
      },
    );
  }

  // Start Timer
  void _startTimer(Task task) {
    if (task.remainingTime == null || task.remainingTime!.inSeconds <= 0) return;

    task.isRunning = true;

    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (task.remainingTime!.inSeconds > 0 && task.isRunning) {
        setState(() {
          task.remainingTime = task.remainingTime! - const Duration(seconds: 1);
        });
      } else {
        timer.cancel();
        setState(() {
          task.isRunning = false;
        });
      }
    });
  }

  // Pause Timer
  void _pauseTimer(Task task) {
    setState(() {
      task.isRunning = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final int pendingCount =
        _tasks.where((task) => !task.isCompleted).length;

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
            // Dashboard shows pending count
            Dashboard(pendingCount: pendingCount),

            // Task list
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
                        final timeLeft = task.remainingTime ?? Duration.zero;

                        String formattedTime =
                            "${timeLeft.inMinutes.remainder(60).toString().padLeft(2, '0')}:${(timeLeft.inSeconds.remainder(60)).toString().padLeft(2, '0')}";

                        return ListTile(
                          title: Text(task.title),
                          subtitle: Text("Time Left: $formattedTime"),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(
                                  task.isRunning
                                      ? Icons.pause
                                      : Icons.play_arrow,
                                ),
                                onPressed: () {
                                  task.isRunning
                                      ? _pauseTimer(task)
                                      : _startTimer(task);
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () {
                                  _removeTask(index);
                                },
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

class Task {
  String title;
  bool isCompleted;
  int? minutes;
  int? seconds;
  Duration? remainingTime;
  bool isRunning;

  Task({
    required this.title,
    this.isCompleted = false,
    this.minutes,
    this.seconds,
    this.remainingTime,
    this.isRunning = false,
    int? durationInSeconds,
  });
}
