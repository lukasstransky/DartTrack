import 'dart:math';

import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/game_settings_cricket_p.dart';
import 'package:dart_app/models/games/game.dart';
import 'package:dart_app/models/games/x01/helper/revert_helper.dart';
import 'package:dart_app/models/player.dart';
import 'package:dart_app/models/player_statistics/player_or_team_game_stats_cricket.dart';
import 'package:dart_app/models/team.dart';
import 'package:dart_app/screens/game_modes/shared/game/point_btns_three_darts/utils_point_btns_three_darts.dart';
import 'package:dart_app/utils/utils.dart';
import 'package:flutter/material.dart';

class GameCricket_P extends Game_P {
  PointType _currentPointType = PointType.Single;
  int _playerOrTeamLegStartIndex = 0;
  bool _areTeamStatsDisplayed = true;
  List<String> _legSetWithPlayerOrTeamWhoFinishedIt =
      []; // for reverting -> to set correct previous player/team
  List<List<String>> _currentPlayerOfTeamsBeforeLegFinish =
      []; // for reverting -> save current player whose turn it was before leg was finished for each team (e.g.: Leg 1; 'Strainski', 'a')

  GameCricket_P()
      : super(dateTime: DateTime.now(), name: GameMode.Cricket.name);

  PointType get getCurrentPointType => this._currentPointType;
  set setCurrentPointType(PointType value) => this._currentPointType = value;

  int get getPlayerOrTeamLegStartIndex => _playerOrTeamLegStartIndex;
  set setPlayerOrTeamLegStartIndex(int playerOrTeamLegStartIndex) =>
      _playerOrTeamLegStartIndex = playerOrTeamLegStartIndex;

  bool get getAreTeamStatsDisplayed => this._areTeamStatsDisplayed;
  set setAreTeamStatsDisplayed(bool value) =>
      this._areTeamStatsDisplayed = value;

  List<String> get getLegSetWithPlayerOrTeamWhoFinishedIt =>
      this._legSetWithPlayerOrTeamWhoFinishedIt;
  set setLegSetWithPlayerOrTeamWhoFinishedIt(List<String> value) =>
      this._legSetWithPlayerOrTeamWhoFinishedIt = value;

  List<List<String>> get getCurrentPlayerOfTeamsBeforeLegFinish =>
      this._currentPlayerOfTeamsBeforeLegFinish;
  set setCurrentPlayerOfTeamsBeforeLegFinish(List<List<String>> value) =>
      this._currentPlayerOfTeamsBeforeLegFinish = value;

  factory GameCricket_P.createGame(Game_P game) {
    GameCricket_P newGame = new GameCricket_P();

    newGame.setName = game.getName;
    newGame.setDateTime = game.getDateTime;
    newGame.setGameId = game.getGameId;
    newGame.setGameSettings = game.getGameSettings;
    newGame.setPlayerGameStatistics = game.getPlayerGameStatistics;
    newGame.setTeamGameStatistics = game.getTeamGameStatistics;
    newGame.setCurrentPlayerToThrow = game.getCurrentPlayerToThrow;
    newGame.setCurrentTeamToThrow = game.getCurrentTeamToThrow;
    newGame.setIsGameFinished = game.getIsGameFinished;
    newGame.setIsOpenGame = game.getIsOpenGame;
    newGame.setIsFavouriteGame = game.getIsFavouriteGame;
    newGame.setCurrentThreeDarts = game.getCurrentThreeDarts;
    newGame.setRevertPossible = game.getRevertPossible;

    return newGame;
  }

  factory GameCricket_P.fromMapCricket(
      dynamic map, GameMode mode, String gameId, bool openGame) {
    final Game_P game = Game_P.fromMap(map, mode, gameId, openGame);

    GameCricket_P gameCricket = new GameCricket_P();
    gameCricket.setGameId = game.getGameId;
    gameCricket.setName = game.getName;
    gameCricket.setIsGameFinished = game.getIsGameFinished;
    gameCricket.setIsOpenGame = game.getIsOpenGame;
    gameCricket.setIsFavouriteGame = game.getIsFavouriteGame;
    gameCricket.setDateTime = game.getDateTime;
    gameCricket.setGameSettings = game.getGameSettings;
    gameCricket.setRevertPossible = game.getRevertPossible;
    gameCricket.setCurrentPlayerToThrow = game.getCurrentPlayerToThrow;
    gameCricket.setCurrentTeamToThrow = game.getCurrentTeamToThrow;
    gameCricket.setPlayerGameStatistics = game.getPlayerGameStatistics;
    gameCricket.setTeamGameStatistics = game.getTeamGameStatistics;
    gameCricket.setCurrentThreeDarts = game.getCurrentThreeDarts;
    gameCricket.setPlayerOrTeamLegStartIndex = map['playerOrTeamLegStartIndex'];
    gameCricket.setLegSetWithPlayerOrTeamWhoFinishedIt =
        map['legSetWithPlayerOrTeamWhoFinishedIt'] != null
            ? map['legSetWithPlayerOrTeamWhoFinishedIt'].cast<String>()
            : {};
    gameCricket.setCurrentPlayerOfTeamsBeforeLegFinish =
        map['currentPlayerOfTeamsBeforeLegFinish'] != null
            ? Utils.convertSimpleListBackToDoubleList(
                map['currentPlayerOfTeamsBeforeLegFinish'])
            : [];

    return gameCricket;
  }

