import 'package:flutter/material.dart';

import '../../domain/game_entity.dart';
import '../theme/app_theme.dart';

class GameCell extends StatelessWidget {
  final Player player;
  final bool isWinningCell;
  final VoidCallback? onTap;

  const GameCell({
    super.key,
    required this.player,
    required this.isWinningCell,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          color: _getBackgroundColor(),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: isWinningCell
                  ? AppTheme.winnerHighlight.withValues(alpha: 0.4)
                  : Colors.black.withValues(alpha: 0.08),
              blurRadius: isWinningCell ? 8 : 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: Text(
              _getSymbol(),
              key: ValueKey(player),
              style: TextStyle(
                fontSize: 52,
                fontWeight: FontWeight.w800,
                color: _getTextColor(),
                shadows: player != Player.none
                    ? [
                        Shadow(
                          color: _getTextColor().withValues(alpha: 0.3),
                          blurRadius: 4,
                          offset: const Offset(1, 1),
                        ),
                      ]
                    : null,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Color _getBackgroundColor() {
    if (isWinningCell) {
      return AppTheme.winnerHighlight.withValues(alpha: 0.25);
    }
    if (player != Player.none) {
      return Colors.white;
    }
    return AppTheme.boardColor;
  }

  String _getSymbol() {
    switch (player) {
      case Player.x:
        return 'X';
      case Player.o:
        return 'O';
      case Player.none:
        return '';
    }
  }

  Color _getTextColor() {
    switch (player) {
      case Player.x:
        return AppTheme.playerXColor;
      case Player.o:
        return AppTheme.playerOColor;
      case Player.none:
        return Colors.transparent;
    }
  }
}
