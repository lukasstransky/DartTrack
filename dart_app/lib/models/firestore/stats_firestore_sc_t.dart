import 'package:dart_app/models/games/game.dart';
import 'package:flutter/material.dart';

class StatsFirestoreScoreTraining_P with ChangeNotifier {
  List<Game_P> _games = [];
  bool _noGamesPlayed = false;
  bool _loadGames = true;

  List<Game_P> _favouriteGames = [];
  bool _showFavouriteGames = false;

  bool get noGamesPlayed => this._noGamesPlayed;
  set noGamesPlayed(bool value) => this._noGamesPlayed = value;

  bool get loadGames => this._loadGames;
  set loadGames(bool value) => this._loadGames = value;

  List<Game_P> get games => this._games;
  set games(List<Game_P> value) => this._games = value;

  List<Game_P> get favouriteGames => this._favouriteGames;
  set favouriteGames(List<Game_P> value) => this._favouriteGames = value;

  bool get showFavouriteGames => this._showFavouriteGames;
  set showFavouriteGames(bool value) => this._showFavouriteGames = value;

  resetGames() {
    games = [];
    favouriteGames = [];
    loadGames = false;
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