  init(GameSettingsCricket_P gameSettings) {
    reset();

    setGameSettings = gameSettings;

    if (gameSettings.getSingleOrTeam == SingleOrTeamEnum.Single) {
      setCurrentPlayerToThrow = gameSettings.getPlayers.first;
    } else {
      setCurrentTeamToThrow = gameSettings.getTeams.first;

      // reverse players in teams
      for (Team team in gameSettings.getTeams) {
        team.setPlayers = team.getPlayers.reversed.toList();
      }
      // set players in correct order
      List<Player> players = [];
      for (Team team in gameSettings.getTeams) {
        for (Player player in team.getPlayers) {
          players.add(player);
        }
      }
      gameSettings.setPlayers = players;

      setCurrentPlayerToThrow = gameSettings.getTeams.first.getPlayers.first;
    }

    for (Player player in gameSettings.getPlayers) {
      final playerStats = new PlayerOrTeamGameStatsCricket(
        mode: GameMode.Cricket.name,
        player: player,
        dateTime: getDateTime,
      );
      for (int i = 15; i <= 20; i++) {
        playerStats.getScoresOfNumbers[i] = 0;
        playerStats.getPointsPerNumbers[i] = 0;
      }
      playerStats.getScoresOfNumbers[25] = 0;
      playerStats.getPointsPerNumbers[25] = 0;

      getPlayerGameStatistics.add(playerStats);
    }

    if (gameSettings.getSingleOrTeam == SingleOrTeamEnum.Team) {
      for (Team team in gameSettings.getTeams) {
        final teamStats = new PlayerOrTeamGameStatsCricket.Team(
          team: team,
          mode: GameMode.Cricket.name,
          dateTime: getDateTime,
        );
        for (int i = 15; i <= 20; i++) {
          teamStats.getScoresOfNumbers[i] = 0;
          teamStats.getPointsPerNumbers[i] = 0;
        }
        teamStats.getScoresOfNumbers[25] = 0;
        teamStats.getPointsPerNumbers[25] = 0;

        getTeamGameStatistics.add(teamStats);

        team.setCurrentPlayerToThrow = team.getPlayers.first;
      }

      // set team for player stats in order to sort them
      for (PlayerOrTeamGameStatsCricket playerStats
          in getPlayerGameStatistics) {
        final Team team =
            gameSettings.findTeamForPlayer(playerStats.getPlayer.getName);
        playerStats.setTeam = team;
      }

      getPlayerGameStatistics.sort((a, b) =>
          (a.getTeam as Team).getName.compareTo((b.getTeam as Team).getName));
    }
  }

  reset() {
    setCurrentPointType = PointType.Single;
    setPlayerOrTeamLegStartIndex = 0;
    setAreTeamStatsDisplayed = true;
    setCurrentPlayerOfTeamsBeforeLegFinish = [];
    setLegSetWithPlayerOrTeamWhoFinishedIt = [];

    setGameId = '';
    setDateTime = DateTime.now();
    setPlayerGameStatistics = [];
    setTeamGameStatistics = [];
    setCurrentPlayerToThrow = null;
    setCurrentTeamToThrow = null;
    setIsOpenGame = false;
    setIsGameFinished = false;
    setIsFavouriteGame = false;
    setRevertPossible = false;
    setCurrentThreeDarts = ['Dart 1', 'Dart 2', 'Dart 3'];
    setShowLoadingSpinner = false;
  }

  PlayerOrTeamGameStatsCricket getCurrentPlayerGameStats() {
    return getPlayerGameStatistics.firstWhere(
        (stats) => stats.getPlayer.getName == getCurrentPlayerToThrow.getName);
  }

  PlayerOrTeamGameStatsCricket getCurrentTeamGameStats() {
    return getTeamGameStatistics.firstWhere(
        (stats) => stats.getTeam.getName == getCurrentTeamToThrow.getName);
  }

