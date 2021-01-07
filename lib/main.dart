import 'package:flutter/material.dart';
import 'package:flutter_giphy/features/search/presentation/pages/search_page.dart';

void main() {
  runApp(GiphyApp());
}

class GiphyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Giphy search',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SearchPage(),
    );
  }
}
