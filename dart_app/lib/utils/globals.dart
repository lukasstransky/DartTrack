library dartApp.globals;

import 'package:dart_app/constants.dart';
import 'package:flutter/material.dart';

ScrollController scrollControllerScoreTrainingPlayerEntries =
    new ScrollController();
ScrollController scrollControllerSingleDoubleTrainingPlayerEntries =
    new ScrollController();

ScrollController newScrollControllerScoreTrainingPlayerEntries() {
  scrollControllerScoreTrainingPlayerEntries = new ScrollController();
  return scrollControllerScoreTrainingPlayerEntries;
}

ScrollController newScrollControllerSingleDoubleTrainingPlayerEntries() {
  scrollControllerSingleDoubleTrainingPlayerEntries = new ScrollController();
  return scrollControllerSingleDoubleTrainingPlayerEntries;
}

// AUTH
TextEditingController usernameTextController = new TextEditingController();
TextEditingController emailTextController = new TextEditingController();
TextEditingController passwordTextController = new TextEditingController();

TextEditingController newTextControllerForUsername() {
  usernameTextController = new TextEditingController();
  return usernameTextController;
}

TextEditingController newTextControllerForEmail() {
  emailTextController = new TextEditingController();
  return emailTextController;
}

TextEditingController newTextControllerForPassword() {
  passwordTextController = new TextEditingController();
  return passwordTextController;
}

// GAMESETTINGS X01
TextEditingController newPlayerController = new TextEditingController();
TextEditingController editPlayerController = new TextEditingController();
TextEditingController newTeamController = new TextEditingController();
TextEditingController editTeamController = new TextEditingController();
TextEditingController customPointsController = new TextEditingController();
TextEditingController mostScoredPointController = new TextEditingController();

TextEditingController newTextControllerForAddingNewPlayerInGameSettingsX01() {
  newPlayerController = new TextEditingController();
  return newPlayerController;
}

TextEditingController newTextControllerForEditingPlayerInGameSettingsX01(
    String playerName) {
  editPlayerController = new TextEditingController();
  editPlayerController.text = playerName;
  editPlayerController.selection = TextSelection.fromPosition(
      TextPosition(offset: editPlayerController.text.length));

  return editPlayerController;
}

TextEditingController newTextControllerForAddingNewTeamInGameSettingsX01() {
  newTeamController = new TextEditingController();
  return newTeamController;
}

TextEditingController newTextControllerForEditingTeamInGameSettingsX01(
    String teamName) {
  editTeamController = new TextEditingController();
  editTeamController.text = teamName;
  editTeamController.selection = TextSelection.fromPosition(
      TextPosition(offset: editTeamController.text.length));

  return editTeamController;
}

TextEditingController newTextControllerForCustomPointsGameSettingsX01(
    String text) {
  customPointsController = new TextEditingController(text: text);
  return customPointsController;
}

TextEditingController newTextControllerForMostScoredPointGameSettingsX01(
    String text) {
  mostScoredPointController = new TextEditingController(text: text);
  return mostScoredPointController;
}

initControllersForGamesettingsX01() {
  newPlayerController = new TextEditingController();
  editPlayerController = new TextEditingController();
  newTeamController = new TextEditingController();
  editTeamController = new TextEditingController();
  customPointsController = new TextEditingController();
}

disposeControllersForGamesettingsX01() {
  newPlayerController.dispose();
  editPlayerController.dispose();
  newTeamController.dispose();
  editTeamController.dispose();
  customPointsController.dispose();
}

// GAMESETTINGS SCORE TRAINING
TextEditingController maxRoundsOrPointsTextController =
    new TextEditingController(text: DEFAULT_ROUNDS_SCORE_TRAINING.toString());

TextEditingController newTextControllerMaxRoundsOrPointsGameSettingsSct(
    String text) {
  maxRoundsOrPointsTextController = new TextEditingController(text: text);
  return maxRoundsOrPointsTextController;
}

disposeControllersForGamesettingsScoreTraining() {
  maxRoundsOrPointsTextController.dispose();
}

// SINGLE DOUBLE TRAINING
TextEditingController targetNumberTextController =
    new TextEditingController(text: DEFAULT_TARGET_NUMBER.toString());
TextEditingController amountOfRoundsController = new TextEditingController(
    text: DEFUALT_ROUNDS_FOR_TARGET_NUMBER.toString());

TextEditingController newTextControllerTargetNumberGameSettingsSdt() {
  targetNumberTextController =
      new TextEditingController(text: DEFAULT_TARGET_NUMBER.toString());
  return targetNumberTextController;
}

TextEditingController newTextControllerAmountOfRoundsGameSettingsSdt() {
  amountOfRoundsController =
      new TextEditingController(text: DEFAULT_TARGET_NUMBER.toString());
  return amountOfRoundsController;
}

disposeControllersForGamesettingsSingleDoubleTraining() {
  targetNumberTextController.dispose();
  amountOfRoundsController.dispose();
}

// !!!maybe not best solution!!!
// needed for input method three darts + don't auto submit points
int g_thrownDarts = 0;
int g_checkoutCount = 0;

// for favouriteGames saving + deleting (undo last throw btn)
String g_gameId = '';

// for bug with bot -> to proper show it on the ui
String g_average = '-';
String g_last_throw = '-';
String g_thrown_darts = '-';

int counter = 0;

// for not showing loading spinner when deleting a game
bool gameDeleted = false;
