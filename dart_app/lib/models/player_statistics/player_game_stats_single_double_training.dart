import 'dart:collection';

import 'package:dart_app/models/player.dart';
import 'package:dart_app/models/player_statistics/player_or_team_game_stats.dart';

class PlayerGameStatsSingleDoubleTraining extends PlayerOrTeamGameStats
    implements Comparable<PlayerGameStatsSingleDoubleTraining> {
  int _totalPoints = 0;
  int _thrownDarts = 0;
  int _singleHits = 0;
  int _doubleHits = 0;
  int _trippleHits = 0;
  int _missedHits = 0;
  SplayTreeMap<int, String> _fieldHits =
      new SplayTreeMap(); // e.g. 20: SST (Single, Single, Tripple hit -> 5 points)
  List<String> _allHits = []; // e.g. SSTDXXSDTTTXX (for reverting)
  int _highestPoints = 0; // to higlight fields hits

  PlayerGameStatsSingleDoubleTraining({
    required Player player,
    required String mode,
    required DateTime dateTime,
  }) : super.Player(
          gameId: '',
          player: player,
          mode: mode,
          dateTime: dateTime,
        );

  PlayerGameStatsSingleDoubleTraining.Firestore({
    required String gameId,
    required DateTime dateTime,
    required String mode,
    required Player? player,
    required int totalPoints,
    required int thrownDarts,
    required int singleHits,
    required int doubleHits,
    required int trippleHits,
    required int missedHits,
    required SplayTreeMap<int, String> fieldHits,
    required List<String> allHits,
    required int highestPoints,
  }) : super(gameId: gameId, dateTime: dateTime, mode: mode) {
    this.setPlayer = player;
    this.setTotalPoints = totalPoints;
    this.setThrownDarts = thrownDarts;
    this.setSingleHits = singleHits;
    this.setDoubleHits = doubleHits;
    this.setTrippleHits = trippleHits;
    this.setMissedHits = missedHits;
    this.setFieldHits = fieldHits;
    this.setAllHits = allHits;
    this.setHighestPoints = highestPoints;
  }

  int get getTotalPoints => this._totalPoints;
  set setTotalPoints(int value) => this._totalPoints = value;

  int get getThrownDarts => this._thrownDarts;
  set setThrownDarts(int value) => this._thrownDarts = value;

  int get getSingleHits => this._singleHits;
  set setSingleHits(int value) => this._singleHits = value;

  int get getDoubleHits => this._doubleHits;
  set setDoubleHits(int value) => this._doubleHits = value;

  int get getTrippleHits => this._trippleHits;
  set setTrippleHits(int value) => this._trippleHits = value;

  int get getMissedHits => this._missedHits;
  set setMissedHits(int value) => this._missedHits = value;

  SplayTreeMap<int, String> get getFieldHits => this._fieldHits;
  set setFieldHits(SplayTreeMap<int, String> value) => this._fieldHits = value;

  List<String> get getAllHits => this._allHits;
  set setAllHits(List<String> value) => this._allHits = value;

  int get getHighestPoints => this._highestPoints;
  set setHighestPoints(int value) => this._highestPoints = value;

  @override
  int compareTo(PlayerGameStatsSingleDoubleTraining other) {
    if (!(getTotalPoints < other.getTotalPoints)) {
      return -1;
    } else if (getTotalPoints < other.getTotalPoints) {
      return 1;
    } else {
      return 0;
    }
  }

  String getSingleHitsPercentage() {
    if (getThrownDarts == 0) {
      return '0';
    }
    return ((100 * getSingleHits) / getThrownDarts).round().toString();
  }

  String getTrippleHitsPercentage() {
    if (getThrownDarts == 0) {
      return '0';
    }
    return ((100 * getTrippleHits) / getThrownDarts).round().toString();
  }

  String getDoubleHitsPercentage() {
    if (getThrownDarts == 0) {
      return '0';
    }
    return ((100 * getDoubleHits) / getThrownDarts).round().toString();
  }

  String getMissedHitsPercentage() {
    if (getThrownDarts == 0) {
      return '0';
    }
    return ((100 * getMissedHits) / getThrownDarts).round().toString();
  }

  int getPointsForSpecificField(int field, bool isDoubleMode) {
    int result = 0;
    if (field <= 0 || field >= 21) {
      return result;
    }

    getFieldHits[field]!.split('').forEach((hit) {
      if (hit == 'S') {
        result += 1;
      } else if (hit == 'D') {
        if (isDoubleMode) {
          result += 1;
        } else {
          result += 2;
        }
      } else if (hit == 'T') {
        result += 3;
      }
    });

    return result;
  }
}
