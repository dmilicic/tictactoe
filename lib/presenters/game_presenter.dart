import 'dart:async';

import 'package:tictactoe2/ai/ai.dart';
import 'package:tictactoe2/ai/utils.dart';
import 'package:tictactoe2/storage/game_info_repository.dart';

class GamePresenter {

  // callbacks into our UI
  void Function(int idx) showMoveOnUi;
  void Function(int winningPlayer) showGameEnd;

  late GameInfoRepository _repository;
  late Ai _aiPlayer;

  GamePresenter(this.showMoveOnUi, this.showGameEnd) {
    _repository = GameInfoRepository.instance;
    _aiPlayer = Ai();
  }

  void onHumanPlayed(List<int> board) async {

    // evaluate the board after the human player
    int evaluation = Utils.evaluateBoard(board);
    if (evaluation != Ai.NO_WINNERS_YET) {
      onGameEnd(evaluation);
      return;
    }

    // calculate the next move, could be an expensive operation
    int aiMove = await Future(() => _aiPlayer.play(board, Ai.AI_PLAYER));

    // do the next move
    board[aiMove] = Ai.AI_PLAYER;

    // evaluate the board after the AI player move
    evaluation = Utils.evaluateBoard(board);
    if (evaluation != Ai.NO_WINNERS_YET) {
      onGameEnd(evaluation);
    } else {
      showMoveOnUi(aiMove);
    }
  }

  void onGameEnd(int winner) {
    if (winner == Ai.AI_PLAYER) {
      _repository.addVictory(); // add to the bot victories :)
    }

    showGameEnd(winner);
  }
}