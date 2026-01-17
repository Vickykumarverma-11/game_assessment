import 'dart:math';

import 'game_entity.dart';

class GameLogic {
  static const List<List<int>> winningCombinations = [
    [0, 1, 2],
    [3, 4, 5],
    [6, 7, 8],
    [0, 3, 6],
    [1, 4, 7],
    [2, 5, 8],
    [0, 4, 8],
    [2, 4, 6],
  ];

  static GameEntity makeMove(GameEntity game, int index) {
    if (game.isGameOver || game.board[index] != Player.none) {
      return game;
    }

    final newBoard = List<Player>.from(game.board);
    newBoard[index] = game.currentPlayer;

    final winResult = checkWin(newBoard, game.currentPlayer);
    if (winResult != null) {
      return game.copyWith(
        board: newBoard,
        winner: game.currentPlayer,
        winningLine: winResult,
      );
    }

    if (checkDraw(newBoard)) {
      return game.copyWith(board: newBoard, isDraw: true);
    }

    return game.copyWith(
      board: newBoard,
      currentPlayer: game.currentPlayer == Player.x ? Player.o : Player.x,
    );
  }

  static List<int>? checkWin(List<Player> board, Player player) {
    for (final combination in winningCombinations) {
      if (board[combination[0]] == player &&
          board[combination[1]] == player &&
          board[combination[2]] == player) {
        return combination;
      }
    }
    return null;
  }

  static bool checkDraw(List<Player> board) {
    return !board.contains(Player.none);
  }

  static int? getComputerMove(List<Player> board, Player computerPlayer) {
    final emptyIndices = <int>[];
    for (int i = 0; i < board.length; i++) {
      if (board[i] == Player.none) {
        emptyIndices.add(i);
      }
    }

    if (emptyIndices.isEmpty) return null;

    final winningMove = findWinningMove(board, computerPlayer);
    if (winningMove != null) return winningMove;

    final opponent = computerPlayer == Player.x ? Player.o : Player.x;
    final blockingMove = findWinningMove(board, opponent);
    if (blockingMove != null) return blockingMove;

    if (board[4] == Player.none) return 4;

    final corners = [0, 2, 6, 8];
    final availableCorners = corners
        .where((i) => board[i] == Player.none)
        .toList();
    if (availableCorners.isNotEmpty) {
      return availableCorners[Random().nextInt(availableCorners.length)];
    }

    return emptyIndices[Random().nextInt(emptyIndices.length)];
  }

  static int? findWinningMove(List<Player> board, Player player) {
    for (final combination in winningCombinations) {
      final values = [
        board[combination[0]],
        board[combination[1]],
        board[combination[2]],
      ];

      final playerCount = values.where((v) => v == player).length;
      final emptyCount = values.where((v) => v == Player.none).length;

      if (playerCount == 2 && emptyCount == 1) {
        for (final index in combination) {
          if (board[index] == Player.none) {
            return index;
          }
        }
      }
    }
    return null;
  }
}