  submitThrow(GameSettingsCricket_P settings, String scoredField,
      String scoredFieldWithPointType, BuildContext context,
      [bool shouldSubmitTeamStats = false]) {
    setRevertPossible = true;

    late final PlayerOrTeamGameStatsCricket currentStats;
    if (shouldSubmitTeamStats) {
      currentStats = getCurrentTeamGameStats();
    } else {
      UtilsPointBtnsThreeDarts.updateCurrentThreeDarts(
          getCurrentThreeDarts, scoredFieldWithPointType);
      currentStats = getCurrentPlayerGameStats();
    }

    final bool isTeamMode = settings.getSingleOrTeam == SingleOrTeamEnum.Team;
    // submit bust
    if (scoredField == 'Bust') {
      getCurrentThreeDarts[0] = '0';
      getCurrentThreeDarts[1] = '0';
      getCurrentThreeDarts[2] = '0';

      currentStats.setThrownDarts = currentStats.getThrownDarts + 3;
      currentStats.setThrownDartsInLeg = currentStats.getThrownDartsInLeg + 3;
      for (int i = 0; i < 3; i++) {
        currentStats.getAllScoresPerDart.add('0');
      }

      notify();
      // submit bust for team
      if (!shouldSubmitTeamStats && isTeamMode) {
        this.submitThrow(
            settings, scoredField, scoredFieldWithPointType, context, true);
      }
      return;
    }

    if (scoredField == 'Bull') {
      scoredField = '25';
    }

    final int scoredFieldParsed = int.parse(scoredField);
    final int? numberScore = currentStats.getScoresOfNumbers[scoredFieldParsed];
    final dynamic playerOrTeamStatsList =
        Utils.getPlayersOrTeamStatsList(this, isTeamMode);

    _updateScoreNumbersAndPoints(
        numberScore,
        currentStats,
        scoredField,
        scoredFieldParsed,
        settings,
        playerOrTeamStatsList,
        shouldSubmitTeamStats);

    // set all scores per dart
    if (scoredFieldWithPointType == 'Bull' &&
        getCurrentPointType == PointType.Double) {
      currentStats.getAllScoresPerDart.add('50');
    } else if (scoredFieldWithPointType == 'Bull' &&
        getCurrentPointType == PointType.Single) {
      currentStats.getAllScoresPerDart.add('25');
    } else {
      currentStats.getAllScoresPerDart.add(scoredFieldWithPointType);
    }

    // set thrown darts
    currentStats.setThrownDarts = currentStats.getThrownDarts + 1;
    currentStats.setThrownDartsInLeg = currentStats.getThrownDartsInLeg + 1;

    final String currentSetLegString =
        Utils.getCurrentSetLegAsString(this, this.getGameSettings);
    // check if leg is finished
    final bool isLegFinished = _isLegFinished(settings, playerOrTeamStatsList,
        settings.getMode, shouldSubmitTeamStats, currentSetLegString);
    if (isLegFinished) {
      final bool isSingleMode =
          settings.getSingleOrTeam == SingleOrTeamEnum.Single;

      // set player or team who finished current leg (on game level)
      if (isSingleMode && !shouldSubmitTeamStats ||
          !isSingleMode && shouldSubmitTeamStats) {
        String playerOrTeamName = this.getCurrentPlayerToThrow.getName;
        if (!isSingleMode) {
          playerOrTeamName = this.getCurrentTeamToThrow.getName;
        }
        this.getLegSetWithPlayerOrTeamWhoFinishedIt.add(playerOrTeamName);
      }

      // set current player of teams before leg finish
      if (shouldSubmitTeamStats && isTeamMode) {
        List<String> players = [];
        for (Team team in getGameSettings.getTeams) {
          players.add(team.getCurrentPlayerToThrow.getName);
        }
        getCurrentPlayerOfTeamsBeforeLegFinish.add(players);
      }

      Utils.setPlayerTeamLegStartIndex(this, settings, isSingleMode);

      // set team/player according to player/team leg start index
      if (!isSingleMode) {
        setCurrentTeamToThrow =
            settings.getTeams.elementAt(getPlayerOrTeamLegStartIndex);
        for (Team team in settings.getTeams) {
          team.setCurrentPlayerToThrow = team.getPlayers.first;
        }
        setCurrentPlayerToThrow = getCurrentTeamToThrow.getPlayers.first;
      } else {
        setCurrentPlayerToThrow =
            settings.getPlayers.elementAt(getPlayerOrTeamLegStartIndex);
      }

      // set current darts before leg finish
      currentStats.getCurrentThreeDartsBeforeLegFinished
          .add(List.of(getCurrentThreeDarts));
      if (shouldSubmitTeamStats && isTeamMode) {
        // also set for all players in tam
        for (PlayerOrTeamGameStatsCricket stats in getPlayerGameStatistics) {
          if (stats.getTeam.getName == currentStats.getTeam.getName) {
            stats.getCurrentThreeDartsBeforeLegFinished
                .add(List.of(getCurrentThreeDarts));
          }
        }
      }

      _addSetLegToWinnerAndResetStats(playerOrTeamStatsList, settings, context,
          currentStats, settings.getMode, currentSetLegString);

      // to set next player
      submit(settings, context);
    }

    // check if game is finished
    final bool isGameFinished =
        _isCricketGameFinished(settings, playerOrTeamStatsList);
    if (isGameFinished) {
      Navigator.of(context).pushNamed('/finishCricket');
    }

    // submit stats for team
    if (!shouldSubmitTeamStats && isTeamMode) {
      this.submitThrow(
          settings, scoredField, scoredFieldWithPointType, context, true);
    }

    if (!isGameFinished) {
      notify();
    }
  }

