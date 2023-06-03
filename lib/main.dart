import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:responsi_123190162_mealdb/meal_category.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({Key? key, }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: const CategoryListPage()
      ),
    );
  }
}
