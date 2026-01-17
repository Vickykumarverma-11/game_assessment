import 'package:equatable/equatable.dart';

enum Player { x, o, none }

enum GameMode { playerVsPlayer, playerVsComputer }

class GameEntity extends Equatable {
  final List<Player> board;
  final Player currentPlayer;
  final GameMode gameMode;
  final Player? winner;
  final List<int>? winningLine;
  final bool isDraw;

  const GameEntity({
    required this.board,
    required this.currentPlayer,
    required this.gameMode,
    this.winner,
    this.winningLine,
    this.isDraw = false,
  });

  factory GameEntity.initial({GameMode mode = GameMode.playerVsPlayer}) {
    return GameEntity(
      board: List.filled(9, Player.none),
      currentPlayer: Player.x,
      gameMode: mode,
      winner: null,
      winningLine: null,
      isDraw: false,
    );
  }

  GameEntity copyWith({
    List<Player>? board,
    Player? currentPlayer,
    GameMode? gameMode,
    Player? winner,
    List<int>? winningLine,
    bool? isDraw,
    bool clearWinner = false,
  }) {
    return GameEntity(
      board: board ?? this.board,
      currentPlayer: currentPlayer ?? this.currentPlayer,
      gameMode: gameMode ?? this.gameMode,
      winner: clearWinner ? null : (winner ?? this.winner),
      winningLine: clearWinner ? null : (winningLine ?? this.winningLine),
      isDraw: isDraw ?? this.isDraw,
    );
  }

  bool get isGameOver => winner != null || isDraw;

  Map<String, dynamic> toJson() {
    return {
      'board': board.map((p) => p.index).toList(),
      'currentPlayer': currentPlayer.index,
      'gameMode': gameMode.index,
      'winner': winner?.index,
      'winningLine': winningLine,
      'isDraw': isDraw,
    };
  }

  factory GameEntity.fromJson(Map<String, dynamic> json) {
    return GameEntity(
      board: (json['board'] as List).map((i) => Player.values[i]).toList(),
      currentPlayer: Player.values[json['currentPlayer']],
      gameMode: GameMode.values[json['gameMode']],
      winner: json['winner'] != null ? Player.values[json['winner']] : null,
      winningLine: json['winningLine'] != null
          ? List<int>.from(json['winningLine'])
          : null,
      isDraw: json['isDraw'] ?? false,
    );
  }

  @override
  List<Object?> get props => [
        board,
        currentPlayer,
        gameMode,
        winner,
        winningLine,
        isDraw,
      ];
}
