import 'package:equatable/equatable.dart';

import '../../domain/game_entity.dart';

sealed class GameEvent extends Equatable {
  const GameEvent();

  @override
  List<Object?> get props => [];
}

class StartGame extends GameEvent {
  const StartGame();
}

class PlayerMove extends GameEvent {
  final int index;

  const PlayerMove(this.index);

  @override
  List<Object?> get props => [index];
}

class ComputerMove extends GameEvent {
  const ComputerMove();
}

class RestartGame extends GameEvent {
  const RestartGame();
}

class ChangeGameMode extends GameEvent {
  final GameMode mode;

  const ChangeGameMode(this.mode);

  @override
  List<Object?> get props => [mode];
}