  submit(GameSettingsCricket_P settings, BuildContext context,
      [bool shouldSubmitTeamStats = false]) {
    final bool isSingleMode =
        settings.getSingleOrTeam == SingleOrTeamEnum.Single;

    // set next player/team
    final dynamic playerOrTeamStatsList =
        Utils.getPlayersOrTeamStatsList(this, !isSingleMode);
    bool isLegFinished = true;
    for (PlayerOrTeamGameStatsCricket stats in playerOrTeamStatsList) {
      if (stats.getThrownDartsInLeg > 0) {
        isLegFinished = false;
      }
    }

    if (!isLegFinished) {
      if (shouldSubmitTeamStats) {
        settings.setNextTeamAndPlayer(this, true);
      } else if (isSingleMode) {
        settings.setNextPlayer(this, true);
      }
    }

    // submit stats for team
    if (!shouldSubmitTeamStats && !isSingleMode) {
      this.submit(settings, context, true);
    }

    setCurrentPointType = PointType.Single;
    UtilsPointBtnsThreeDarts.resetCurrentThreeDarts(getCurrentThreeDarts);

    if (!isLegFinished) {
      notify();
    }
  }

  revert([bool shouldRevertTeamStats = false]) {
    final bool isTeamMode =
        this.getGameSettings.getSingleOrTeam == SingleOrTeamEnum.Team;
    final dynamic playerOrTeamStatsList =
        Utils.getPlayersOrTeamStatsList(this, isTeamMode);

    if (!_isRevertPossible(playerOrTeamStatsList) && !shouldRevertTeamStats) {
      return;
    }

    final bool legSetOrGameReverted =
        _legSetOrGameReverted(playerOrTeamStatsList);

    late PlayerOrTeamGameStatsCricket currentStats;
    if (shouldRevertTeamStats) {
      currentStats = this.getCurrentTeamGameStats();
    } else {
      if (getAmountOfDartsThrown() == 0) {
        _setPreviousPlayerOrTeam(legSetOrGameReverted);
      }

      currentStats = this.getCurrentPlayerGameStats();
    }

    final bool legSetOrGameRevertedBasedOnMode =
        (!isTeamMode && legSetOrGameReverted) ||
            (isTeamMode && legSetOrGameReverted && shouldRevertTeamStats);
    if (legSetOrGameRevertedBasedOnMode) {
      _revertStatsIfLegSetIsReverted(
          currentStats, playerOrTeamStatsList, isTeamMode);
    }

    // revert thrown darts
    currentStats.setThrownDarts = currentStats.getThrownDarts - 1;
    currentStats.setThrownDartsInLeg = currentStats.getThrownDartsInLeg - 1;

    _revertScoreNumberAndCurrentPoints(
        currentStats, isTeamMode, shouldRevertTeamStats);

    // revert current three darts
    if (legSetOrGameRevertedBasedOnMode) {
      setCurrentThreeDarts =
          currentStats.getCurrentThreeDartsBeforeLegFinished.removeLast();
    }
    final int amountOfDartsThrown = getAmountOfDartsThrown();
    if ((isTeamMode && shouldRevertTeamStats) ||
        (!isTeamMode && !shouldRevertTeamStats)) {
      if (amountOfDartsThrown == 0) {
        getCurrentThreeDarts[0] = currentStats.getAllScoresPerDart
            .elementAt(currentStats.getAllScoresPerDart.length - 2);
        getCurrentThreeDarts[1] = currentStats.getAllScoresPerDart.last;
        getCurrentThreeDarts[2] = 'Dart 3';
      } else {
        getCurrentThreeDarts[amountOfDartsThrown - 1] =
            'Dart ' + amountOfDartsThrown.toString();
      }
    }

    // if 1 score is left, the revert btn is still highlighted without this call
    _isRevertPossible(playerOrTeamStatsList);

    if (!shouldRevertTeamStats && isTeamMode) {
      revert(true);
    }

    notify();
  }

