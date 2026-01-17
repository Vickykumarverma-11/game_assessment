import 'package:equatable/equatable.dart';

import '../../domain/game_entity.dart';

sealed class GameState extends Equatable {
  const GameState();

  @override
  List<Object?> get props => [];
}

class GameInitial extends GameState {
  const GameInitial();
}

class GameInProgress extends GameState {
  final GameEntity game;

  const GameInProgress(this.game);

  @override
  List<Object?> get props => [game];
}

class GameOver extends GameState {
  final GameEntity game;

  const GameOver(this.game);

  bool get isDraw => game.isDraw;
  Player? get winner => game.winner;

  @override
  List<Object?> get props => [game];
}
