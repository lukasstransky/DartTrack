import 'package:dart_app/models/player.dart';

class Team {
  String _name;
  List<Player> _players = [];
  late Player _currPlayerToThrow;

  Team({required String name}) : _name = name;

  Team.Firestore(
      {required String name,
      required List<Player> players,
      required Player currentPlayerToThrow})
      : _name = name,
        _players = players,
        _currPlayerToThrow = currentPlayerToThrow;

  factory Team.fromMap(map) {
    return new Team.Firestore(
      name: map['name'],
      players: map['players'] == null
          ? []
          : map['players'].map<Player>((item) {
              return Player.fromMap(item);
            }).toList(),
      currentPlayerToThrow: Player.fromMap(map['currentPlayerToThrow']),
    );
  }

  Map<String, dynamic> toMap(Team team) {
    return {
      'name': team.getName,
      'players': team.getPlayers.map<Map<String, dynamic>>((item) {
        return item.toMap(item);
      }).toList(),
      'currentPlayerToThrow':
          team.getCurrPlayerToThrow.toMap(team.getCurrPlayerToThrow),
    };
  }

  String get getName => this._name;
  set setName(String value) => this._name = value;

  List<Player> get getPlayers => this._players;
  set setPlayers(List<Player> value) => this._players = value;

  Player get getCurrPlayerToThrow => this._currPlayerToThrow;
  set setCurrPlayerToThrow(Player value) => this._currPlayerToThrow = value;
}
