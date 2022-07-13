import 'package:dart_app/models/player.dart';

class Team {
  String _name;
  List<Player> _players = [];

  String get getName => this._name;
  set setName(String name) => this._name = name;

  List<Player> get getPlayers => this._players;
  set setPlayers(List<Player> players) => this._players = players;

  Team({required name}) : _name = name;
}
