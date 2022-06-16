import 'package:dart_app/models/bot.dart';

class Player {
  String _name;

  get getName => this._name;
  set setName(String name) => this._name = name;

  Player({required String name}) : _name = name;

  factory Player.fromMap(map) {
    if (map.containsKey('preDefinedAverage')) {
      return new Bot(
          name: map['name'], preDefinedAverage: map['preDefinedAverage']);
    } else {
      return new Player(name: map['name']);
    }
  }

  Map<String, dynamic> toMap(Player player) {
    if (player is Bot) {
      return {
        'name': player.getName,
        'preDefinedAverage': player.getPreDefinedAverage
      };
    } else {
      return {'name': player.getName};
    }
  }

  static bool samePlayer(Player? playerA, Player playerB) {
    if (playerA != null && playerA.getName == playerB.getName) {
      if (playerA is Bot && playerB is Bot) {
        if (playerA.getPreDefinedAverage == playerB.getPreDefinedAverage) {
          return true;
        }
      } else if (!(playerA is Bot) && !(playerB is Bot)) {
        return true;
      }
    }
    return false;
  }

  static Player getPlayerFromList(List<Player> players, Player playerToFind) {
    late Player result;
    for (Player player in players) {
      if (player.getName == playerToFind.getName) {
        if (player is Bot && playerToFind is Bot) {
          if (player.getPreDefinedAverage ==
              playerToFind.getPreDefinedAverage) {
            result = player;
          }
        } else if (!(player is Bot) && !(playerToFind is Bot)) {
          result = player;
        }
      }
    }
    return result;
  }
}
