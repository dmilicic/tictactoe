import 'dart:async';

import 'package:tictactoe2/ai/ai.dart';
import 'package:tictactoe2/ai/utils.dart';
import 'package:tictactoe2/storage/game_info_repository.dart';

class GamePresenter {

  // callbacks into our UI
  void Function(int idx) showMoveOnUi;
  void Function(int winningPlayer) showGameEnd;
  void Function(int winningLineIdx) showWinningLine;

  late GameInfoRepository _repository;
  late Ai _aiPlayer;

  GamePresenter(this.showMoveOnUi, this.showGameEnd, this.showWinningLine) {
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

    // artificial delay to make the game more interesting
    await Future(() => Future.delayed(const Duration(milliseconds: 500)));

    // do the next move
    board[aiMove] = Ai.AI_PLAYER;

    // evaluate the board after the AI player move
    evaluation = Utils.evaluateBoard(board);
    if (evaluation != Ai.NO_WINNERS_YET) {
      showMoveOnUi(aiMove);

      // wait until the move is shown on the UI
      await Future(() => Future.delayed(const Duration(milliseconds: 500)));

      onGameEnd(evaluation, board: board);
    } else {
      showMoveOnUi(aiMove);
    }
  }

  void onGameEnd(int winner, {List<int> board = const []}) async {
    if (winner == Ai.AI_PLAYER) {
      _repository.addVictory(); // add to the bot victories :)
    }

    final winningLineIdx = Utils.getWinningLineIdx(board);

    showWinningLine(winningLineIdx);

    // wait until the move is shown on the UI
    await Future(() => Future.delayed(const Duration(milliseconds: 500)));

    showGameEnd(winner);
  }
}