  bool isNumberClosed(
      int numberToCheck, GameSettingsCricket_P gameSettingsCricket) {
    for (PlayerOrTeamGameStatsCricket stats in Utils.getPlayersOrTeamStatsList(
        this, gameSettingsCricket.getSingleOrTeam == SingleOrTeamEnum.Team)) {
      final int? scoreNumber = stats.getScoresOfNumbers[numberToCheck];
      if (scoreNumber != null && scoreNumber < 3) {
        return false;
      }
    }

    return true;
  }

  /********************************************************************************* 
   ***************************    PRIVATE METHODS   ********************************
  **********************************************************************************/

  _revertScoreNumberAndCurrentPoints(PlayerOrTeamGameStatsCricket currentStats,
      bool isTeamMode, bool shouldRevertTeamStats) {
    final String thrownDartToRevert =
        currentStats.getAllScoresPerDart.removeLast();

    if (thrownDartToRevert != '0') {
      final String pointType = thrownDartToRevert[0];
      int numberScoreToSubtract = 1;
      String thrownDartToRevertWithoutPointType = thrownDartToRevert;

      if (pointType == 'D') {
        numberScoreToSubtract = 2;
        thrownDartToRevertWithoutPointType = thrownDartToRevert.substring(1);
      } else if (thrownDartToRevert == '50') {
        numberScoreToSubtract = 2;
        thrownDartToRevertWithoutPointType = '25';
      } else if (pointType == 'T') {
        numberScoreToSubtract = 3;
        thrownDartToRevertWithoutPointType = thrownDartToRevert.substring(1);
      }

      final int thrownDartToRevertWithoutPointTypeParsed =
          int.parse(thrownDartToRevertWithoutPointType);

      if (getGameSettings.getMode != CricketMode.NoScore) {
        final int scoreOfNumberOfDart = currentStats
            .getScoresOfNumbers[thrownDartToRevertWithoutPointTypeParsed]!;
        final int diffTo3 = scoreOfNumberOfDart - numberScoreToSubtract;
        int pointsToSubtract = 0;
        if (!isNumberClosed(
            thrownDartToRevertWithoutPointTypeParsed, this.getGameSettings)) {
          if (diffTo3 >= 3) {
            // score of number is still >= 3 -> subtract scoreToSubtract * dart thrown value
            pointsToSubtract = thrownDartToRevertWithoutPointTypeParsed *
                numberScoreToSubtract;
          } else if (diffTo3 < 3 && scoreOfNumberOfDart > 3) {
            // special cases
            if (scoreOfNumberOfDart == 5 && pointType == 'T') {
              pointsToSubtract = thrownDartToRevertWithoutPointTypeParsed * 2;
            } else if (scoreOfNumberOfDart == 4 &&
                (pointType == 'D' ||
                    pointType == 'T' ||
                    thrownDartToRevert == '50')) {
              pointsToSubtract = thrownDartToRevertWithoutPointTypeParsed;
            }
          }

          if (pointsToSubtract != 0) {
            // revert points
            if (getGameSettings.getMode == CricketMode.Standard) {
              currentStats.setCurrentPoints =
                  currentStats.getCurrentPoints - pointsToSubtract;
              currentStats.setTotalPoints =
                  currentStats.getTotalPoints - pointsToSubtract;
            } else if (getGameSettings.getMode == CricketMode.CutThroat) {
              for (PlayerOrTeamGameStatsCricket stats
                  in isTeamMode && shouldRevertTeamStats
                      ? getTeamGameStatistics
                      : getPlayerGameStatistics) {
                if (stats != currentStats) {
                  stats.setCurrentPoints =
                      stats.getCurrentPoints - pointsToSubtract;
                  stats.setTotalPoints =
                      stats.getTotalPoints - pointsToSubtract;
                }
              }
            }

            // revert points per numbers
            currentStats.getPointsPerNumbers[
                    thrownDartToRevertWithoutPointTypeParsed] =
                currentStats.getPointsPerNumbers[
                        thrownDartToRevertWithoutPointTypeParsed]! -
                    pointsToSubtract;
          }
        }
      }

      // revert score of number
      currentStats.getScoresOfNumbers[
          thrownDartToRevertWithoutPointTypeParsed] = currentStats
              .getScoresOfNumbers[thrownDartToRevertWithoutPointTypeParsed]! -
          numberScoreToSubtract;

      if (shouldRevertTeamStats) {
        for (PlayerOrTeamGameStatsCricket playerStats
            in getPlayerGameStatistics) {
          if (playerStats.getTeam.getName == currentStats.getTeam.getName) {
            playerStats.setScoresOfNumbers =
                Map.from(currentStats.getScoresOfNumbers);
          }
        }
      }

      // revert total marks
      currentStats.setTotalMarks =
          currentStats.getTotalMarks - numberScoreToSubtract;
    }
  }

