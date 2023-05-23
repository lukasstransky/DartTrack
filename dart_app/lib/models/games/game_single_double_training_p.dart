import 'dart:math';

import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/game_settings_single_double_training_p.dart';
import 'package:dart_app/models/games/game.dart';
import 'package:dart_app/models/player.dart';
import 'package:dart_app/models/player_statistics/player_game_stats_single_double_training.dart';
import 'package:dart_app/screens/game_modes/shared/game/point_btns_three_darts/utils_point_btns_three_darts.dart';
import 'package:flutter/material.dart';

class GameSingleDoubleTraining_P extends Game_P {
  int _currentFieldToHit = 0;
  List<int> _randomFieldsGenerated =
      []; // for not generating the same number twice
  GameMode _mode = GameMode.SingleTraining;
  int _amountOfRoundsRemaining = -1; // for target number mode
  List<int> _allFieldsToHit = []; // e.g. '5', '13', '14' (for reverting)
  bool _randomModeFinished = false;
  bool _canBePressed = true; // to disable buttons when delay is active)
  final _random = new Random();

  GameSingleDoubleTraining_P()
      : super(dateTime: DateTime.now(), name: GameMode.SingleTraining.name);

  int get getCurrentFieldToHit => this._currentFieldToHit;
  set setCurrentFieldToHit(int value) => this._currentFieldToHit = value;

  List<int> get getRandomFieldsGenerated => this._randomFieldsGenerated;
  set setRandomFieldsGenerated(List<int> value) =>
      this._randomFieldsGenerated = value;

  GameMode get getMode => this._mode;
  set setMode(GameMode value) => this._mode = value;

  int get getAmountOfRoundsRemaining => this._amountOfRoundsRemaining;
  set setAmountOfRoundsRemaining(value) =>
      this._amountOfRoundsRemaining = value;

  List<int> get getAllFieldsToHit => this._allFieldsToHit;
  set setAllFieldsToHit(List<int> value) => this._allFieldsToHit = value;

  bool get getRandomModeFinished => this._randomModeFinished;
  set setRandomModeFinished(bool value) => this._randomModeFinished = value;

  bool get getCanBePressed => this._canBePressed;
  set setCanBePressed(bool canBePressed) {
    this._canBePressed = canBePressed;
  }

  factory GameSingleDoubleTraining_P.createGame(Game_P game) {
    GameSingleDoubleTraining_P newGame = new GameSingleDoubleTraining_P();

    newGame.setName = game.getName;
    newGame.setDateTime = game.getDateTime;
    newGame.setGameId = game.getGameId;
    newGame.setGameSettings = game.getGameSettings;
    newGame.setPlayerGameStatistics = game.getPlayerGameStatistics;
    newGame.setCurrentPlayerToThrow = game.getCurrentPlayerToThrow;
    newGame.setIsGameFinished = game.getIsGameFinished;
    newGame.setIsOpenGame = game.getIsOpenGame;
    newGame.setIsFavouriteGame = game.getIsFavouriteGame;
    if (game.getName == GameMode.SingleTraining.name) {
      newGame.setMode = GameMode.SingleTraining;
    } else {
      newGame.setMode = GameMode.DoubleTraining;
    }

    // needed for stats card
    if (game.getIsOpenGame) {
      newGame.setCurrentFieldToHit =
          (game as GameSingleDoubleTraining_P).getCurrentFieldToHit;
      newGame.setAmountOfRoundsRemaining = game.getAmountOfRoundsRemaining;
    }

    return newGame;
  }

