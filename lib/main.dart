import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:todo_app/screen/home.dart';
import 'dart:convert';


void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
  
    return  MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ToDo App',
      home: Home(),
    );
  }
}
