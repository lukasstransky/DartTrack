import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

const Color primary = Color(0xff130536);

//Auth Page
enum AuthMode { Signup, Login }

//Game Settings Page
enum SingleOrTeam { Single, Team }
enum SingleOrDouble { SingleField, DoubleField }
enum BestOfOrFirstTo { BestOf, FirstTo }
enum SetsOrLegs { Sets, Legs }
enum NewPlayer { Bot, Guest }

const String SUDDEN_DEATH_INFO =
    "If the score is tied after the regular number of Legs, a deciding Leg is played, called 'Sudden Death'. Whoever wins this Leg, is the winner of the match.";
const String SUDDEN_DEATH_LEG_DIFFERENCE_INFO =
    "The additional maximum number of legs until the 'Sudden Death' Leg, is specified here. By default it's 2 Legs. (e.g. in case of 'First To 5 Legs' the 'Sudden Death' Leg is played after a score of 7:7).";

const double PREDEFINED_BOT_AVERAGE_SLIDER_VALUE = 50;
const int MAX_PLAYERS = 8;
const int MAX_TEAMS = 4;
const int MAX_PLAYERS_PER_TEAM = 4;
const int MAX_CHARACTERS_NEW_PLAYER_TEXTFIELD = 15;
const int MAX_NUMBERS_POINTS = 4;
const int STANDARD_MAX_EXTRA_LEGS = 2;
const int MAX_LEGS = 31;
const int MAX_SETS = 31;
const int MAX_EXTRA_LEGS = 9;
const int POINTS_MIN_NUMBER = 100;

const int WIDTH_GAMESETTINGS = 80;
const int HEIGHT_GAMESETTINGS_WIDGETS = 4;
const double MARGIN_GAMESETTINGS = 1.0;

//Game Page
const double POINTS_BUTTON_MARGIN = 2.0;
const double POINTS_BUTTON_TEXT_SIZE = 30;

const List<int> noScoresPossible = [
  179,
  178,
  176,
  175,
  173,
  172,
  169,
  166,
  163
];
const List<int> bogeyNumbers = [169, 168, 166, 165, 163, 162, 159];
const List<int> startPointsPossibilities = [301, 501, 701];
