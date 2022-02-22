import 'package:dart_app/models/player_model.dart';

class Team {
  String? _name;
  List<Player> _players = [];

  get getName => this._name;
  set setName(String name) => this._name = name;

  get getPlayers => this._players;
  set setPlayers(List<Player> players) => this._players = players;

  Team({required name}) : _name = name;
}
