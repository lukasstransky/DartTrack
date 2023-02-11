import 'package:dart_app/models/games/game.dart';
import 'package:flutter/material.dart';

class StatsFirestoreSingleDoubleTraining_P with ChangeNotifier {
  List<Game_P> _games = [];
  bool _noGamesPlayed = false;
  bool _gamesLoaded = false;

  List<Game_P> _favouriteGames = [];
  bool _showFavouriteGames = false;

  bool get noGamesPlayed => this._noGamesPlayed;
  set noGamesPlayed(bool value) => this._noGamesPlayed = value;

  bool get gamesLoaded => this._gamesLoaded;
  set gamesLoaded(bool value) => this._gamesLoaded = value;

  List<Game_P> get games => this._games;
  set games(List<Game_P> value) => this._games = value;

  List<Game_P> get favouriteGames => this._favouriteGames;
  set favouriteGames(List<Game_P> value) => this._favouriteGames = value;

  bool get showFavouriteGames => this._showFavouriteGames;
  set showFavouriteGames(bool value) => this._showFavouriteGames = value;

  resetGames() {
    games = [];
    favouriteGames = [];
    gamesLoaded = false;
  }

  notify() {
    notifyListeners();
  }

  sortGames() {
    if (games.isNotEmpty) {
      games.sort();
    }
    if (favouriteGames.isNotEmpty) {
      favouriteGames.sort();
    }
  }
}
