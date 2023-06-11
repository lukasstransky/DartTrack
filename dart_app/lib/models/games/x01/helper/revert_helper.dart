import 'package:dart_app/constants.dart';
import 'package:dart_app/models/player.dart';
import 'package:dart_app/models/team.dart';

class RevertHelper {
  static setPreviousPlayerOrTeamLegSetReverted(dynamic game, dynamic settings) {
    final bool isSingleMode =
        settings.getSingleOrTeam == SingleOrTeamEnum.Single;

    // set current player/team to throw
    final String playerOrTeamNameToFind =
        game.getLegSetWithPlayerOrTeamWhoFinishedIt.removeLast();

    if (isSingleMode) {
      for (Player player in settings.getPlayers) {
        if (player.getName == playerOrTeamNameToFind) {
          game.setCurrentPlayerToThrow = player;
          break;
        }
      }
    } else {
      for (Team team in settings.getTeams) {
        if (team.getName == playerOrTeamNameToFind) {
          game.setCurrentTeamToThrow = team;
          break;
        }
      }

      _setPreviousPlayerOfAllTeams(game, true);
    }

    // set start player/team index
    if (game.getReachedSuddenDeath) {
      // for case when sudden death game got reverted from finish screen
      if (game.getIsGameFinished &&
          !game.getSuddenDeathStarter.getSuddenDeathReverted) {
        game.getSuddenDeathStarter.setSuddenDeathReverted = true;
        if (isSingleMode) {
          game.setPlayerOrTeamLegStartIndex = settings.getPlayers
              .indexOf(game.getSuddenDeathStarter.getPlayer());
        } else {
          game.setPlayerOrTeamLegStartIndex =
              settings.getTeams.indexOf(game.getSuddenDeathStarter.getTeam());
        }
      } else {
        if (isSingleMode) {
          game.setPlayerOrTeamLegStartIndex = settings.getPlayers
              .indexOf(game.getSuddenDeathStarter.getPrevPlayer());
        } else {
          game.setPlayerOrTeamLegStartIndex = settings.getTeams
              .indexOf(game.getSuddenDeathStarter.getPrevTeam());
        }
      }
    } else {
      if (isSingleMode && game.getPlayerOrTeamLegStartIndex == 0) {
        game.setPlayerOrTeamLegStartIndex = settings.getPlayers.length - 1;
      } else if (!isSingleMode && game.getPlayerOrTeamLegStartIndex == 0) {
        game.setPlayerOrTeamLegStartIndex = settings.getTeams.length - 1;
      } else {
        game.setPlayerOrTeamLegStartIndex =
            game.getPlayerOrTeamLegStartIndex - 1;
      }
    }
  }

  static setPreviousPlayerOrTeamNoLegSetReverted(
      dynamic game, dynamic settings) {
    final int indexOfCurrentPlayer = settings.getPlayers.indexOf(settings
        .getPlayers
        .where((Player p) => p.getName == game.getCurrentPlayerToThrow.getName)
        .first);
    int indexOfCurrentTeam = 0;
    if (settings.getSingleOrTeam == SingleOrTeamEnum.Team) {
      indexOfCurrentTeam = settings.getTeams.indexOf(settings.getTeams
          .where((Team t) => t.getName == game.getCurrentTeamToThrow.getName)
          .first);
    }

    if (settings.getSingleOrTeam == SingleOrTeamEnum.Single) {
      // set previous player
      if ((indexOfCurrentPlayer - 1) < 0) {
        game.setCurrentPlayerToThrow = settings.getPlayers.last;
      } else {
        game.setCurrentPlayerToThrow =
            settings.getPlayers[indexOfCurrentPlayer - 1];
      }
    } else {
      // set previous team
      if ((indexOfCurrentTeam - 1) < 0) {
        game.setCurrentTeamToThrow = settings.getTeams.last;
      } else {
        game.setCurrentTeamToThrow = settings.getTeams[indexOfCurrentTeam - 1];
      }

      _setPreviousPlayerOfAllTeams(game, false);
    }
  }

  static _setPreviousPlayerOfAllTeams(dynamic game, bool setForAllTeams) {
    if (setForAllTeams) {
      final List<String> playerNames =
          game.getCurrentPlayerOfTeamsBeforeLegFinish.removeLast();

      // set previous player for each team, based on which player was the current player when leg was finished
      game.getGameSettings.getTeams.asMap().forEach((index, value) => {
            value.setCurrentPlayerToThrow =
                game.getGameSettings.getPlayerFromTeam(playerNames[index])
          });
    } else {
      _setPreviousPlayerForTeam(game.getCurrentTeamToThrow);
    }

    // set previous player overall
    game.setCurrentPlayerToThrow =
        game.getCurrentTeamToThrow.getCurrentPlayerToThrow;
  }

  static _setPreviousPlayerForTeam(Team team) {
    // get index of current player in team
    final List<Player> players = team.getPlayers;
    int indexOfCurrentPlayerInCurrentTeam = -1;
    for (int i = 0; i < players.length; i++) {
      if (players[i].getName == team.getCurrentPlayerToThrow.getName) {
        indexOfCurrentPlayerInCurrentTeam = i;
        break;
      }
    }

    // set previous player of team
    if ((indexOfCurrentPlayerInCurrentTeam - 1) < 0) {
      team.setCurrentPlayerToThrow = players.last;
    } else {
      team.setCurrentPlayerToThrow =
          players[indexOfCurrentPlayerInCurrentTeam - 1];
    }
  }
}
