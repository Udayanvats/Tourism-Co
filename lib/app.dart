import 'package:flutter/material.dart';
import 'location_list.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    // ignore: prefer_const_constructors
    return MaterialApp(
      home: LocationList(),
      debugShowCheckedModeBanner: false,
    );
  }
}