  _revertStatsIfLegSetIsReverted(PlayerOrTeamGameStatsCricket currentStats,
      dynamic playerOrTeamStatsList, bool isTeamMode) {
    for (PlayerOrTeamGameStatsCricket stats in playerOrTeamStatsList) {
      // revert thrown darts in leg
      stats.setThrownDartsInLeg = stats.getThrownDartsPerLeg.removeLast();
      // revert current points
      stats.setCurrentPoints = stats.getPointsPerLeg.removeLast();
      // revert scores of numbers
      stats.setScoresOfNumbers = stats.getScoresOfNumbersPerLeg.removeLast();
    }
    if (isTeamMode) {
      for (PlayerOrTeamGameStatsCricket stats in getPlayerGameStatistics) {
        stats.setThrownDartsInLeg = stats.getThrownDartsPerLeg.removeLast();
        stats.setCurrentPoints = stats.getPointsPerLeg.removeLast();
        stats.setScoresOfNumbers = stats.getScoresOfNumbersPerLeg.removeLast();
      }
    }

    // revert set
    if (getGameSettings.getSetsEnabled &&
        currentStats.getSetsWon != 0 &&
        currentStats.getLegsWon == 0) {
      for (PlayerOrTeamGameStatsCricket stats in playerOrTeamStatsList) {
        stats.setLegsWon = stats.getAmountOfLegsPerSet.removeLast();
      }

      currentStats.setSetsWon = currentStats.getSetsWon - 1;
      currentStats.setLegsWon = getGameSettings.getLegs - 1;
    } else {
      // revert leg
      currentStats.setLegsWon = currentStats.getLegsWon - 1;
    }
    currentStats.setLegsWonTotal = currentStats.getLegsWonTotal - 1;
  }

  _setPreviousPlayerOrTeam(bool legSetOrGameReverted) {
    if (legSetOrGameReverted) {
      RevertHelper.setPreviousPlayerOrTeamLegSetReverted(
          this, this.getGameSettings);
    } else {
      RevertHelper.setPreviousPlayerOrTeamNoLegSetReverted(
          this, this.getGameSettings);
    }
  }

  bool _legSetOrGameReverted(dynamic playerOrTeamStatsList) {
    for (PlayerOrTeamGameStatsCricket stats in playerOrTeamStatsList) {
      if (stats.getThrownDartsInLeg != 0) {
        return false;
      }
    }
    return true;
  }

  bool _isRevertPossible(dynamic playerOrTeamStatsList) {
    bool result = false;
    for (PlayerOrTeamGameStatsCricket stats in playerOrTeamStatsList) {
      if (stats.getAllScoresPerDart.isNotEmpty) {
        result = true;
        break;
      }
    }

    setRevertPossible = result;
    notify();

    return result;
  }

  _addSetLegToWinnerAndResetStats(
      dynamic playerOrTeamStatsList,
      GameSettingsCricket_P settings,
      BuildContext context,
      PlayerOrTeamGameStatsCricket currentStats,
      CricketMode mode,
      String currentSetLegString) {
    final bool isTeamMode = settings.getSingleOrTeam == SingleOrTeamEnum.Team;

    if (settings.getMode != CricketMode.NoScore) {
      // check if all players have the same points -> draw
      bool isDrawLeg = true;
      int points = playerOrTeamStatsList[0].getCurrentPoints;
      for (PlayerOrTeamGameStatsCricket stats in playerOrTeamStatsList) {
        if (points != stats.getCurrentPoints) {
          isDrawLeg = false;
        }
      }

      if (!isDrawLeg) {
        // player with highest points won the leg (standard mode)
        // player with lowest points won the leg (cut throat mode)
        num points = mode == CricketMode.Standard
            ? 0
            : pow(2, 63) - 1; // pow assigns max num value

        late PlayerOrTeamGameStatsCricket winner;

        for (PlayerOrTeamGameStatsCricket stats in playerOrTeamStatsList) {
          if ((mode == CricketMode.Standard &&
                  stats.getCurrentPoints > points) ||
              (mode == CricketMode.CutThroat &&
                  stats.getCurrentPoints < points)) {
            points = stats.getCurrentPoints;
            winner = stats;
          }
        }

        _updateSetLegsForPlayerOrTeam(
            winner, settings, playerOrTeamStatsList, isTeamMode);
      } else {
        _updateSetLegsForPlayerOrTeam(
            currentStats, settings, playerOrTeamStatsList, isTeamMode);
      }
    } else {
      _updateSetLegsForPlayerOrTeam(
          currentStats, settings, playerOrTeamStatsList, isTeamMode);
    }

    // reset score & scores of numbers for each player for next leg
    _saveAndResetSomeStatsForEachPlayerOrTeam(false);
    if (isTeamMode) {
      _saveAndResetSomeStatsForEachPlayerOrTeam(true);
    }
  }

