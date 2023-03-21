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

disposeControllersForAuth() {
  usernameTextController.dispose();
  emailTextController.dispose();
  passwordTextController.dispose();
}

// GAMESETTINGS X01
ScrollController scrollControllerPlayers = new ScrollController();
ScrollController scrollControllerTeams = new ScrollController();

TextEditingController newPlayerController = new TextEditingController();
TextEditingController editPlayerController = new TextEditingController();
TextEditingController newTeamController = new TextEditingController();
TextEditingController editTeamController = new TextEditingController();
TextEditingController customPointsController = new TextEditingController();
TextEditingController mostScoredPointController = new TextEditingController();

newScrollControllerPlayers() {
  scrollControllerPlayers = new ScrollController();
  return scrollControllerPlayers;
}

ScrollController newScrollControllerTeams() {
  scrollControllerTeams = new ScrollController();
  return scrollControllerTeams;
}

TextEditingController newTextControllerForAddingNewPlayerInGameSettingsX01() {
  newPlayerController = new TextEditingController();
  return newPlayerController;
}

TextEditingController newTextControllerForEditingPlayerInGameSettingsX01() {
  editPlayerController = new TextEditingController();
  return editPlayerController;
}

TextEditingController newTextControllerForAddingNewTeamInGameSettingsX01() {
  newTeamController = new TextEditingController();
  return newTeamController;
}

TextEditingController newTextControllerForEditingTeamInGameSettingsX01() {
  editTeamController = new TextEditingController();
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

disposeControllersForGamesettingsX01() {
  scrollControllerPlayers.dispose();
  scrollControllerTeams.dispose();

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

// maybe not best solution
// needed for input method three darts + don't auto submit points
int g_thrownDarts = 0;
int g_checkoutCount = 0;

// for favouriteGames saving
String g_gameId = '';

// for bug with bot -> to proper show it on the ui
String g_average = '-';
String g_last_throw = '-';
String g_thrown_darts = '-';
