import 'dart:ui';

import '../utils/Pair.dart';
import 'ai.dart';

class Utils {

  //region utility
  static bool isBoardFull(List<int> board) {
    for (var val in board) {
      if (val == Ai.EMPTY_SPACE) return false;
    }

    return true;
  }

  static bool isMoveLegal(List<int> board, int move) {
    if (move < 0 || move >= board.length ||
        board[move] != Ai.EMPTY_SPACE) {
      return false;
    }

    return true;
  }

  /// Returns the current state of the board [winning player, draw or no winners yet]
  static int evaluateBoard(List<int> board) {
    for (var list in Ai.WIN_CONDITIONS_LIST) {
      if(isWinningTriplet(board, list, Ai.HUMAN)) {
        return Ai.HUMAN;
      } else if (isWinningTriplet(board, list, Ai.AI_PLAYER)) {
        return Ai.AI_PLAYER;
      }
    }

    if (isBoardFull(board)) {
      return Ai.DRAW;
    }

    return Ai.NO_WINNERS_YET;
  }

  static bool isWinningTriplet(List<int> board, List<int> potentialWinningTriplet, int player) {
    final first = potentialWinningTriplet[0];
    final second = potentialWinningTriplet[1];
    final third = potentialWinningTriplet[2];

    if (board[first] == player && // if a player has played here AND
        board[first] == board[second] && // if all three positions are of the same player
        board[first] == board[third]) {
      return true;
    }

    return false;
  }

  static int getWinningLineIdx(List<int> board) {
    for (var i = 0; i < Ai.WIN_CONDITIONS_LIST.length; i++) {
      var list = Ai.WIN_CONDITIONS_LIST[i];
      if(isWinningTriplet(board, list, Ai.HUMAN) ||
          isWinningTriplet(board, list, Ai.AI_PLAYER)) {
        return i;
      }
    }

    return -1;
  }

  static Pair<Offset, Offset>? getWinningLine(List<int> board) {
    for (var i = 0; i < Ai.WIN_CONDITIONS_LIST.length; i++) {
      var list = Ai.WIN_CONDITIONS_LIST[i];
      if(isWinningTriplet(board, list, Ai.HUMAN) ||
          isWinningTriplet(board, list, Ai.AI_PLAYER)) {
        return Ai.winningLines[i];
      }
    }

    return null;
  }

  /// Returns the opposite player from the current one.
  static int flipPlayer(int currentPlayer) {
    return -1 * currentPlayer;
  }
//endregion
}