  _saveAndResetSomeStatsForEachPlayerOrTeam(bool resetTeamStats) {
    for (PlayerOrTeamGameStatsCricket stats
        in resetTeamStats ? getTeamGameStatistics : getPlayerGameStatistics) {
      // set scores of number per leg
      stats.getScoresOfNumbersPerLeg.add(Map.from(stats.getScoresOfNumbers));

      // set thrown darts per leg
      stats.getThrownDartsPerLeg.add(stats.getThrownDartsInLeg);

      // set points per leg
      stats.getPointsPerLeg.add(stats.getCurrentPoints);

      stats.setThrownDartsInLeg = 0;
      stats.setCurrentPoints = 0;

      for (int i = 15; i <= 20; i++) {
        stats.getScoresOfNumbers[i] = 0;
      }
      stats.getScoresOfNumbers[25] = 0;
    }
  }

  _updateSetLegsForPlayerOrTeam(
      PlayerOrTeamGameStatsCricket stats,
      GameSettingsCricket_P gameSettingsCricket,
      dynamic playerOrTeamStatsList,
      bool isTeamMode) {
    stats.setLegsWon = stats.getLegsWon + 1;
    stats.setLegsWonTotal = stats.getLegsWonTotal + 1;

    if (gameSettingsCricket.getSetsEnabled &&
        stats.getLegsWon == gameSettingsCricket.getLegs) {
      stats.setSetsWon = stats.getSetsWon + 1;

      // set amount of legs for each player/team -> to revert set
      for (PlayerOrTeamGameStatsCricket stats in playerOrTeamStatsList) {
        stats.getAmountOfLegsPerSet.add(stats.getLegsWon);
        stats.setLegsWon = 0;
      }
    }
  }

  _updateScoreNumbersAndPoints(
      int? numberScore,
      PlayerOrTeamGameStatsCricket currentStats,
      String scoredField,
      int scoredFieldParsed,
      GameSettingsCricket_P settings,
      dynamic playerOrTeamStatsList,
      bool shouldSubmitTeamStats) {
    if (numberScore != null) {
      late int scoreToAdd;
      switch (getCurrentPointType) {
        case PointType.Single:
          scoreToAdd = 1;
          break;
        case PointType.Double:
          scoreToAdd = 2;
          break;
        case PointType.Tripple:
          scoreToAdd = 3;
          break;
      }

      // set score of number
      final int newScoreOfNumber = numberScore + scoreToAdd;
      currentStats.getScoresOfNumbers[scoredFieldParsed] = newScoreOfNumber;
      // update score of numbers for all players in team -> proper update points for players from team
      if (shouldSubmitTeamStats) {
        for (PlayerOrTeamGameStatsCricket playerStats
            in getPlayerGameStatistics) {
          if (playerStats.getTeam.getName == currentStats.getTeam.getName) {
            playerStats.setScoresOfNumbers =
                Map.from(currentStats.getScoresOfNumbers);
          }
        }
      }

      // set total marks
      currentStats.setTotalMarks = currentStats.getTotalMarks + scoreToAdd;

      if ([0, 1, 2].contains(numberScore)) {
        if (_scoreNumberOpen(scoredFieldParsed, settings.getMode, currentStats,
                shouldSubmitTeamStats) &&
            (newScoreOfNumber == 4 || newScoreOfNumber == 5)) {
          final int scoredPoints =
              newScoreOfNumber == 4 ? scoredFieldParsed : 2 * scoredFieldParsed;
          _updatePointsBasedOnMode(settings, currentStats, scoredPoints,
              scoredFieldParsed, shouldSubmitTeamStats);
        }
      } else if (_scoreNumberOpen(scoredFieldParsed, settings.getMode,
          currentStats, shouldSubmitTeamStats)) {
        final int scoredPoints =
            int.parse(UtilsPointBtnsThreeDarts.calculatePoints(
          scoredField,
          this.getCurrentPointType,
          GameMode.Cricket,
        ));
        _updatePointsBasedOnMode(settings, currentStats, scoredPoints,
            scoredFieldParsed, shouldSubmitTeamStats);
      }
    }
  }

