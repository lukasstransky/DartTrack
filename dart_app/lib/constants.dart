import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

const Color primary = Color(0xff130536);

enum GameMode { X01, ScoreTraining, SingleTraining, DoubleTraining, Cricket }

extension NameGetterGameMode on GameMode {
  String get name {
    switch (this) {
      case GameMode.X01:
        return 'X01';
      case GameMode.ScoreTraining:
        return 'Score training';
      case GameMode.SingleTraining:
        return 'Single training';
      case GameMode.DoubleTraining:
        return 'Double training';
      case GameMode.Cricket:
        return 'Cricket';
      default:
        return '';
    }
  }
}

// single training
enum ModesSingleDoubleTraining { Ascending, Descending, Random }

// cricket
enum CricketMode { Standard, CutThroat, NoScore }

extension NameGetterCricketMode on CricketMode {
  String get name {
    switch (this) {
      case CricketMode.Standard:
        return 'Standard';
      case CricketMode.CutThroat:
        return 'Cut throat';
      case CricketMode.NoScore:
        return 'No score';
      default:
        return '';
    }
  }
}

//Auth Page
enum AuthMode { Register, Login }

//Game Settings Page X01
enum SingleOrTeamEnum { Single, Team }

enum SingleOrDouble { SingleField, DoubleField }

enum ModeOutIn { Single, Double, Master }

enum BestOfOrFirstToEnum { BestOf, FirstTo }

enum NewPlayer { Bot, Guest }

const String SUDDEN_DEATH_INFO =
    "If the score is tied after the regular number of legs, a deciding leg is played, called 'Sudden death'. Whoever wins this leg, is the winner of the match.";
const String SUDDEN_DEATH_LEG_DIFFERENCE_INFO =
    "The additional maximum number of legs until the 'Sudden death' leg, is specified here. By default it's 2 legs. (e.g. in case of 'First to 5 legs' the 'Sudden death' leg is played after a score of 7:7).";

const int MAX_PLAYERS_IN_TEAM_FOR_AUTO_ASSIGNING = 2;
const int DEFAULT_BOT_AVG_SLIDER_VALUE = 50;
const int BOT_AVG_SLIDER_VALUE_RANGE = 2;
const int MAX_PLAYERS_X01 = 8;
const int MAX_PLAYERS_CRICKET = 4;
const int MAX_PLAYERS_CRICKET_TEAM_MODE = 8;
const int MAX_PLAYERS_SINGLE_DOUBLE_SCORE_TRAINING = 5;
const int MAX_TEAMS = 4;
const int MAX_PLAYERS_PER_TEAM = 4;
const int MAX_CHARACTERS_NEW_PLAYER_TEXTFIELD = 12;
const int MAX_NUMBERS_POINTS = 4;
const int STANDARD_MAX_EXTRA_LEGS = 2;
const int MIN_LEGS = 1;
const int MIN_LEGS_SETS_ENABLED_FIRST_TO = 2;
const int MIN_LEGS_SETS_ENABLED_BEST_OF = 3;
const int MIN_SETS_BEST_OF = 3;
const int MIN_SETS_FIRST_TO = 2;
const int MAX_LEGS = 31;
const int MIN_SETS = 2;
const int MAX_SETS = 31;
const int MAX_EXTRA_LEGS = 9;
const int CUSTOM_POINTS_MIN_NUMBER = 100;
const int DEFAULT_LEGS_DRAW_MODE = 6;

const int WIDTH_GAMESETTINGS = 80;
const double WIDGET_HEIGHT_GAMESETTINGS = 4;
const double WIDGET_HEIGHT_GAMESETTINGS_TEAMS = 3.5;
const double MARGIN_GAMESETTINGS = 1.0;
const double BUTTON_BORDER_RADIUS = 10.0;

const String FIRST_DEFAULT_MOST_SCORED_POINT = '60';
const String SECOND_DEFAULT_MOST_SCORED_POINT = '26';
const String THIRD_DEFAULT_MOST_SCORED_POINT = '45';
const String FOURTH_DEFAULT_MOST_SCORED_POINT = '7';
const String FIFTH_DEFAULT_MOST_SCORED_POINT = '59';
const String SIXTH_DEFAULT_MOST_SCORED_POINT = '100';

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
const double PADDING_TOP_STATISTICS = 1;
const double PADDING_LEFT_STATISTICS = 5;

