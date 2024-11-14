import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'Observer.dart';
import 'pages/home_screen.dart'; // Assuming this is the main entry screen

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Observer(wordLength: 5, maxAttempts: 6)),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Wordle',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: const HomeScreen(), // Main entry screen
    );
  }
}
