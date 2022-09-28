import 'package:dart_app/constants.dart';
import 'package:dart_app/models/default_settings_x01.dart';
import 'package:dart_app/models/game_settings/game_settings_x01.dart';
import 'package:dart_app/models/player.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DefaultSettingsHelper {
  static setDefaultSettings(BuildContext context) {
    final defaultSettingsX01 =
        Provider.of<DefaultSettingsX01>(context, listen: false);
    final settingsX01 = Provider.of<GameSettingsX01>(context, listen: false);

    defaultSettingsX01.automaticallySubmitPoints =
        settingsX01.getAutomaticallySubmitPoints;
    defaultSettingsX01.callerEnabled = settingsX01.getCallerEnabled;
    defaultSettingsX01.checkoutCountingFinallyDisabled =
        settingsX01.getCheckoutCountingFinallyDisabled;
    defaultSettingsX01.customPoints = settingsX01.getCustomPoints;
    defaultSettingsX01.enableCheckoutCounting =
        settingsX01.getEnableCheckoutCounting;
    defaultSettingsX01.inputMethod = settingsX01.getInputMethod;
    defaultSettingsX01.legs = settingsX01.getLegs;
    defaultSettingsX01.maxExtraLegs = settingsX01.getMaxExtraLegs;
    defaultSettingsX01.mode = settingsX01.getMode;
    defaultSettingsX01.modeIn = settingsX01.getModeIn;
    defaultSettingsX01.modeOut = settingsX01.getModeOut;
    defaultSettingsX01.points = settingsX01.getPoints;
    defaultSettingsX01.sets = settingsX01.getSets;
    defaultSettingsX01.setsEnabled = settingsX01.getSetsEnabled;
    defaultSettingsX01.showAverage = settingsX01.getShowAverage;
    defaultSettingsX01.showFinishWays = settingsX01.getShowFinishWays;
    defaultSettingsX01.showInputMethodInGameScreen =
        settingsX01.getShowInputMethodInGameScreen;
    defaultSettingsX01.showLastThrow = settingsX01.getShowLastThrow;
    defaultSettingsX01.showMostScoredPoints =
        settingsX01.getShowMostScoredPoints;
    defaultSettingsX01.showThrownDartsPerLeg =
        settingsX01.getShowThrownDartsPerLeg;
    defaultSettingsX01.singleOrTeam = settingsX01.getSingleOrTeam;
    defaultSettingsX01.suddenDeath = settingsX01.getSuddenDeath;
    defaultSettingsX01.vibrationFeedbackEnabled =
        settingsX01.getVibrationFeedbackEnabled;
    defaultSettingsX01.winByTwoLegsDifference =
        settingsX01.getWinByTwoLegsDifference;
    defaultSettingsX01.players = settingsX01.getPlayers;
    defaultSettingsX01.playersNames = [];
    defaultSettingsX01.drawMode = settingsX01.getDrawMode;

    for (Player player in settingsX01.getPlayers) {
      defaultSettingsX01.playersNames.add(player.getName);
    }

    settingsX01.notify();
  }

  static setSettingsFromDefault(BuildContext context) {
    final defaultSettingsX01 =
        Provider.of<DefaultSettingsX01>(context, listen: false);
    final settingsX01 = Provider.of<GameSettingsX01>(context, listen: false);

    settingsX01.setAutomaticallySubmitPoints =
        defaultSettingsX01.automaticallySubmitPoints;
    settingsX01.setCallerEnabled = defaultSettingsX01.callerEnabled;
    settingsX01.setCheckoutCountingFinallyDisabled =
        defaultSettingsX01.checkoutCountingFinallyDisabled;
    settingsX01.setEnableCheckoutCounting =
        defaultSettingsX01.enableCheckoutCounting;
    settingsX01.setInputMethod = defaultSettingsX01.inputMethod;
    settingsX01.setLegs = defaultSettingsX01.legs;
    settingsX01.setMaxExtraLegs = defaultSettingsX01.maxExtraLegs;
    settingsX01.setMode = defaultSettingsX01.mode;
    settingsX01.setModeIn = defaultSettingsX01.modeIn;
    settingsX01.setModeOut = defaultSettingsX01.modeOut;
    settingsX01.setPoints = defaultSettingsX01.points;
    settingsX01.setCustomPoints = defaultSettingsX01.customPoints;
    settingsX01.setSets = defaultSettingsX01.sets;
    settingsX01.setSetsEnabled = defaultSettingsX01.setsEnabled;
    settingsX01.setShowAverage = defaultSettingsX01.showAverage;
    settingsX01.setShowFinishWays = defaultSettingsX01.showFinishWays;
    settingsX01.setShowInputMethodInGameScreen =
        defaultSettingsX01.showInputMethodInGameScreen;
    settingsX01.setShowLastThrow = defaultSettingsX01.showLastThrow;
    settingsX01.setShowMostScoredPoints =
        defaultSettingsX01.showMostScoredPoints;
    settingsX01.setShowThrownDartsPerLeg =
        defaultSettingsX01.showThrownDartsPerLeg;
    settingsX01.setSingleOrTeam = defaultSettingsX01.singleOrTeam;
    settingsX01.setSuddenDeath = defaultSettingsX01.suddenDeath;
    settingsX01.setVibrationFeedbackEnabled =
        defaultSettingsX01.vibrationFeedbackEnabled;
    settingsX01.setWinByTwoLegsDifference =
        defaultSettingsX01.winByTwoLegsDifference;
    settingsX01.setDrawMode = defaultSettingsX01.drawMode;
    settingsX01.setPlayers = defaultSettingsX01.players;
    //teams not supported for favourites
    settingsX01.setTeamNamingIds = [];
    settingsX01.setTeams = [];
  }

  static bool defaultSettingsSelected(BuildContext context) {
    final defaultSettingsX01 =
        Provider.of<DefaultSettingsX01>(context, listen: false);
    final settingsX01 = Provider.of<GameSettingsX01>(context, listen: false);

    if (defaultSettingsX01.automaticallySubmitPoints ==
            settingsX01.getAutomaticallySubmitPoints &&
        defaultSettingsX01.callerEnabled == settingsX01.getCallerEnabled &&
        defaultSettingsX01.checkoutCountingFinallyDisabled ==
            settingsX01.getCheckoutCountingFinallyDisabled &&
        defaultSettingsX01.customPoints == settingsX01.getCustomPoints &&
        defaultSettingsX01.enableCheckoutCounting ==
            settingsX01.getEnableCheckoutCounting &&
        defaultSettingsX01.inputMethod == settingsX01.getInputMethod &&
        defaultSettingsX01.legs == settingsX01.getLegs &&
        defaultSettingsX01.maxExtraLegs == settingsX01.getMaxExtraLegs &&
        defaultSettingsX01.mode == settingsX01.getMode &&
        defaultSettingsX01.modeIn == settingsX01.getModeIn &&
        defaultSettingsX01.modeOut == settingsX01.getModeOut &&
        defaultSettingsX01.points == settingsX01.getPoints &&
        defaultSettingsX01.sets == settingsX01.getSets &&
        defaultSettingsX01.setsEnabled == settingsX01.getSetsEnabled &&
        defaultSettingsX01.showAverage == settingsX01.getShowAverage &&
        defaultSettingsX01.showFinishWays == settingsX01.getShowFinishWays &&
        defaultSettingsX01.showInputMethodInGameScreen ==
            settingsX01.getShowInputMethodInGameScreen &&
        defaultSettingsX01.showLastThrow == settingsX01.getShowLastThrow &&
        defaultSettingsX01.showMostScoredPoints ==
            settingsX01.getShowMostScoredPoints &&
        defaultSettingsX01.showThrownDartsPerLeg ==
            settingsX01.getShowThrownDartsPerLeg &&
        defaultSettingsX01.singleOrTeam == settingsX01.getSingleOrTeam &&
        defaultSettingsX01.suddenDeath == settingsX01.getSuddenDeath &&
        defaultSettingsX01.vibrationFeedbackEnabled ==
            settingsX01.getVibrationFeedbackEnabled &&
        defaultSettingsX01.winByTwoLegsDifference ==
            settingsX01.getWinByTwoLegsDifference &&
        defaultSettingsX01.drawMode == settingsX01.getDrawMode &&
        defaultSettingsX01.samePlayers(settingsX01.getPlayers, context)) {
      return true;
    }

    return false;
  }

  static bool generalDefaultSettingsSelected(BuildContext context) {
    final settingsX01 = Provider.of<GameSettingsX01>(context, listen: false);

    if (settingsX01.getAutomaticallySubmitPoints == DEFAULT_AUTO_SUBMIT_POINTS &&
        settingsX01.getCallerEnabled == DEFAULT_CALLER_ENABLED &&
        settingsX01.getCheckoutCountingFinallyDisabled ==
            DEFAULT_CHECKOUT_COUNTING_FINALLY_DISABLED &&
        settingsX01.getCustomPoints == DEFAULT_CUSTOM_POINTS &&
        settingsX01.getEnableCheckoutCounting ==
            DEFAULT_ENABLE_CHECKOUT_COUNTING &&
        settingsX01.getInputMethod == DEFAULT_INPUT_METHOD &&
        settingsX01.getLegs == DEFAULT_LEGS &&
        settingsX01.getMaxExtraLegs == DEFAULT_MAX_EXTRA_LEGS &&
        settingsX01.getMode == DEFAULT_MODE &&
        settingsX01.getModeIn == DEFAULT_MODE_IN &&
        settingsX01.getModeOut == DEFAULT_MODE_OUT &&
        settingsX01.getPoints == DEFAULT_POINTS &&
        settingsX01.getSets == DEFAULT_SETS &&
        settingsX01.getSetsEnabled == DEFAULT_SETS_ENABLED &&
        settingsX01.getShowAverage == DEFAULT_SHOW_AVG &&
        settingsX01.getShowFinishWays == DEFAULT_SHOW_FINISH_WAYS &&
        settingsX01.getShowInputMethodInGameScreen ==
            DEFAULT_SHOW_INPUT_METHOD_IN_GAME_SCREEN &&
        settingsX01.getShowLastThrow == DEFAULT_SHOW_LAST_THROW &&
        settingsX01.getShowMostScoredPoints ==
            DEFAULT_SHOW_MOST_SCORED_POINTS &&
        settingsX01.getShowThrownDartsPerLeg ==
            DEFAULT_SHOW_THROWN_DARTS_PER_LEG &&
        settingsX01.getSingleOrTeam == DEFAULT_SINGLE_OR_TEAM &&
        settingsX01.getSuddenDeath == DEFAULT_SUDDEN_DEATH &&
        settingsX01.getVibrationFeedbackEnabled == DEFAULT_VIBRATION_FEEDBACK &&
        settingsX01.getWinByTwoLegsDifference ==
            DEFAULT_WIN_BY_TWO_LEGS_DIFFERENCE &&
        settingsX01.getPlayers.length == 0 &&
        settingsX01.getDrawMode == DEFAULT_DRAW_MODE) {
      return true;
    }

    return false;
  }
}
