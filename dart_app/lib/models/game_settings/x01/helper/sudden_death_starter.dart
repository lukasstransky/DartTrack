import 'package:dart_app/models/player.dart';
import 'package:dart_app/models/team.dart';

class SuddenDeathStarter {
  final Player? player;
  final Team? team;
  final Player? prevPlayer;
  final Team? prevTeam;
  bool suddenDeathReverted = false;
  bool get getSuddenDeathReverted => this.suddenDeathReverted;
  set setSuddenDeathReverted(bool suddenDeathReverted) =>
      this.suddenDeathReverted = suddenDeathReverted;

  SuddenDeathStarter({this.player, this.team, this.prevPlayer, this.prevTeam});

  bool get isPlayer => player != null;
  bool get isTeam => team != null;
  bool get isPrevPlayer => prevPlayer != null;
  bool get isPrevTeam => prevTeam != null;

  Player getPlayer() {
    if (!isPlayer) {
      throw StateError(
          'No player is present. Check isPlayer before calling getPlayer');
    }
    return player!;
  }

  Team getTeam() {
    if (!isTeam) {
      throw StateError(
          'No team is present. Check isTeam before calling getTeam');
    }
    return team!;
  }

  Player getPrevPlayer() {
    if (!isPrevPlayer) {
      throw StateError(
          'No player is present. Check isPlayer before calling getPlayer');
    }
    return prevPlayer!;
  }

  Team getPrevTeam() {
    if (!isPrevTeam) {
      throw StateError(
          'No team is present. Check isTeam before calling getTeam');
    }
    return prevTeam!;
  }
}