  factory GameSingleDoubleTraining_P.fromMapSingleDoubleTraining(
      dynamic map, GameMode mode, String gameId, bool openGame) {
    final Game_P game = Game_P.fromMap(map, mode, gameId, openGame);

    GameSingleDoubleTraining_P gameSingleDouble =
        new GameSingleDoubleTraining_P();
    gameSingleDouble.setGameId = game.getGameId;
    gameSingleDouble.setName = game.getName;
    gameSingleDouble.setIsGameFinished = game.getIsGameFinished;
    gameSingleDouble.setIsOpenGame = game.getIsOpenGame;
    gameSingleDouble.setIsFavouriteGame = game.getIsFavouriteGame;
    gameSingleDouble.setDateTime = game.getDateTime;
    gameSingleDouble.setGameSettings = game.getGameSettings;
    gameSingleDouble.setRevertPossible = game.getRevertPossible;
    gameSingleDouble.setCurrentPlayerToThrow = game.getCurrentPlayerToThrow;
    gameSingleDouble.setPlayerGameStatistics = game.getPlayerGameStatistics;
    gameSingleDouble.setCurrentThreeDarts = game.getCurrentThreeDarts;

    gameSingleDouble.setCurrentFieldToHit = map['currentFieldToHit'];
    gameSingleDouble.setAmountOfRoundsRemaining =
        map['amountOfRoundsRemaining'] != null
            ? map['amountOfRoundsRemaining']
            : -1;
    gameSingleDouble.setRandomFieldsGenerated =
        map['randomFieldsGenerated'] != null
            ? map['randomFieldsGenerated'].cast<int>()
            : [];
    gameSingleDouble.setAllFieldsToHit =
        map['allFieldsToHit'] != null ? map['allFieldsToHit'].cast<int>() : [];

    return gameSingleDouble;
  }

  init(GameSettingsSingleDoubleTraining_P settings, GameMode mode) {
    if (settings.getPlayers.length != getPlayerGameStatistics.length) {
      reset();

      setGameSettings = settings;
      setMode = mode;

      if (getGameSettings.getIsTargetNumberEnabled) {
        setCurrentFieldToHit = getGameSettings.getTargetNumber;
        setAmountOfRoundsRemaining = getGameSettings.getAmountOfRounds;
      } else {
        switch (getGameSettings.getMode) {
          case ModesSingleDoubleTraining.Ascending:
            {
              setCurrentFieldToHit = 1;
              break;
            }
          case ModesSingleDoubleTraining.Descending:
            {
              setCurrentFieldToHit = 20;
              break;
            }
          case ModesSingleDoubleTraining.Random:
            {
              setCurrentFieldToHit = _getRandomValue(1, 21);
              break;
            }
        }
      }

      for (Player player in getGameSettings.getPlayers) {
        final PlayerGameStatsSingleDoubleTraining stats =
            new PlayerGameStatsSingleDoubleTraining(
          mode: mode == GameMode.SingleTraining
              ? GameMode.SingleTraining.name
              : GameMode.DoubleTraining.name,
          player: player,
          dateTime: getDateTime,
        );
        final int until = getGameSettings.getIsTargetNumberEnabled
            ? getGameSettings.getAmountOfRounds + 1
            : 21;

        for (int i = 1; i < until; i++) {
          stats.getFieldHits[i] = '-';
        }
        getPlayerGameStatistics.add(stats);
      }

      setPlayerGameStatistics = new List.from(getPlayerGameStatistics.reversed);
      getGameSettings.setPlayers =
          new List<Player>.from(getGameSettings.getPlayers.reversed);
      setCurrentPlayerToThrow = getPlayerGameStatistics.first.getPlayer;
    }
  }

  reset() {
    setCurrentFieldToHit = 0;
    setRandomFieldsGenerated = [];
    setMode = GameMode.SingleTraining;
    setAmountOfRoundsRemaining = -1;
    setAllFieldsToHit = [];
    setRandomModeFinished = false;
    setCanBePressed = true;

    setGameId = '';
    setName = '';
    setDateTime = DateTime.now();
    if (getGameSettings != null) {
      getGameSettings.reset();
    }
    setGameSettings = null;
    setPlayerGameStatistics = [];
    setCurrentPlayerToThrow = null;
    setIsOpenGame = false;
    setIsGameFinished = false;
    setIsFavouriteGame = false;
    setRevertPossible = false;
    setCurrentThreeDarts = ['Dart 1', 'Dart 2', 'Dart 3'];
    setShowLoadingSpinner = false;
  }

  int _getRandomValue(int min, int max) {
    if (getRandomFieldsGenerated.length == 20) {
      setRandomModeFinished = true;
      return -1;
    }

    int randomNumber;
    do {
      randomNumber = min + _random.nextInt(max - min);
    } while (getRandomFieldsGenerated.contains(randomNumber));

    getRandomFieldsGenerated.add(randomNumber);
    return randomNumber;
  }

