import 'dart:convert';
import 'package:flutter/services.dart' as rootBundle;
import 'dart:math';




Future<List<String>> loadWords() async {
  try {
    // Load the JSON file
    final String response = await rootBundle.rootBundle.loadString('assets/english_words.json');
    print("JSON file loaded successfully.");

    // Decode JSON directly as a list
    final List<dynamic> data = json.decode(response);
    final words = List<String>.from(data);  // Convert to List<String>

    print("Words extracted: ${words.length}"); // Debug: Check words extracted from JSON
    return words;
  } catch (e) {
    print("Error loading JSON: $e"); // Debug: Catch and print any errors
    return [];
  }
}

// TODO fix it for x letter
Future<String?> getRandomWord({int wordLength = 5}) async {
  final words = await loadWords();
  // Filter words to include only those with the specified length
  final filteredWords = words.where((word) => word.length == wordLength).toList();

  // Check if there are any words with the specified length available
  if (filteredWords.isNotEmpty) {
    final randomIndex = Random().nextInt(filteredWords.length);
    return filteredWords[randomIndex];
  } else {
    print("No words with $wordLength letters found.");
    return null;
  }
}


