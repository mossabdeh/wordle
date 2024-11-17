import 'package:flutter/material.dart';
import '../dao/partie_dao.dart';
import '../entities/partie.dart';


/// A screen to display game statistics and completed game sessions.
///
/// The `StatsScreen` widget fetches saved game data from the database using `PartieDAO`
/// and presents the data in a paginated list. Users can also view the guessed letters
/// in a grid format for individual games.
///
/// Features:
/// - Pagination to display a limited number of games per page.
/// - Visual representation of guessed letters in a dialog.
/// - Displays metadata for each game, such as word length, attempts, date, and mode.
class StatsScreen extends StatefulWidget {
  const StatsScreen({Key? key}) : super(key: key);

  @override
  _StatsScreenState createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  late Future<List<PartieEntity>> _partiesFuture;
  static const int _itemsPerPage = 5; // Limit number of items per page
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _partiesFuture = PartieDAO().getParties(); // Fetch saved games on init
  }

  /// Displays a grid of guessed letters for a specific game.
  ///
  /// Parameters:
  /// - [context]: The build context.
  /// - [guessedLetters]: A list of guessed letters.
  /// - [wordLength]: The length of the word for the game.
  ///
  /// Opens a dialog showing the guessed letters in a grid format, where the
  /// number of columns corresponds to the word length.
  void _showGuessedLettersGrid(BuildContext context, List<String> guessedLetters, int wordLength) {
    final gridSize = guessedLetters.length ~/ wordLength; // Calculate grid size

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          backgroundColor: const Color(0xFFFAF3E0), // Soft Cream
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Guessed Letters",
                  style: TextStyle(
                    fontFamily: 'Raleway',
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Color(0xFF6B8E23), // Olive Green
                  ),
                ),
                const SizedBox(height: 16),
                GridView.builder(
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: wordLength, // Word length determines columns
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemCount: guessedLetters.length,
                  itemBuilder: (context, index) {
                    return Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8F5E9), // Light Green
                        border: Border.all(color: const Color(0xFF6B8E23)), // Olive Green
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          guessedLetters[index],
                          style: const TextStyle(
                            fontFamily: 'Raleway',
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6B8E23), // Olive Green
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    "Close",
                    style: TextStyle(
                      fontFamily: 'Raleway',
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: AppBar(
          title: const Text(
            'Game Stats',
            style: TextStyle(
              color: Color(0xFF6B8E23), // Olive Green
              fontFamily: 'Raleway',
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
          centerTitle: true,
          backgroundColor: const Color(0xFFFAF3E0), // Soft Cream
          elevation: 0,
          iconTheme: const IconThemeData(color: Color(0xFF6B8E23)),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFAF3E0), Color(0xFFDCE7C5)], // Subtle cream gradient
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<List<PartieEntity>>(
          future: _partiesFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(
                child: Text(
                  'No game data found.',
                  style: TextStyle(
                    fontFamily: 'Raleway',
                    fontSize: 18,
                    color: Color(0xFF6B8E23),
                  ),
                ),
              );
            } else {
              final parties = snapshot.data!;
              final paginatedParties = parties.skip(_currentPage * _itemsPerPage).take(_itemsPerPage).toList();

              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: paginatedParties.length,
                      itemBuilder: (context, index) {
                        final partie = paginatedParties[index];
                        final guessedLetters = partie.guessedLetters.split('');
                        final wordLength = partie.wordLength;
                        final attempts = partie.attempts + 1; // Adjust attempts

                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 4,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Secret Word: ${partie.secretWord}",
                                  style: const TextStyle(
                                    fontFamily: 'Raleway',
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF6B8E23),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  "Date: ${partie.date.year}-${partie.date.month.toString().padLeft(2, '0')}-${partie.date.day.toString().padLeft(2, '0')} ${partie.date.hour.toString().padLeft(2, '0')}:${partie.date.minute.toString().padLeft(2, '0')}",
                                  style: const TextStyle(
                                    fontFamily: 'Raleway',
                                    fontSize: 16,
                                    color: Colors.black87,
                                  ),
                                ),
                                Text(
                                  "Word Length: ${partie.wordLength}",
                                  style: const TextStyle(
                                    fontFamily: 'Raleway',
                                    fontSize: 16,
                                    color: Colors.black87,
                                  ),
                                ),
                                Text(
                                  "Attempts: $attempts",
                                  style: const TextStyle(
                                    fontFamily: 'Raleway',
                                    fontSize: 16,
                                    color: Colors.black87,
                                  ),
                                ),
                                Text(
                                  "Game Mode: ${partie.gameMode}",
                                  style: const TextStyle(
                                    fontFamily: 'Raleway',
                                    fontSize: 16,
                                    color: Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF6B8E23),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                  ),
                                  onPressed: () {
                                    _showGuessedLettersGrid(context, guessedLetters, wordLength);
                                  },
                                  child: const Text(
                                    "Visualize Game",
                                    style: TextStyle(
                                      fontFamily: 'Raleway',
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Pagination Controls
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: _currentPage > 0
                            ? () {
                          setState(() {
                            _currentPage--;
                          });
                        }
                            : null,
                        style: TextButton.styleFrom(
                          foregroundColor: const Color(0xFF6B8E23),
                          disabledForegroundColor: Colors.grey,
                        ),
                        child: const Text(
                          "Previous",
                          style: TextStyle(
                            fontFamily: 'Raleway',
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Text(
                        "Page ${_currentPage + 1}",
                        style: const TextStyle(
                          fontFamily: 'Raleway',
                          fontSize: 16,
                          color: Color(0xFF6B8E23),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton(
                        onPressed: (_currentPage + 1) * _itemsPerPage < parties.length
                            ? () {
                          setState(() {
                            _currentPage++;
                          });
                        }
                            : null,
                        style: TextButton.styleFrom(
                          foregroundColor: const Color(0xFF6B8E23),
                          disabledForegroundColor: Colors.grey,
                        ),
                        child: const Text(
                          "Next",
                          style: TextStyle(
                            fontFamily: 'Raleway',
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