  PlayerGameStatsSingleDoubleTraining getCurrentPlayerGameStats() {
    return getPlayerGameStatistics.firstWhere(
        (stats) => stats.getPlayer.getName == getCurrentPlayerToThrow.getName);
  }

  bool isGameFinished() {
    if (getGameSettings.getMode == ModesSingleDoubleTraining.Ascending &&
        getCurrentFieldToHit == 21) {
      return true;
    } else if (getGameSettings.getMode ==
            ModesSingleDoubleTraining.Descending &&
        getCurrentFieldToHit == 0) {
      return true;
    } else if (getGameSettings.getMode == ModesSingleDoubleTraining.Random &&
        getRandomModeFinished) {
      return true;
    } else if (getGameSettings.getIsTargetNumberEnabled &&
        getAmountOfRoundsRemaining == 0) {
      return true;
    }

    return false;
  }

  submit(String fieldValue, BuildContext context) {
    if (!getCanBePressed) {
      return;
    }

    UtilsPointBtnsThreeDarts.updateCurrentThreeDarts(
        getCurrentThreeDarts, fieldValue);

    // set can be pressed
    if (getAmountOfDartsThrown() == 3) {
      setCanBePressed = false;
      notify();
    }

    final PlayerGameStatsSingleDoubleTraining stats =
        getCurrentPlayerGameStats();

    setRevertPossible = true;

    // set thrown darts
    stats.setThrownDarts = stats.getThrownDarts + 1;

    // add to all hits
    stats.getAllHits.add(fieldValue);

    // set total points + hit
    switch (fieldValue) {
      case 'S':
        stats.setSingleHits = stats.getSingleHits + 1;
        stats.setTotalPoints = stats.getTotalPoints + 1;
        break;
      case 'D':
        stats.setDoubleHits = stats.getDoubleHits + 1;
        if (getMode == GameMode.DoubleTraining) {
          stats.setTotalPoints = stats.getTotalPoints + 1;
        } else {
          stats.setTotalPoints = stats.getTotalPoints + 2;
        }
        break;
      case 'T':
        stats.setTrippleHits = stats.getTrippleHits + 1;
        stats.setTotalPoints = stats.getTotalPoints + 3;
        break;
      case 'X':
        stats.setMissedHits = stats.getMissedHits + 1;
        break;
    }

    final int key = getGameSettings.getIsTargetNumberEnabled
        ? (getGameSettings.getAmountOfRounds - getAmountOfRoundsRemaining + 1)
        : getCurrentFieldToHit;

    // set field hits
    if (stats.getFieldHits[key] == '-') {
      stats.getFieldHits[key] = fieldValue;
    } else {
      stats.getFieldHits[key] = stats.getFieldHits[key]! + fieldValue;
    }

    bool _isGameFinished = false;
    if (getCurrentThreeDarts[2] != 'Dart 3') {
      // set highest points for round
      final int pointsForRound = stats.getPointsForSpecificField(
          key, getMode == GameMode.DoubleTraining);
      if (pointsForRound > stats.getHighestPoints) {
        stats.setHighestPoints = pointsForRound;
      }

      Future.delayed(Duration(milliseconds: 500), () {
        // set next player if needed
        if (getPlayerGameStatistics.length > 1) {
          final List<Player> players = getGameSettings.getPlayers;

          if (getPlayerGameStatistics.length > 1) {
            final int indexOfCurrentPlayer =
                players.indexOf(getCurrentPlayerToThrow);

            if (indexOfCurrentPlayer + 1 == players.length) {
              // round of all players finished -> restart from beginning
              setCurrentPlayerToThrow = players[0];
            } else {
              setCurrentPlayerToThrow = players[indexOfCurrentPlayer + 1];
            }
          }
        }

        if ((getPlayerGameStatistics.indexOf(stats) + 1) ==
            getGameSettings.getPlayers.length) {
          if (!getGameSettings.getIsTargetNumberEnabled) {
            // add to all fields to hit
            getAllFieldsToHit.add(getCurrentFieldToHit);

            // set new field to score
            switch (getGameSettings.getMode) {
              case ModesSingleDoubleTraining.Ascending:
                {
                  setCurrentFieldToHit = getCurrentFieldToHit + 1;
                  break;
                }
              case ModesSingleDoubleTraining.Descending:
                {
                  setCurrentFieldToHit = getCurrentFieldToHit - 1;
                  break;
                }
              case ModesSingleDoubleTraining.Random:
                {
                  setCurrentFieldToHit = _getRandomValue(1, 21);
                  if (getCurrentFieldToHit != -1) {
                    notify();
                  }
                  break;
                }
            }
          } else {
            setAmountOfRoundsRemaining = getAmountOfRoundsRemaining - 1;
          }

          _isGameFinished = isGameFinished();
          if (_isGameFinished) {
            Navigator.of(context).pushNamed(
              '/finishSingleDoubleTraining',
              arguments: {
                'mode': getMode,
              },
            );
          }
        } else {
          if (getPlayerGameStatistics.length > 1) {
            // add to all fields to hit
            getAllFieldsToHit.add(getCurrentFieldToHit);
          }
        }

        UtilsPointBtnsThreeDarts.resetCurrentThreeDarts(getCurrentThreeDarts);
        setCanBePressed = true;

        if (!_isGameFinished) {
          notify();
        }
      });
    } else {
      if (!_isGameFinished) {
        notify();
      }
    }
  }

