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
  void _addTask(String title) {
    setState(() {
      _tasks.add(Task(title: title));
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

    // Show Input Dialog
  void _showAddTaskDialog() {
    String newTask = "";
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Add Task"),
          content: TextField(
            onChanged: (value) => newTask = value,
            decoration: const InputDecoration(hintText: "Enter task name"),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                if (newTask.trim().isNotEmpty) {
                  _addTask(newTask.trim());
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
    
    final int pendingCount =
        _tasks.where((task) => !task.isCompleted).length;

    return Scaffold(
      floatingActionButton: FloatingActionButton(onPressed: _showAddTaskDialog,
      backgroundColor: Colors.greenAccent,
      elevation: 10,
      child: Icon(Icons.add),
      ),
      body: SafeArea(
        child: Expanded(
          child: Column(
            children: [
              Dashboard(pendingCount: pendingCount,),
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
                                  : TextDecoration.none,
                            ),
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _removeTask(index),
                          ),
                        );
                      },
                    ),
            ),
            ],
          ) ),
      ),
    );
  }
}
class Task {
  String title;
  bool isCompleted;

  Task({required this.title, this.isCompleted = false});
}