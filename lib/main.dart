import 'package:flutter/material.dart';
import 'package:sunglassesshop/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Eyewear Store',
      theme: ThemeData(
          bottomSheetTheme:
              const BottomSheetThemeData(backgroundColor: Colors.transparent),
          primarySwatch: Colors.blue,
          useMaterial3: false),
      home: const HomeScreen(),
    );
  }
}
