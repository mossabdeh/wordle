
# Wordle

**A Flutter-based individual project for creating a letter-guessing game inspired by Wordle.**

## 📋 Project Description

This Wordle project is a letter-based puzzle game where players guess a secret word within a limited number of attempts. The game offers multiple modes:
- **Classic Mode**: Guess a fixed-length word within a set number of attempts.
- **Survival Mode**: Progress through levels with increasing word lengths and decreasing attempts.
- **Duel Mode**: Challenge another player in a round-based game, taking turns setting and guessing secret words.

The game provides a clean UI with animations and a responsive design for an engaging user experience.

---

## 🚀 Getting Started

Follow the steps below to set up and run the project on your local machine.

### Prerequisites

Ensure you have the following installed:
1. [Flutter SDK](https://docs.flutter.dev/get-started/install) (Version 3.0.0 or later recommended)
2. [Dart SDK](https://dart.dev/get-dart)
3. Android Studio, Xcode, or a code editor like VS Code for development.

### Installation Steps

1. **Clone the Repository**:
   ```bash
   git clone https://disc.univ-fcomte.fr/cr700-gitlab/mseideha/wordle
   cd wordle
   ```

2. **Install Flutter Dependencies**:
   Run the following command to fetch the required dependencies:
   ```bash
   flutter pub get
   ```

3. **Run the Application**:
   Start the application on a connected device or emulator:
   ```bash
   flutter run
   ```

---

## 📦 Project Structure

Here’s a brief overview of the project structure:

- **`lib/`**: Contains the main Flutter application code.
    - **`components/`**: UI components such as grid and keyboard rows.
    - **`entities/`**: Core game entities like `Letter` and `PartieEntity`.
    - **`pages/`**: Screens for game modes (`HomeScreen`, `ClassicGameScreen`, `SurvivalGameScreen`, etc.).
    - **`dao/`**: Data Access Object (`PartieDAO`) for managing game statistics using SQLite.
    - **`Observer.dart`**: Core game logic and state management for all game modes.

---

## 🕹️ Features

1. **Classic Mode**:
    - Guess a word of fixed length.
    - Set word length and number of attempts before starting.

2. **Survival Mode**:
    - Start with short words and increase the length as levels progress.
    - Decrease the number of attempts as difficulty increases.

3. **Duel Mode**:
    - Two players take turns setting and guessing each other's secret words.
    - Round-based gameplay with scores tracked for both players.

4. **Statistics**:
    - View your game history, including guessed words, win/loss records, and overall statistics.
    - Filter statistics by game mode.

5. **Customizable Gameplay**:
    - Adjustable word length, attempts, and rounds (for Duel Mode).

---

## 🛠️ Tools and Technologies

- **Flutter**: Cross-platform UI toolkit.
- **Provider**: State management for the app.
- **SQLite**: Local database for storing game statistics.
- **Dart**: Programming language for Flutter applications.

---

## 🌟 Screenshots

_Include relevant screenshots of your app (e.g., HomeScreen, Classic Mode, Survival Mode)._

![Screenshot_2024-11-17-19-03-50-15_9d28563678e7b0ada86d1b0c1fcf40c5.jpg](..%2F..%2FDownloads%2FScreenshot_2024-11-17-19-03-50-15_9d28563678e7b0ada86d1b0c1fcf40c5.jpg)
![Screenshot_2024-11-17-22-04-31-51_9d28563678e7b0ada86d1b0c1fcf40c5.jpg](..%2F..%2FDownloads%2FScreenshot_2024-11-17-22-04-31-51_9d28563678e7b0ada86d1b0c1fcf40c5.jpg)
![Screenshot_2024-11-17-22-57-36-18_9d28563678e7b0ada86d1b0c1fcf40c5.jpg](..%2F..%2FDownloads%2FScreenshot_2024-11-17-22-57-36-18_9d28563678e7b0ada86d1b0c1fcf40c5.jpg)
![Screenshot_2024-11-17-23-09-06-38_9d28563678e7b0ada86d1b0c1fcf40c5.jpg](..%2F..%2FDownloads%2FScreenshot_2024-11-17-23-09-06-38_9d28563678e7b0ada86d1b0c1fcf40c5.jpg)
![Screenshot_2024-11-17-23-09-58-95_9d28563678e7b0ada86d1b0c1fcf40c5.jpg](..%2F..%2FDownloads%2FScreenshot_2024-11-17-23-09-58-95_9d28563678e7b0ada86d1b0c1fcf40c5.jpg)
![Screenshot_2024-11-17-01-41-48-56_9d28563678e7b0ada86d1b0c1fcf40c5.jpg](..%2F..%2FDownloads%2FScreenshot_2024-11-17-01-41-48-56_9d28563678e7b0ada86d1b0c1fcf40c5.jpg)

---

## 📚 Resources

For help with Flutter development, check out these resources:
- [Flutter Documentation](https://docs.flutter.dev/)
- [Dart Documentation](https://dart.dev/)
- [Provider State Management](https://pub.dev/packages/provider)

---

## 📄 License

This project is licensed under the MIT License. See the `LICENSE` file for more details.

---

---

## 📘 Code Documentation

This project is thoroughly documented using DartDoc, ensuring clear explanations of all functions, classes, and components.
DartDoc is the official tool for generating API documentation for Dart and Flutter projects.

To generate the documentation, run the following command:

```bash
dart doc
```

The documentation will be generated in the `doc/` folder and can be opened in any browser.

For more details about DartDoc, visit [Dart Documentation](https://dart.dev/tools/dartdoc).

![wordleDocs.PNG](..%2F..%2FDesktop%2FwordleDocs.PNG)

---