//Game Page
const double POINTS_BUTTON_MARGIN = 1.0;
const double ROUND_BUTTON_TEXT_SIZE = 30;
const double THREE_DARTS_BUTTON_TEXT_SIZE = 14;

enum PointType { Single, Double, Tripple }

const List<int> NO_SCORES_POSSIBLE = [
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
const List<int> BOGEY_NUMBERS = [169, 168, 166, 165, 163, 162, 159];
const List<int> DOUBLE_IN_IMPOSSIBLE_SCORES = [
  151,
  153,
  155,
  157,
  159,
  162,
  163,
  165,
  166,
  168,
  169
];
const List<int> START_POINT_POSSIBILITIES = [301, 501, 701];
//needed for checkout counting -> if player finishes with an only three dart finish -> dont show dialog
//these checkouts are possible with 3 darts & additionally with 2 darts (cause of bull)
const List<int> THREE_DART_FINISHES_WITH_BULL = [110, 107, 104, 101];
const Map<int, List<String>> FINISH_WAYS = {
  170: ['T20 T20 BULL'],
  167: ['T20 T19 BULL'],
  164: ['T20 T18 BULL', 'T19 T19 BULL'],
  161: ['T20 T17 BULL', 'T19 T18 BULL'],
  160: ['T20 T20 D20'],
  158: ['T20 T20 D20'],
  157: ['T20 T19 D20'],
  156: ['T20 T20 D18'],
  155: ['T20 T19 D19'],
  154: ['T20 T18 D20', 'T19 T19 D20'],
  153: ['T20 T19 D18'],
  152: ['T20 T20 D16', 'T19 T18 D19'],
  151: ['T20 T17 D20', 'T19 T18 D20'],
  150: ['T20 T18 D18', 'T19 T19 D18'],
  149: ['T20 T19 D16'],
  148: ['T20 T16 D20', 'T18 T18 D20'],
  147: ['T20 T17 D18', 'T19 T18 D18'],
  146: ['T19 T19 D16', 'T20 T18 D16', 'BULL T20 D18'],
  145: ['T19 T20 D14', 'T20 T15 D20	', 'T18 T17 D20'],
  144: ['T20 T20 D12', 'T19 T17 D18	'],
  143: ['T20 T17 D16', 'T19 T18 D16'],
  142: ['T18 T20 D14', 'T17 T17 D20', 'T17 T17 D20'],
  141: ['T20 T19 D12', 'T19 T16 D18	', 'T18 T17 D18'],
  140: ['T20 T20 D10', 'T18 T18 D16'],
  139: ['T19 T14 D20', 'BULL T19 D16', 'T20 T13 D20'],
  138: ['T20 T18 D12', 'T19 T19 D12	', 'T18 T16 D18'],
  137: ['T20 T15 D16', 'T19 T16 D16', 'T18 T17 D16'],
  136: ['T20 T20 D8', 'T16 T16 D20', 'T18 T18 D14'],
  135: ['BULL T15 D20', 'T20 T17 D12'],
  134: ['T20 T14 D16', 'T18 T16 D16'],
  133: ['T20 T11 D20', 'T20 T19 D8'],
  132: ['BULL T14 D20', 'T18 T18 D12', 'T20 T16 D12'],
  131: ['T20 T13 D16', 'T17 T16 D16'],
  130: ['T20 T20 D5', 'T20 T10 D20'],
  129: ['T19 T16 D12', 'D19 T17 D20'],
  128: ['T18 T14 D16', 'T18 T18 D10'],
  127: ['T20 T17 D8'],
  126: ['T19 T19 D6', 'T16 T18 D12'],
  125: ['BULL T17 D12', 'T15 T16 D16'],
  124: ['T20 T16 D8'],
  123: ['T19 T16 D9', 'BULL T19 D8', 'T16 T17 D12'],
  122: ['T18 T18 D7', 'T15 T15 D16', 'BULL T16 D12'],
  121: ['T20 T11 D14', 'T17 T20 D5', 'BULL T13 D16'],
  120: ['T20 S20 D20'],
  119: ['T19 T12 D13'],
  118: ['T20 S18 D20'],
  117: ['T20 S17 D20'],
  116: ['T20 S16 D20', 'T19 S19 D20'],
  115: ['T20 S15 D20', 'T19 S18 D20'],
  114: ['T20 S14 D20'],
  113: ['T19 S16 D20'],
  112: ['T20 S12 D20'],
  111: ['T20 S11 D20', 'T19 S14 D20'],
  110: ['T20 S10 D20'],
  109: ['T20 S9 D20', 'T19 S20 D16'],
  108: ['T20 S16 D16', 'T18 S14 D20'],
  107: ['T19 S18 D16'],
  106: ['T20 S14 D16'],
  105: ['T20 S13 D16'],
  104: ['T18 S18 D16', 'T19 S15 D16'],
  103: ['T19 S14 D16'],
  102: ['T20 S10 D16'],
  101: ['T20 S9 D16'],
  100: ['T20 D20'],
  99: ['T19 S10 D16'],
  98: ['T20 D19'],
  97: ['T19 D20'],
  96: ['T20 D18'],
  95: ['T19 D19'],
  94: ['T18 D20'],
  93: ['T19 D18'],
  92: ['T20 D16'],
  91: ['T17 D20'],
  90: ['T20 D15'],
  89: ['T19 D16'],
  88: ['T20 D14'],
  87: ['T17 D18'],
  86: ['T18 D16'],
  85: ['T15 D20'],
  84: ['T20 D12', 'T16 D18'],
  83: ['T17 D16'],
  82: ['T14 D20', 'T18 D14', 'BULL D16'],
  81: ['T19 D12', 'T15 D18'],
  80: ['T20 D10'],
  79: ['T19 D11'],
  78: ['T18 D12'],
  77: ['T19 D10'],
  76: ['T20 D8'],
  75: ['T17 D12'],
  74: ['T14 D16'],
  73: ['T17 D11', 'T19 D8'],
  72: ['T16 D12'],
  71: ['T13 D16'],
  70: ['T18 D8'],
  69: ['T15 D12'],
  68: ['T20 D4'],
  67: ['T17 D8'],
  66: ['T10 D18', 'T18 D6'],
  65: ['T11 D16', 'S25 D20'],
  64: ['T16 D8', 'T8 D20'],
  63: ['T13 D12'],
  62: ['T10 D16'],
  61: ['T15 D8'],
  60: ['S20 D20'],
  59: ['S19 D20'],
  58: ['S18 D20'],
  57: ['S17 D20'],
  56: ['S16 D20'],
  55: ['S15 D20'],
  54: ['S14 D20'],
  53: ['S13 D20'],
  52: ['S20 D16', 'S12 D20'],
  51: ['S19 D16 ', 'S11 D20'],
  50: ['S18 D16', 'S10 D20'],
  49: ['S17 D16', 'S9 D20'],
  48: ['S16 D16', 'S8 D20'],
  47: ['S15 D16', 'S7 D20'],
  46: ['S14 D16', 'S6 D20', 'S10 D18'],
  45: ['S13 D16', 'S5 D20'],
  44: ['S12 D16', 'S4 D20'],
  43: ['S11 D16', 'S3 D20'],
  42: ['S10 D16', 'S2 D20'],
  41: ['S9 D16', 'S1 D20'],
  40: ['D20'],
  39: ['S7 D16', 'S19 D10'],
  38: ['D19', 'S6 D16', 'S10 D14'],
  37: ['S5 D16'],
  36: ['D18'],
  35: ['S3 D16'],
  34: ['D17'],
  33: ['S1 D16', 'S17 D8'],
  32: ['D16'],
  31: ['S15 D8', 'S19 D6'],
  30: ['D15'],
  29: ['S13 D8'],
  28: ['D14'],
  27: ['S11 D8', 'S7 D10'],
  26: ['D13'],
  25: ['S9 D8'],
  24: ['D12'],
  23: ['S7 D8'],
  22: ['D11'],
  21: ['S5 D8', 'S13 D4'],
  20: ['D10'],
  19: ['S3 D8', 'S11 D4'],
  18: ['D9'],
  17: ['S1 D8', 'S9 D4'],
  16: ['D8'],
  15: ['S7 D4'],
  14: ['D7', ''],
  13: ['S5 D4'],
  12: ['D6'],
  11: ['S3 D4'],
  10: ['D5', 'S2 D4'],
  9: ['S1 D4'],
  8: ['D4'],
  7: ['S3 D2'],
  6: ['D3', 'S2 D2'],
  5: ['S1 D2'],
  4: ['D2'],
  3: ['S1 D1'],
  2: ['D1']
};

//Statistics Page
enum FilterValue { Overall, Month, Year, Custom }

//for avg, best, worst statistics (when clicking on button)
const String BEST_AVG = 'bestAvg';
const String WORST_AVG = 'worstAvg';

const String BEST_FIRST_NINE_AVG = 'bestFirstNineAvg';
const String WORST_FIRST_NINE_AVG = 'worstFirstNineAvg';

const String BEST_CHECKOUT_QUOTE = 'bestQueckoutQuote';
const String WORST_CHECKOUT_QUOTE = 'worstCheckoutQuote';

const String BEST_CHECKOUT_SCORE = 'bestCheckoutScore';
const String WORST_CHECKOUT_SCORE = 'worstCheckoutScore';

const String BEST_DARTS_PER_LEG = 'bestDartsPerLeg';
const String WORST_DARTS_PER_LEG = 'worstDartsPerLeg';

//DEFAULT SETTINGS
const SingleOrTeamEnum DEFAULT_SINGLE_OR_TEAM = SingleOrTeamEnum.Single;
const BestOfOrFirstToEnum DEFAULT_MODE = BestOfOrFirstToEnum.FirstTo;
const int DEFAULT_POINTS = 501;
const int DEFAULT_CUSTOM_POINTS = -1;
const int DEFAULT_LEGS = 3;
const int DEFAULT_SETS = 5;
const bool DEFAULT_SETS_ENABLED = false;
const ModeOutIn DEFAULT_MODE_IN = ModeOutIn.Single;
const ModeOutIn DEFAULT_MODE_OUT = ModeOutIn.Double;
const bool DEFAULT_WIN_BY_TWO_LEGS_DIFFERENCE = false;
const bool DEFAULT_SUDDEN_DEATH = false;
const int DEFAULT_MAX_EXTRA_LEGS = 2;
const bool DEFAULT_ENABLE_CHECKOUT_COUNTING = false;
const bool DEFAULT_CHECKOUT_COUNTING_FINALLY_DISABLED = false;
const bool DEFAULT_SHOW_AVG = true;
const bool DEFAULT_SHOW_FINISH_WAYS = true;
const bool DEFAULT_SHOW_THROWN_DARTS_PER_LEG = true;
const bool DEFAULT_SHOW_LAST_THROW = true;
const bool DEFAULT_VIBRATION_FEEDBACK = false;
const bool DEFAULT_AUTO_SUBMIT_POINTS = false;
const bool DEFAULT_SHOW_MOST_SCORED_POINTS = false;
final mostScoredPoints = <String>[
  FIRST_DEFAULT_MOST_SCORED_POINT,
  SECOND_DEFAULT_MOST_SCORED_POINT,
  THIRD_DEFAULT_MOST_SCORED_POINT,
  FOURTH_DEFAULT_MOST_SCORED_POINT,
  FIFTH_DEFAULT_MOST_SCORED_POINT,
  SIXTH_DEFAULT_MOST_SCORED_POINT
];
List<String> DEFAULT_MOST_SCORED_POINTS =
    List<String>.of([...mostScoredPoints]);
const InputMethod DEFAULT_INPUT_METHOD = InputMethod.Round;
const bool DEFAULT_SHOW_INPUT_METHOD_IN_GAME_SCREEN = true;
const bool DEFAULT_DRAW_MODE = false;

const int DEFAULT_SETS_FIRST_TO_SETS_ENABLED = 3;
const int DEFAULT_LEGS_FIRST_TO_SETS_ENABLED = 2;
const int DEFAULT_SETS_BEST_OF_SETS_ENABLED = 5;
const int DEFAULT_LEGS_BEST_OF_SETS_ENABLED = 3;
const int DEFAULT_LEGS_FIRST_TO_NO_SETS = 3;
const int DEFAULT_LEGS_BEST_OF_NO_SETS = 7;
const int DEFAULT_SETS_DRAW_MODE = 6;
const int DEFAULT_LEGS_DRAW_MODE_SETS_ENABLED = 5;

const int DEFAULT_LIST_TILE_NEGATIVE_MARGIN = -4;

var dialogContentPadding = EdgeInsets.fromLTRB(6.w, 1.h, 6.w, 0);

// Bot class
const int AMOUNT_OF_GENERATED_SCORES = 2;
const int BASE_VALUE_PERCENTAGE_UPPER_LIMIT = 80;
const int BASE_VALUE_PERCENTAGE_LOWER_LIMIT = 70;
const List<int> STARTER_DOUBLES_FOR_FINISH = [16, 20, 24, 32, 36, 40];
const double PROBABILITY_TO_SUBMIT_ZERO_FOR_FINISH_CHANCE = 0.33;

/************************************************************************************/
/*******************          score training settings            ********************/
/************************************************************************************/

enum ScoreTrainingModeEnum { MaxPoints, MaxRounds }

const int MAX_ROUNDS_SCORE_TRAINING = 100;
const int MAX_ROUNDS_SCORE_TRAINING_NUMBERS = 3;
const int MIN_ROUNDS_SCORE_TRAINING = 5;
const int DEFAULT_ROUNDS_SCORE_TRAINING = 20;

const int MAX_POINTS_SCORE_TRAINING = 10000;
const int MAX_POINTS_SCORE_TRAINING_NUMBERS = 5;
const int MIN_POINTS_SCORE_TRAINING = 200;
const int DEFAULT_POINTS_SCORE_TRAINING = 1000;

/************************************************************************************/
/***************          single/double training settings            ****************/
/************************************************************************************/

const int DEFAULT_TARGET_NUMBER = 20;
const int TARGET_NUMBER_MAX_NUMBERS = 2;
const int DEFUALT_ROUNDS_FOR_TARGET_NUMBER = 20;

const int MAX_ROUNDS_SINGLE_TRAINING = 100;
const int MAX_ROUNDS_SINGLE_TRAINING_NUMBERS = 3;
const int MIN_ROUNDS_SINGLE_TRAINING = 5;

const int BTN_FONTSIZE_SD_T = 30;

/************************************************************************************/
/**********************          cricket settings           *************************/
/************************************************************************************/

const SingleOrTeamEnum DEFAULT_SINGLE_OR_TEAM_CRICKET = SingleOrTeamEnum.Single;
const BestOfOrFirstToEnum DEFAULT_BEST_OF_OR_FIRST_TO_CRICKET =
    BestOfOrFirstToEnum.FirstTo;
const CricketMode DEFAULT_CRICKET_MODE = CricketMode.Standard;
const int DEFAULT_SETS_FIRST_TO_SETS_ENABLED_CRICKET = 2;
const int DEFAULT_LEGS_FIRST_TO_SETS_ENABLED_CRICKET = 2;
const int DEFAULT_SETS_BEST_OF_SETS_ENABLED_CRICKET = 3;
const int DEFAULT_LEGS_BEST_OF_SETS_ENABLED_CRICKET = 3;
const int DEFAULT_LEGS_FIRST_TO_NO_SETS_CRICKET = 1;
const int DEFAULT_LEGS_BEST_OF_NO_SETS_CRICKET = 5;
const bool DEFAULT_SETS_ENABLED_CRICKET = false;

/************************************************************************************/
/***********************          styling constants            **********************/
/************************************************************************************/

// general
const int GENERAL_DARKEN = 35;
const double GENERAL_BORDER_WIDTH = 1;
const double PADDING_BOTTOM = 2;
const double DIALOG_SHAPE_ROUNDING = 15;
const double DIALOG_BTN_SHAPE_ROUNDING = 10;

// game modes overview
const int GAME_MODES_OVERVIEW_WIDTH = 60;
const int GAME_MODES_OVERVIEW_HEIGHT = 6;
const int GAME_MODES_OVERVIEW_FONTSIZE = 16;
const int GAME_MODES_OVERVIEW_PADDING = 2;

// game settings
const double GAME_SETTINGS_BTN_BORDER_WITH = 0.5;

/************************************************************************************/
/****************************          shared           *****************************/
/************************************************************************************/
const int THROWN_DARTS_WIDGET_HEIGHT = 6;

const int DEFEAULT_DELAY =
    100; // for async rerquests -> to show loading spinner