  bool _isRevertPossible() {
    bool result = false;
    for (PlayerGameStatsSingleDoubleTraining stats in getPlayerGameStatistics) {
      if (stats.getAllHits.isNotEmpty) {
        result = true;
      }
    }

    setRevertPossible = result;
    notify();

    return result;
  }

  _setPreviousPlayer() {
    if (getGameSettings.getPlayers.length == 1) {
      return;
    }

    // set previous player
    final int indexOfCurrentPlayer = getGameSettings.getPlayers.indexOf(
        getGameSettings.getPlayers
            .where((p) => p.getName == getCurrentPlayerToThrow.getName)
            .first);

    if ((indexOfCurrentPlayer - 1) < 0) {
      setCurrentPlayerToThrow = getGameSettings.getPlayers.last;
    } else {
      setCurrentPlayerToThrow =
          getGameSettings.getPlayers[indexOfCurrentPlayer - 1];
    }
  }

  _setLastHits(String hits) {
    getCurrentThreeDarts[0] = hits[0];
    getCurrentThreeDarts[1] = hits[1];
  }

  revert(BuildContext context, bool isRevertedFromFinishScreenWithRandomMode) {
    if (!_isRevertPossible()) {
      return;
    }

    if (getAmountOfDartsThrown() == 0) {
      _setPreviousPlayer();
    }

    final PlayerGameStatsSingleDoubleTraining stats =
        getCurrentPlayerGameStats();

    // revert total points + hits
    switch (stats.getAllHits.removeLast()) {
      case 'S':
        stats.setSingleHits = stats.getSingleHits - 1;
        stats.setTotalPoints = stats.getTotalPoints - 1;
        break;
      case 'D':
        stats.setDoubleHits = stats.getDoubleHits - 1;
        if (getMode == GameMode.DoubleTraining) {
          stats.setTotalPoints = stats.getTotalPoints - 1;
        } else {
          stats.setTotalPoints = stats.getTotalPoints - 2;
        }
        break;
      case 'T':
        stats.setTrippleHits = stats.getTrippleHits - 1;
        stats.setTotalPoints = stats.getTotalPoints - 3;
        break;
      case 'X':
        stats.setMissedHits = stats.getMissedHits - 1;
        break;
    }

    // revert thrown darts
    stats.setThrownDarts = stats.getThrownDarts - 1;

    // reset highest points if neccessary
    _resetHighestPoints(stats);

    // revert current three darts
    if (getAmountOfDartsThrown() == 0) {
      if (!getGameSettings.getIsTargetNumberEnabled) {
        // revert current field to hit
        setCurrentFieldToHit = getAllFieldsToHit.removeLast();
      } else {
        if (getPlayerGameStatistics.length == 1 ||
            (getPlayerGameStatistics.length > 1 &&
                (getPlayerGameStatistics.indexOf(stats) + 1) ==
                    getGameSettings.getPlayers.length)) {
          setAmountOfRoundsRemaining = getAmountOfRoundsRemaining + 1;
        }
      }

      final int key = getGameSettings.getIsTargetNumberEnabled
          ? (getGameSettings.getAmountOfRounds - getAmountOfRoundsRemaining + 1)
          : getCurrentFieldToHit;
      _setLastHits(stats.getFieldHits[key]!);

      getCurrentThreeDarts[2] = 'Dart 3';
    } else {
      getCurrentThreeDarts[getAmountOfDartsThrown() - 1] =
          'Dart ' + getAmountOfDartsThrown().toString();
    }

    // revert random fields generated
    if (getGameSettings.getMode == ModesSingleDoubleTraining.Random &&
        getAmountOfDartsThrown() == 2 &&
        !isRevertedFromFinishScreenWithRandomMode &&
        getPlayerGameStatistics.indexOf(stats) ==
            getPlayerGameStatistics.length - 1) {
      getRandomFieldsGenerated.removeLast();
    }

    final int key = getGameSettings.getIsTargetNumberEnabled
        ? (getGameSettings.getAmountOfRounds - getAmountOfRoundsRemaining + 1)
        : getCurrentFieldToHit;

    // revert field hits
    if (stats.getFieldHits.containsKey(key)) {
      final String? value = stats.getFieldHits[key];

      stats.getFieldHits[key] = value!.substring(0, value.length - 1);

      // if value string is empty -> remove it from map
      if (stats.getFieldHits[key]!.length == 0) {
        stats.getFieldHits[key] = '-';
      }
    }

    _recalculateHighestPoints(stats);

    // if 1 score is left, the revert btn is still highlighted without this call
    _isRevertPossible();

    notify();
  }

