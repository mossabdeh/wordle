import 'package:flutter/material.dart';
import '../components/grid.dart';
import '../components/keyboard_row.dart';
import '../services/loadJson.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
/* that's the randomly wining word with 5 letter */
  late String winningWord;

  /* for showing that s the game is choosing a winning word*/
  bool loading = true;


  @override
  void initState() {
    super.initState();
    setWinningWord(); // Call an async function to initialize `winningWord`
  }

  Future<void> setWinningWord() async {
    print("Loading winning word...");

    // Call getRandomWord and check its output
    final word = await getRandomWord();
    if (word != null) {
      print("Winning word selected: $word");  // Debug: Check if word is being selected
      setState(() {
        winningWord = word;
        loading = false; // Set loading to false after initializing winningWord
      });
    } else {
      print("No 5-letter word found.");  // Debug: If getRandomWord returned null
    }
  }





  @override
  Widget build(BuildContext context) {
    if (loading) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Wordle'),
          centerTitle: true,
          elevation: 0,
        ),
        body: Center(child: CircularProgressIndicator()), // Show a loading spinner
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Wordle'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            flex: 7,
            child: Container(
              color: Colors.yellow,
              child: const Grid(),
            ),
          ),
          Expanded(
            flex: 4,
            child: Container(
              color: Colors.green,
              child: const Column(
                children: [
                  keyBoardRow(min: 1, max: 7),
                  keyBoardRow(min: 8, max: 15),
                  keyBoardRow(min: 16, max: 23),
                  keyBoardRow(min: 24, max: 29),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

}




