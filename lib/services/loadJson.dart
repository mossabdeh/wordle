import 'dart:convert';
import 'package:flutter/services.dart' as rootBundle;
import 'dart:math';

/// Loads a list of English words from a JSON file.
///
/// The JSON file is expected to be located in the `assets` folder and contain a list of words.
/// - File path: `assets/english_words.json`
/// - The file should contain a JSON array of strings.
///
/// Example JSON file content:
/// ```json
/// ["apple", "banana", "cherry", "date"]
/// ```
///
/// - Returns: A `Future` that resolves to a `List<String>` containing the words,
/// or an empty list if an error occurs or the file is not found.
Future<List<String>> loadWords() async {
  try {
    // Load the JSON file
    final String response = await rootBundle.rootBundle.loadString('assets/english_words.json');
    print("JSON file loaded successfully.");

    // Decode JSON directly as a list
    final List<dynamic> data = json.decode(response);
    final words = List<String>.from(data); // Convert to List<String>

    print("Words extracted: ${words.length}"); // Debug: Check words extracted from JSON
    return words;
  } catch (e) {
    print("Error loading JSON: $e"); // Debug: Catch and print any errors
    return [];
  }
}

/// Retrieves a random word of a specific length from the loaded list of words.
///
/// This function filters the loaded words to include only those with the specified length,
/// then selects a random word from the filtered list.
///
/// - [wordLength]: The desired length of the word (default is 5).
/// - Returns: A `Future` that resolves to a random word of the specified length,
/// or `null` if no words of the given length are found.
///
/// Example:
/// ```dart
/// final word = await getRandomWord(wordLength: 5);
/// if (word != null) {
///   print("Random word: $word");
/// } else {
///   print("No words found.");
/// }
/// ```
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
