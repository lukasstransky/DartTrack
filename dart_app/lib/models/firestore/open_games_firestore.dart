import 'package:dart_app/models/games/game.dart';

import 'package:flutter/material.dart';

// futurebuilder was not working -> therefore provider
class OpenGamesFirestore with ChangeNotifier {
  List<Game_P> _openGames = [];
  bool _init = false;

  List<Game_P> get openGames => this._openGames;
  set openGames(List<Game_P> value) => this._openGames = value;

  get init => this._init;
  set init(value) => this._init = value;

  notify() {
    notifyListeners();
  }

  reset() {
    _init = false;
    openGames = [];
  }
}
