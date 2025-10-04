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
          leading: Builder(
            builder: (context) {
              return IconButton(
                icon: Icon(Icons.menu),
                onPressed: () {
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
        drawer: MyDrawer(), // attach your custom drawer widget here
        body: SafeArea(child: Homepage()),
      ),
    );
  }
}
