import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../domain/game_entity.dart';

class GameLocalDataSource {
  static const String _gameStateKey = 'game_state';

  final SharedPreferences _prefs;

  GameLocalDataSource(this._prefs);

  Future<void> saveGameState(GameEntity game) async {
    final jsonString = jsonEncode(game.toJson());
    await _prefs.setString(_gameStateKey, jsonString);
  }

  GameEntity? loadGameState() {
    final jsonString = _prefs.getString(_gameStateKey);
    if (jsonString == null) return null;

    try {
      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      return GameEntity.fromJson(json);
    } catch (e) {
      return null;
    }
  }

  Future<void> clearGameState() async {
    await _prefs.remove(_gameStateKey);
  }
}
