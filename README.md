# Tic Tac Toe

A simple Tic-Tac-Toe game built with Flutter + BLoC.

## Run

```bash
flutter pub get
flutter run
```

## What it does

- Play against a friend or the computer
- Game auto-saves after each move (uses SharedPreferences)
- If you close the app mid-game, it picks up where you left off

## Project Structure

```
lib/
├── main.dart
├── data/
│   └── game_local_data_source.dart    # save/load game state
├── domain/
│   ├── game_entity.dart               # game model
│   └── game_logic.dart                # win detection, AI
└── presentation/
    ├── bloc/                          # GameBloc, events, states
    ├── screens/
    │   └── game_screen.dart
    ├── theme/
    │   └── app_theme.dart
    └── widgets/                       # board, cell, mode selector, etc.
```
## Setup

1. Clone the repo
```bash
git clone <repo-url>
cd game_assessment
```

2. Get dependencies
```bash
flutter pub get
```

3. Run the app
```bash
flutter run
```

 

## Tech

- **flutter_bloc** - state management
- **equatable** - for comparing BLoC states/events
- **shared_preferences** - local storage

## Build

```bash
# Android
flutter build apk

# iOS
flutter build ios

# Web
flutter build web
```