  _resetHighestPoints(PlayerGameStatsSingleDoubleTraining stats) {
    late int key;
    if (getGameSettings.getIsTargetNumberEnabled) {
      key = getGameSettings.getAmountOfRounds - getAmountOfRoundsRemaining;
      if (key == 0) {
        key = 1;
      }
    } else {
      if (getGameSettings.getMode == ModesSingleDoubleTraining.Ascending) {
        key = getCurrentFieldToHit - (getAmountOfDartsThrown() == 0 ? 1 : 0);
      } else if (getGameSettings.getMode ==
          ModesSingleDoubleTraining.Descending) {
        key = getCurrentFieldToHit + (getAmountOfDartsThrown() == 0 ? 1 : 0);
      } else {
        // random
        if (getRandomFieldsGenerated.length == 1) {
          key = getRandomFieldsGenerated.elementAt(0);
        } else if (getRandomFieldsGenerated.length == 20) {
          key = getRandomFieldsGenerated
              .elementAt(getRandomFieldsGenerated.length - 1);
        } else {
          key = getRandomFieldsGenerated
              .elementAt(getRandomFieldsGenerated.length - 2);
        }
      }
    }

    if (stats.getHighestPoints ==
        stats.getPointsForSpecificField(
            key, getMode == GameMode.DoubleTraining)) {
      stats.setHighestPoints = -1;
    }
  }

  _recalculateHighestPoints(PlayerGameStatsSingleDoubleTraining stats) {
    if (getGameSettings.getMode == ModesSingleDoubleTraining.Random) {
      for (int randomField in getRandomFieldsGenerated) {
        final int pointsForRound = stats.getPointsForSpecificField(
            randomField, getMode == GameMode.DoubleTraining);

        if (pointsForRound > stats.getHighestPoints) {
          stats.setHighestPoints = pointsForRound;
        }
      }
    } else {
      final bool isDescendingMode =
          getGameSettings.getMode == ModesSingleDoubleTraining.Descending;
      late int i;
      late int until;
      if (getGameSettings.getIsTargetNumberEnabled) {
        i = 1;
        until = getGameSettings.getAmountOfRounds;
      } else {
        if (isDescendingMode) {
          i = 20;
          until = 1;
        } else {
          // ascending
          i = 1;
          until = 20;
        }
      }
      for (i;
          isDescendingMode ? i >= until : i <= until;
          isDescendingMode ? i-- : i++) {
        if (stats.getFieldHits[i] == '-') {
          break;
        }
        final int pointsForRound = stats.getPointsForSpecificField(
            i, getMode == GameMode.DoubleTraining);

        if (pointsForRound > stats.getHighestPoints) {
          stats.setHighestPoints = pointsForRound;
        }
      }
    }
  }
}
