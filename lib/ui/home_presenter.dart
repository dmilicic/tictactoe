import 'package:flutter/widgets.dart';
import 'package:tictactoe2/storage/game_info_repository.dart';

class HomePresenter {

  Stream buildVictoriesStream() {
    return GameInfoRepository.instance.getVictoryStream();
  }

  /// Gets a victory count from a stream snapshot.
  int getVictoryCountFromStream(AsyncSnapshot snapshot) {
    return GameInfoRepository.instance.getVictoryCount(snapshot);
  }

}