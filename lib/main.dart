// Entry point and top-level app scaffolding.
// This file wires up the MaterialApp, top AppBar and the main drawer.
// Keep runtime behavior unchanged — comments only.
import 'package:flutter/material.dart';
import 'package:todo_list/homepage.dart';
import 'package:todo_list/widgets/drawer.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          // Custom leading icon that opens the drawer. Using a Builder
          // so that we have a BuildContext which is a descendant of the
          // Scaffold, allowing Scaffold.of(context).openDrawer() to work.
          leading: Builder(
            builder: (context) {
              return IconButton(
                icon: Icon(Icons.menu),
                onPressed: () {
                  // Opens the Drawer defined in the Scaffold below.
                  Scaffold.of(context).openDrawer(); // Opens the drawer
                },
              );
            },
          ),
          title: Text('CheckboxList'),
          centerTitle: true,
          backgroundColor: Colors.greenAccent,
          elevation: 250,
          shadowColor: Colors.black,
        ),
        // Attach custom drawer and homepage content.
        drawer: MyDrawer(), // attach your custom drawer widget here
        body: SafeArea(child: Homepage()),
      ),
    );
  }
}
