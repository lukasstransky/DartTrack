import 'package:dart_app/models/games/game.dart';
import 'package:dart_app/models/player_statistics/player_or_team_game_stats_cricket.dart';
import 'package:flutter/material.dart';

class StatsFirestoreCricket_P with ChangeNotifier {
  // games
  List<Game_P> _games = [];
  bool _noGamesPlayed = false;
  bool _loadGames = true;
  bool _gameDeleted = false; // to hide loading spinner

  // player stats
  List<PlayerOrTeamGameStatsCricket> _allPlayerGameStats = [];
  bool _loadPlayerGameStats = true;
  bool _playerGameStatsLoaded = false;

  // team stats
  List<PlayerOrTeamGameStatsCricket> _allTeamGameStats = [];
  bool _loadTeamGameStats = true;
  bool _teamGameStatsLoaded = false;

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

  List<PlayerOrTeamGameStatsCricket> get allPlayerGameStats =>
      this._allPlayerGameStats;
  set allPlayerGameStats(List<PlayerOrTeamGameStatsCricket> value) =>
      this._allPlayerGameStats = value;

  bool get loadPlayerGameStats => this._loadPlayerGameStats;
  set loadPlayerGameStats(bool value) => this._loadPlayerGameStats = value;

  bool get playerGameStatsLoaded => this._playerGameStatsLoaded;
  set playerGameStatsLoaded(bool value) => this._playerGameStatsLoaded = value;

  List<PlayerOrTeamGameStatsCricket> get allTeamGameStats =>
      this._allTeamGameStats;
  set allTeamGameStats(List<PlayerOrTeamGameStatsCricket> value) =>
      this._allTeamGameStats = value;

  bool get loadTeamGameStats => this._loadTeamGameStats;
  set loadTeamGameStats(bool value) => this._loadTeamGameStats = value;

  bool get teamGameStatsLoaded => this._teamGameStatsLoaded;
  set teamGameStatsLoaded(bool value) => this._teamGameStatsLoaded = value;

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

  resetPlayerGameStats() {
    _allPlayerGameStats = [];
  }

  resetTeamGameStats() {
    _allTeamGameStats = [];
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
