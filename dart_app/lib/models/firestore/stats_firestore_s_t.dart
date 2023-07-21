import 'package:dart_app/models/games/game.dart';
import 'package:flutter/material.dart';

class StatsFirestoreSingleTraining_P with ChangeNotifier {
  List<Game_P> _games = [];
  bool _noGamesPlayed = false;
  bool _loadGames = true;
  bool _gameDeleted = false; // to hide loading spinner

  List<Game_P> _favouriteGames = [];
  bool _showFavouriteGames = false;

  bool get noGamesPlayed => this._noGamesPlayed;
  set noGamesPlayed(bool value) => this._noGamesPlayed = value;

  bool get loadGames => this._loadGames;
  set loadGames(bool value) => this._loadGames = value;

  List<Game_P> get games => this._games;
  set games(List<Game_P> value) => this._games = value;

  bool get gameDeleted => this._gameDeleted;
  set gameDeleted(bool value) => this._gameDeleted = value;

  List<Game_P> get favouriteGames => this._favouriteGames;
  set favouriteGames(List<Game_P> value) => this._favouriteGames = value;

  bool get showFavouriteGames => this._showFavouriteGames;
  set showFavouriteGames(bool value) => this._showFavouriteGames = value;

  resetGames() {
    games = [];
    favouriteGames = [];
    loadGames = false;
  }

  resetForResettingStats() {
    _games = [];
    _noGamesPlayed = true;
    _loadGames = false;
    _favouriteGames = [];
    _showFavouriteGames = false;
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
