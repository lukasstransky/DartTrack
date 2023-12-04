library dartApp.globals;

import 'package:flutter/material.dart';

// GAMESETTINGS X01
TextEditingController newPlayerController = new TextEditingController();
TextEditingController editPlayerController = new TextEditingController();
TextEditingController newTeamController = new TextEditingController();
TextEditingController editTeamController = new TextEditingController();
TextEditingController customPointsController = new TextEditingController();
TextEditingController mostScoredPointController = new TextEditingController();

// GAMESETTINGS SCORE TRAINING
TextEditingController maxRoundsOrPointsTextController =
    new TextEditingController();

// SINGLE DOUBLE TRAINING
TextEditingController targetNumberTextController = new TextEditingController();
TextEditingController amountOfRoundsController = new TextEditingController();

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
