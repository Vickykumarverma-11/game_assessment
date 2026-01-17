import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/game_local_data_source.dart';
import '../../domain/game_entity.dart';
import '../../domain/game_logic.dart';
import 'game_event.dart';
import 'game_state.dart';

class GameBloc extends Bloc<GameEvent, GameState> {
  final GameLocalDataSource _dataSource;

  GameBloc(this._dataSource) : super(const GameInitial()) {
    on<StartGame>(_onStartGame);
    on<PlayerMove>(_onPlayerMove);
    on<ComputerMove>(_onComputerMove);
    on<RestartGame>(_onRestartGame);
    on<ChangeGameMode>(_onChangeGameMode);
  }

  Future<void> _onStartGame(StartGame event, Emitter<GameState> emit) async {
    final savedGame = _dataSource.loadGameState();

    if (savedGame != null && !savedGame.isGameOver) {
      emit(GameInProgress(savedGame));
    } else {
      final newGame = GameEntity.initial();
      await _dataSource.saveGameState(newGame);
      emit(GameInProgress(newGame));
    }
  }

  Future<void> _onPlayerMove(PlayerMove event, Emitter<GameState> emit) async {
    final currentState = state;
    if (currentState is! GameInProgress) return;

    final game = currentState.game;
    if (game.isGameOver || game.board[event.index] != Player.none) return;

    if (game.gameMode == GameMode.playerVsComputer &&
        game.currentPlayer != Player.x) {
      return;
    }

    final updatedGame = GameLogic.makeMove(game, event.index);
    await _dataSource.saveGameState(updatedGame);

    if (updatedGame.isGameOver) {
      emit(GameOver(updatedGame));
    } else {
      emit(GameInProgress(updatedGame));

      if (updatedGame.gameMode == GameMode.playerVsComputer) {
        add(const ComputerMove());
      }
    }
  }

  Future<void> _onComputerMove(
    ComputerMove event,
    Emitter<GameState> emit,
  ) async {
    final currentState = state;
    if (currentState is! GameInProgress) return;

    final game = currentState.game;
    if (game.isGameOver || game.currentPlayer != Player.o) return;

    await Future.delayed(const Duration(milliseconds: 300));

    final moveIndex = GameLogic.getComputerMove(game.board, Player.o);
    if (moveIndex == null) return;

    final updatedGame = GameLogic.makeMove(game, moveIndex);
    await _dataSource.saveGameState(updatedGame);

    if (updatedGame.isGameOver) {
      emit(GameOver(updatedGame));
    } else {
      emit(GameInProgress(updatedGame));
    }
  }

  Future<void> _onRestartGame(
    RestartGame event,
    Emitter<GameState> emit,
  ) async {
    final currentState = state;
    GameMode currentMode = GameMode.playerVsPlayer;

    if (currentState is GameInProgress) {
      currentMode = currentState.game.gameMode;
    } else if (currentState is GameOver) {
      currentMode = currentState.game.gameMode;
    }

    final newGame = GameEntity.initial(mode: currentMode);
    await _dataSource.saveGameState(newGame);
    emit(GameInProgress(newGame));
  }

  Future<void> _onChangeGameMode(
    ChangeGameMode event,
    Emitter<GameState> emit,
  ) async {
    final newGame = GameEntity.initial(mode: event.mode);
    await _dataSource.saveGameState(newGame);
    emit(GameInProgress(newGame));
  }
}
