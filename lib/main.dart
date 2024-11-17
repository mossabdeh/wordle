import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'Observer.dart';
import 'pages/home_screen.dart'; // Assuming this is the main entry screen

/// The entry point of the Wordle application.
///
/// This file sets up the app's dependencies and initializes the `MyApp` widget.
/// It uses the `MultiProvider` widget to provide global state management for the app.
void main() {
  runApp(
    MultiProvider(
      providers: [
        /// Provides an `Observer` instance globally for managing game state.
        /// - Default `wordLength`: 5
        /// - Default `maxAttempts`: 6
        ChangeNotifierProvider(create: (_) => Observer(wordLength: 5, maxAttempts: 6)),
      ],
      child: const MyApp(),
    ),
  );
}

/// The root widget of the Wordle application.
///
/// The `MyApp` widget sets up the application's theme and initial screen.
class MyApp extends StatelessWidget {
  /// Creates the `MyApp` widget.
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      /// Hides the debug banner in the app.
      debugShowCheckedModeBanner: false,

      /// The title of the application, shown in system task switchers.
      title: 'Wordle',

      /// Sets the theme for the application.
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),

      /// The initial screen displayed when the app launches.
      home: const HomeScreen(),
    );
  }
}
