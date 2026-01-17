import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/game_entity.dart';
import '../bloc/game_bloc.dart';
import '../bloc/game_event.dart';
import '../bloc/game_state.dart';
import '../theme/app_theme.dart';
import '../widgets/game_board.dart';
import '../widgets/game_mode_selector.dart';
import '../widgets/game_status_card.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tic Tac Toe'),
        centerTitle: true,
      ),
      body: BlocConsumer<GameBloc, GameState>(
        listener: (context, state) {
          if (state is GameOver) {
            _showGameOverDialog(context, state);
          }
        },
        builder: (context, state) {
          if (state is GameInitial) {
            return Center(
              child: CircularProgressIndicator(
                color: AppTheme.primaryColor,
              ),
            );
          }

          final game = _getGameFromState(state);
          if (game == null) {
            return const Center(child: Text('Error loading game'));
          }

          return SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight - 32,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GameModeSelector(
                          currentMode: game.gameMode,
                          onModeChanged: (mode) {
                            context.read<GameBloc>().add(ChangeGameMode(mode));
                          },
                        ),
                        const SizedBox(height: 20),
                        GameStatusCard(game: game),
                        const SizedBox(height: 24),
                        Center(
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 360),
                            child: GameBoard(
                              game: game,
                              onCellTap: (index) {
                                context.read<GameBloc>().add(PlayerMove(index));
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        _buildRestartButton(context),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildRestartButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 280),
        child: ElevatedButton.icon(
          onPressed: () {
            context.read<GameBloc>().add(const RestartGame());
          },
          icon: const Icon(Icons.refresh_rounded),
          label: const Text(
            'New Game',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  GameEntity? _getGameFromState(GameState state) {
    if (state is GameInProgress) return state.game;
    if (state is GameOver) return state.game;
    return null;
  }

  void _showGameOverDialog(BuildContext context, GameOver state) {
    final isDraw = state.isDraw;
    final isX = state.winner == Player.x;
    final color = isDraw
        ? AppTheme.drawColor
        : (isX ? AppTheme.playerXColor : AppTheme.playerOColor);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        contentPadding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: isDraw
                    ? Icon(
                        Icons.handshake_rounded,
                        size: 40,
                        color: color,
                      )
                    : Text(
                        isX ? 'X' : 'O',
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.w800,
                          color: color,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              isDraw ? "It's a Draw!" : 'Player ${isX ? 'X' : 'O'} Wins!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              isDraw
                  ? 'Great game! Try again?'
                  : 'Congratulations!',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
        actionsAlignment: MainAxisAlignment.center,
        actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
            },
            child: Text(
              'Close',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: 8),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              context.read<GameBloc>().add(const RestartGame());
            },
            icon: const Icon(Icons.refresh_rounded, size: 18),
            label: const Text('Play Again'),
          ),
        ],
      ),
    );
  }
}
