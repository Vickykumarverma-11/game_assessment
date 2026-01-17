import 'package:flutter/material.dart';

import '../../domain/game_entity.dart';
import '../theme/app_theme.dart';
import 'game_cell.dart';

class GameBoard extends StatelessWidget {
  final GameEntity game;
  final void Function(int index) onCellTap;

  const GameBoard({
    super.key,
    required this.game,
    required this.onCellTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryColor.withValues(alpha: 0.15),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: AspectRatio(
        aspectRatio: 1,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: 9,
            itemBuilder: (context, index) {
              final isWinningCell = game.winningLine?.contains(index) ?? false;
              final isPlayable =
                  !game.isGameOver && game.board[index] == Player.none;

              return GameCell(
                player: game.board[index],
                isWinningCell: isWinningCell,
                onTap: isPlayable ? () => onCellTap(index) : null,
              );
            },
          ),
        ),
      ),
    );
  }
}