  _updatePointsBasedOnMode(
      GameSettingsCricket_P settings,
      PlayerOrTeamGameStatsCricket currentStats,
      int scoredPoints,
      int scoredField,
      bool shouldSubmitTeamStats) {
    if (settings.getMode == CricketMode.Standard) {
      currentStats.setCurrentPoints =
          currentStats.getCurrentPoints + scoredPoints;
      currentStats.setTotalPoints = currentStats.getTotalPoints + scoredPoints;
    } else if (settings.getMode == CricketMode.CutThroat) {
      // add points to all other players
      for (PlayerOrTeamGameStatsCricket stats
          in settings.getSingleOrTeam == SingleOrTeamEnum.Team &&
                  shouldSubmitTeamStats
              ? getTeamGameStatistics
              : getPlayerGameStatistics) {
        if (stats != currentStats &&
            stats.getScoresOfNumbers[scoredField]! < 3) {
          stats.setCurrentPoints = stats.getCurrentPoints + scoredPoints;
          stats.setTotalPoints = stats.getTotalPoints + scoredPoints;
        }
      }
    }

    // set points per numbers
    currentStats.getPointsPerNumbers[scoredField] =
        currentStats.getPointsPerNumbers[scoredField]! + scoredPoints;
  }

  bool _scoreNumberOpen(int scoredField, CricketMode cricketMode,
      PlayerOrTeamGameStatsCricket currentStats, bool shouldSubmitTeamStats) {
    final bool isTeamMode =
        this.getGameSettings.getSingleOrTeam == SingleOrTeamEnum.Team;

    if (cricketMode == CricketMode.NoScore) {
      return false;
    }

    if (currentStats.getScoresOfNumbers[scoredField]! < 3) {
      return false;
    }

    PlayerOrTeamGameStatsCricket statsToCompare = currentStats;
    // for team mode when submitting player points -> to not compare current player stats with the team stats
    if (!shouldSubmitTeamStats && isTeamMode) {
      for (PlayerOrTeamGameStatsCricket teamStats in getTeamGameStatistics) {
        if (teamStats.getTeam.getName == currentStats.getTeam.getName) {
          statsToCompare = teamStats;
        }
      }
    }

    for (PlayerOrTeamGameStatsCricket stats
        in Utils.getPlayersOrTeamStatsList(this, isTeamMode)) {
      if (stats != statsToCompare) {
        final int? numberScore = stats.getScoresOfNumbers[scoredField];
        if (numberScore != null && numberScore < 3) {
          return true;
        }
      }
    }

    return false;
  }

  bool _isLegFinished(
    GameSettingsCricket_P settings,
    dynamic playerOrTeamStatsList,
    CricketMode mode,
    bool shouldSubmitTeamStats,
    String currentSetLegString,
  ) {
    // if player who closed all numbers also have the highest/lowest points -> no chance for opponent to win the leg
    bool isLegFinished = true;

    for (PlayerOrTeamGameStatsCricket stats in playerOrTeamStatsList) {
      bool allNumbersClosed = true;
      isLegFinished = true;

      for (int scoreOfNumber in stats.getScoresOfNumbers.values) {
        if (scoreOfNumber < 3) {
          allNumbersClosed = false;
        }
      }

      if (allNumbersClosed) {
        // for case that one players closes all numbers but has less/more points than the opponent -> stil chance to win
        for (PlayerOrTeamGameStatsCricket statsForPoints
            in playerOrTeamStatsList) {
          if (stats != statsForPoints) {
            // either for standard mode or cricket
            if ((mode == CricketMode.Standard &&
                    stats.getCurrentPoints < statsForPoints.getCurrentPoints) ||
                (mode == CricketMode.CutThroat &&
                    stats.getCurrentPoints > statsForPoints.getCurrentPoints)) {
              isLegFinished = false;
            }
          }
        }
      } else {
        isLegFinished = false;
      }

      if (isLegFinished) {
        return true;
      }
    }

    return false;
  }

  // check for every player if game is finished
  bool _isCricketGameFinished(
      GameSettingsCricket_P settings, dynamic playerOrTeamStatsList) {
    for (PlayerOrTeamGameStatsCricket stats in playerOrTeamStatsList) {
      bool isGameFinished = false;
      if (settings.getSetsEnabled) {
        // set mode
        isGameFinished =
            Utils.gameWonFirstToWithSets(stats.getSetsWon, settings) ||
                Utils.gameWonBestOfWithSets(stats.getSetsWon, settings);
      } else {
        // leg mode
        isGameFinished =
            Utils.gameWonFirstToWithLegs(stats.getLegsWon, settings) ||
                Utils.gameWonBestOfWithLegs(stats.getLegsWon, settings);
      }
      if (isGameFinished) {
        return true;
      }
    }
    return false;
  }
}
