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

//In Game Settings
const int HEIGHT_IN_GAME_SETTINGS_WIDGETS = 4;
const int FONTSIZE_IN_GAME_SETTINGS = 13;
const int FONTSIZE_HEADINGS_IN_GAME_SETTINGS = 18;
enum InputMethod { Round, ThreeDarts }

//Statistics
const int FONTSIZE_HEADING_STATISTICS = 18;
const int FONTSIZE_STATISTICS = 13;
const int WIDTH_HEADINGS_STATISTICS = 40;
const int WIDTH_DATA_STATISTICS = 30;
const double PADDING_TOP_STATISTICS = 10.0;

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
//needed for checkout counting -> if player finishes with an only three dart finish -> dont show dialog
//these checkouts are possible with 3 darts & additionally with 2 darts (cause of bull)
const List<int> threeDartFinishesWithBull = [110, 107, 104, 101];

const Map<int, List<String>> finishWays = {
  170: ["T20 T20 BULL"],
  167: ["T20 T19 BULL"],
  164: ["T20 T18 BULL", "T19 T19 BULL"],
  161: ["T20 T17 BULL", "T19 T18 BULL"],
  160: ["T20 T20 D20"],
  158: ["T20 T20 D20"],
  157: ["T20 T19 D20"],
  156: ["T20 T20 D18"],
  155: ["T20 T19 D19"],
  154: ["T20 T18 D20", "T19 T19 D20"],
  153: ["T20 T19 D18"],
  152: ["T20 T20 D16", "T19 T18 D19"],
  151: ["T20 T17 D20", "T19 T18 D20"],
  150: ["T20 T18 D18", "T19 T19 D18"],
  149: ["T20 T19 D16"],
  148: ["T20 T16 D20", "T18 T18 D20"],
  147: ["T20 T17 D18", "T19 T18 D18"],
  146: ["T19 T19 D16", "T20 T18 D16", "BULL T20 D18"],
  145: ["T19 T20 D14", "T20 T15 D20	", "T18 T17 D20"],
  144: ["T20 T20 D12", "T19 T17 D18	"],
  143: ["T20 T17 D16", "T19 T18 D16"],
  142: ["T18 T20 D14", "T17 T17 D20", "T17 T17 D20"],
  141: ["T20 T19 D12", "T19 T16 D18	", "T18 T17 D18"],
  140: ["T20 T20 D10", "T18 T18 D16"],
  139: ["T19 T14 D20", "BULL T19 D16", "T20 T13 D20"],
  138: ["T20 T18 D12", "T19 T19 D12	", "T18 T16 D18"],
  137: ["T20 T15 D16", "T19 T16 D16", "T18 T17 D16"],
  136: ["T20 T20 D8", "T16 T16 D20", "T18 T18 D14"],
  135: ["BULL T15 D20", "T20 T17 D12"],
  134: ["T20 T14 D16", "T18 T16 D16"],
  133: ["T20 T11 D20", "T20 T19 D8"],
  132: ["BULL T14 D20", "T18 T18 D12", "T20 T16 D12"],
  131: ["T20 T13 D16", "T17 T16 D16"],
  130: ["T20 T20 D5", "T20 T10 D20"],
  129: ["T19 T16 D12", "D19 T17 D20"],
  128: ["T18 T14 D16", "T18 T18 D10"],
  127: ["T20 T17 D8"],
  126: ["T19 T19 D6", "T16 T18 D12"],
  125: ["BULL T17 D12", "T15 T16 D16"],
  124: ["T20 T16 D8"],
  123: ["T19 T16 D9", "BULL T19 D8", "T16 T17 D12"],
  122: ["T18 T18 D7", "T15 T15 D16", "BULL T16 D12"],
  121: ["T20 T11 D14", "T17 T20 D5", "BULL T13 D16"],
  120: ["T20 S20 D20"],
  119: ["T19 T12 D13"],
  118: ["T20 S18 D20"],
  117: ["T20 S17 D20"],
  116: ["T20 S16 D20", "T19 S19 D20"],
  115: ["T20 S15 D20", "T19 S18 D20"],
  114: ["T20 S14 D20"],
  113: ["T19 S16 D20"],
  112: ["T20 S12 D20"],
  111: ["T20 S11 D20", "T19 S14 D20"],
  110: ["T20 S10 D20"],
  109: ["T20 S9 D20", "T19 S20 D16"],
  108: ["T20 S16 D16", "T18 S14 D20"],
  107: ["T19 S18 D16"],
  106: ["T20 S14 D16"],
  105: ["T20 S13 D16"],
  104: ["T18 S18 D16", "T19 S15 D16"],
  103: ["T19 S14 D16"],
  102: ["T20 S10 D16"],
  101: ["T20 S9 D16"],
  100: ["T20 D20"],
  99: ["T19 S10 D16"],
  98: ["T20 D19"],
  97: ["T19 D20"],
  96: ["T20 D18"],
  95: ["T19 D19"],
  94: ["T18 D20"],
  93: ["T19 D18"],
  92: ["T20 D16"],
  91: ["T17 D20"],
  90: ["T20 D15"],
  89: ["T19 D16"],
  88: ["T20 D14"],
  87: ["T17 D18"],
  86: ["T18 D16"],
  85: ["T15 D20"],
  84: ["T20 D12", "T16 D18"],
  83: ["T17 D16"],
  82: ["T14 D20", "T18 D14", "BULL D16"],
  81: ["T19 D12", "T15 D18"],
  80: ["T20 D10"],
  79: ["T19 D11"],
  78: ["T18 D12"],
  77: ["T19 D10"],
  76: ["T20 D8"],
  75: ["T17 D12"],
  74: ["T14 D16"],
  73: ["T17 D11", "T19 D8"],
  72: ["T16 D12"],
  71: ["T13 D16"],
  70: ["T18 D8"],
  69: ["T15 D12"],
  68: ["T20 D4"],
  67: ["T17 D8"],
  66: ["T10 D18", "T18 D6"],
  65: ["T11 D16", "S25 D20"],
  64: ["T16 D8", "T8 D20"],
  63: ["T13 D12"],
  62: ["T10 D16"],
  61: ["T15 D8"],
  60: ["S20 D20"],
  59: ["S19 D20"],
  58: ["S18 D20"],
  57: ["S17 D20"],
  56: ["S16 D20"],
  55: ["S15 D20"],
  54: ["S14 D20"],
  53: ["S13 D20"],
  52: ["S20 D16", "S12 D20"],
  51: ["S19 D16 ", "S11 D20"],
  50: ["S18 D16", "S10 D20"],
  49: ["S17 D16", "S9 D20"],
  48: ["S16 D16", "S8 D20"],
  47: ["S15 D16", "S7 D20"],
  46: ["S14 D16", "S6 D20", "S10 D18"],
  45: ["S13 D16", "S5 D20"],
  44: ["S12 D16", "S4 D20"],
  43: ["S11 D16", "S3 D20"],
  42: ["S10 D16", "S2 D20"],
  41: ["S9 D16", "S1 D20"],
  40: ["D20"],
  39: ["S7 D16", "S19 D10"],
  38: ["D19", "S6 D16", "S10 D14"],
  37: ["S5 D16"],
  36: ["D18"],
  35: ["S3 D16"],
  34: ["D17"],
  33: ["S1 D16", "S17 D8"],
  32: ["D16"],
  31: ["S15 D8", "S19 D6"],
  30: ["D15"],
  29: ["S13 D8"],
  28: ["D14"],
  27: ["S11 D8", "S7 D10"],
  26: ["D13"],
  25: ["S9 D8"],
  24: ["D12"],
  23: ["S7 D8"],
  22: ["D11"],
  21: ["S5 D8", "S13 D4"],
  20: ["D10"],
  19: ["S3 D8", "S11 D4"],
  18: ["D9"],
  17: ["S1 D8", "S9 D4"],
  16: ["D8"],
  15: ["S7 D4"],
  14: ["D7", ""],
  13: ["S5 D4"],
  12: ["D6"],
  11: ["S3 D4"],
  10: ["D5", "S2 D4"],
  9: ["S1 D4"],
  8: ["D4"],
  7: ["S3 D2"],
  6: ["D3", "S2 D2"],
  5: ["S1 D2"],
  4: ["D2"],
  3: ["S1 D1"],
  2: ["D1"]
};
