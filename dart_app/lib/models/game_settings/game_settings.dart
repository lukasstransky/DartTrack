import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/game_settings_x01.dart';
import 'package:flutter/material.dart';

class GameSettings with ChangeNotifier {
  GameSettings() {}

  factory GameSettings.fromMapX01(map) {
    return GameSettingsX01.firestore(
      checkoutCounting: map['checkoutCounting'],
      legs: map['legs'],
      modeIn: map['modeIn'] == "Single"
          ? SingleOrDouble.SingleField
          : SingleOrDouble.DoubleField,
      modeOut: map['modeOut'] == "Single"
          ? SingleOrDouble.SingleField
          : SingleOrDouble.DoubleField,
      points: map['points'],
      sets: map['sets'] == null ? 0 : map['sets'],
      singleOrTeam: map['singleOrTeam'] == "Single"
          ? SingleOrTeamEnum.Single
          : SingleOrTeamEnum.Team,
      winByTwoLegsDifference: map['winByTwoLegsDifference'],
    );
  }
}
