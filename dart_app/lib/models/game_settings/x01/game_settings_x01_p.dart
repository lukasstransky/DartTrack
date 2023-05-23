import 'package:dart_app/constants.dart';
import 'package:dart_app/models/bot.dart';
import 'package:dart_app/models/game_settings/game_settings_p.dart';
import 'package:dart_app/models/player.dart';
import 'package:dart_app/models/team.dart';

class GameSettingsX01_P extends GameSettings_P {
  SingleOrTeamEnum _singleOrTeam = DEFAULT_SINGLE_OR_TEAM;
  BestOfOrFirstToEnum _bestOfOrFirstTo = DEFAULT_MODE;
  int _points = DEFAULT_POINTS;
  int _customPoints = DEFAULT_CUSTOM_POINTS;
  int _legs = DEFAULT_LEGS;
  int _sets = DEFAULT_SETS;
  bool _setsEnabled = DEFAULT_SETS_ENABLED;
  ModeOutIn _modeIn = DEFAULT_MODE_IN;
  ModeOutIn _modeOut = DEFAULT_MODE_OUT;
  bool _winByTwoLegsDifference = DEFAULT_WIN_BY_TWO_LEGS_DIFFERENCE;
  bool _suddenDeath = DEFAULT_SUDDEN_DEATH;
  int _maxExtraLegs = DEFAULT_MAX_EXTRA_LEGS;
  bool _enableCheckoutCounting = DEFAULT_ENABLE_CHECKOUT_COUNTING;
  bool _checkoutCountingFinallyDisabled =
      DEFAULT_CHECKOUT_COUNTING_FINALLY_DISABLED; //if user disables checkout counting in the in game settings -> cant be reversed (cause of inconsistent stats then)
  bool _showAverage = DEFAULT_SHOW_AVG;
  bool _showFinishWays = DEFAULT_SHOW_FINISH_WAYS;
  bool _showThrownDartsPerLeg = DEFAULT_SHOW_THROWN_DARTS_PER_LEG;
  bool _showLastThrow = DEFAULT_SHOW_LAST_THROW;
  bool _vibrationFeedbackEnabled = DEFAULT_VIBRATION_FEEDBACK;
  bool _automaticallySubmitPoints = DEFAULT_AUTO_SUBMIT_POINTS;
  bool _showMostScoredPoints = DEFAULT_SHOW_MOST_SCORED_POINTS;
  List<String> _mostScoredPoints = <String>[];
  InputMethod _inputMethod = DEFAULT_INPUT_METHOD;
  bool _showInputMethodInGameScreen = DEFAULT_SHOW_INPUT_METHOD_IN_GAME_SCREEN;
  bool _drawMode = DEFAULT_DRAW_MODE;

  GameSettingsX01_P();

  GameSettingsX01_P.firestore({
    required bool checkoutCounting,
    required int legs,
    required int sets,
    required ModeOutIn modeIn,
    required ModeOutIn modeOut,
    required BestOfOrFirstToEnum mode,
    required int points,
    required SingleOrTeamEnum singleOrTeam,
    required bool winByTwoLegsDifference,
    required bool suddenDeath,
    required int maxExtraLegs,
    required bool drawMode,
    required bool setsEnabled,
    required InputMethod inputMethod,
    required bool showAverage,
    required bool showFinishWays,
    required bool showLastThrow,
    required bool showThrownDartsPerLeg,
    required bool vibrationFeedbackEnabled,
    required bool showInputMethodInGameScreen,
    required bool showMostScoredPoints,
    required List<String> mostScoredPoints,
    required bool automaticallySubmitPoints,
    required bool checkoutCountingFinallyDisabled,
    List<Player>? players,
    List<Team>? teams,
  }) {
    _enableCheckoutCounting = checkoutCounting;
    _legs = legs;
    _sets = sets;
    _modeIn = modeIn;
    _modeOut = modeOut;
    _bestOfOrFirstTo = mode;
    _points = points;
    _singleOrTeam = singleOrTeam;
    _winByTwoLegsDifference = winByTwoLegsDifference;
    _suddenDeath = suddenDeath;
    _maxExtraLegs = maxExtraLegs;
    _drawMode = drawMode;
    _setsEnabled = setsEnabled;
    _showAverage = showAverage;
    _showFinishWays = showFinishWays;
    _showLastThrow = showLastThrow;
    _showThrownDartsPerLeg = showThrownDartsPerLeg;
    _vibrationFeedbackEnabled = vibrationFeedbackEnabled;
    _showInputMethodInGameScreen = showInputMethodInGameScreen;
    _showMostScoredPoints = showMostScoredPoints;
    _mostScoredPoints = mostScoredPoints;
    _automaticallySubmitPoints = automaticallySubmitPoints;
    _checkoutCountingFinallyDisabled = checkoutCountingFinallyDisabled;
    _inputMethod = inputMethod;

    if (players != null) {
      setPlayers = players;
    }
    if (teams != null) {
      setTeams = teams;
    }
  }

  SingleOrTeamEnum get getSingleOrTeam => _singleOrTeam;
  set setSingleOrTeam(SingleOrTeamEnum _singleOrTeam) =>
      this._singleOrTeam = _singleOrTeam;

  BestOfOrFirstToEnum get getBestOfOrFirstTo => _bestOfOrFirstTo;
  set setBestOfOrFirstTo(BestOfOrFirstToEnum bestOfOrFirstTo) =>
      _bestOfOrFirstTo = bestOfOrFirstTo;

  int get getPoints => _points;
  set setPoints(int points) => {
        _points = points,
        _customPoints = -1,
      };

  int get getCustomPoints => _customPoints;
  set setCustomPoints(int customPoints) => _customPoints = customPoints;

  int get getLegs => _legs;
  set setLegs(int legs) => _legs = legs;

  int get getSets => _sets;
  set setSets(int sets) => _sets = sets;

  bool get getSetsEnabled => _setsEnabled;
  set setSetsEnabled(bool setsEnabled) => _setsEnabled = setsEnabled;

  ModeOutIn get getModeIn => _modeIn;
  set setModeIn(ModeOutIn modeIn) => _modeIn = modeIn;

  ModeOutIn get getModeOut => _modeOut;
  set setModeOut(ModeOutIn modeOut) => _modeOut = modeOut;

  bool get getWinByTwoLegsDifference => _winByTwoLegsDifference;
  set setWinByTwoLegsDifference(bool winByTwoLegsDifference) =>
      _winByTwoLegsDifference = winByTwoLegsDifference;

  bool get getSuddenDeath => _suddenDeath;
  set setSuddenDeath(bool suddenDeath) => _suddenDeath = suddenDeath;

  int get getMaxExtraLegs => _maxExtraLegs;
  set setMaxExtraLegs(int maxLegDifference) => _maxExtraLegs = maxLegDifference;

  bool get getEnableCheckoutCounting => _enableCheckoutCounting;
  set setEnableCheckoutCounting(bool enableCheckoutCounting) =>
      _enableCheckoutCounting = enableCheckoutCounting;

  bool get getCheckoutCountingFinallyDisabled =>
      _checkoutCountingFinallyDisabled;
  set setCheckoutCountingFinallyDisabled(
          bool checkoutCountingFinallyDisabled) =>
      _checkoutCountingFinallyDisabled = checkoutCountingFinallyDisabled;

  bool get getShowAverage => _showAverage;
  set setShowAverage(bool showAverage) => _showAverage = showAverage;

  bool get getShowFinishWays => _showFinishWays;
  set setShowFinishWays(bool showFinishWays) =>
      _showFinishWays = showFinishWays;

  bool get getShowThrownDartsPerLeg => _showThrownDartsPerLeg;
  set setShowThrownDartsPerLeg(bool showThrownDartsPerLeg) =>
      _showThrownDartsPerLeg = showThrownDartsPerLeg;

  bool get getShowLastThrow => _showLastThrow;
  set setShowLastThrow(bool showLastThrow) => _showLastThrow = showLastThrow;

  bool get getVibrationFeedbackEnabled => _vibrationFeedbackEnabled;
  set setVibrationFeedbackEnabled(bool vibrationFeedbackEnabled) =>
      _vibrationFeedbackEnabled = vibrationFeedbackEnabled;

  bool get getAutomaticallySubmitPoints => _automaticallySubmitPoints;
  set setAutomaticallySubmitPoints(bool automaticallySubmitPoints) =>
      _automaticallySubmitPoints = automaticallySubmitPoints;

  bool get getShowMostScoredPoints => _showMostScoredPoints;
  set setShowMostScoredPoints(bool showMostScoredPoints) =>
      _showMostScoredPoints = showMostScoredPoints;

  List<String> get getMostScoredPoints => _mostScoredPoints;
  set setMostScoredPoints(List<String> value) => _mostScoredPoints = value;

  InputMethod get getInputMethod => _inputMethod;
  set setInputMethod(InputMethod inputMethod) => _inputMethod = inputMethod;

  bool get getShowInputMethodInGameScreen => _showInputMethodInGameScreen;
  set setShowInputMethodInGameScreen(bool showInputMethodInGameScreen) {
    _showInputMethodInGameScreen = showInputMethodInGameScreen;
  }

  bool get getDrawMode => _drawMode;
  set setDrawMode(bool value) => _drawMode = value;

  @override
  void notify() {
    notifyListeners();
  }

  int getPointsOrCustom() {
    if (getCustomPoints != -1) {
      return getCustomPoints;
    }

    return getPoints;
  }

  int getCountOfBotPlayers() {
    int count = 0;
    for (Player player in getPlayers) {
      if (player is Bot) {
        count++;
      }
    }

    return count;
  }

  String getGameModeDetails(bool showPoints) {
    String result = '';

    if (showPoints) {
      if (getCustomPoints != -1) {
        result += '${getCustomPoints.toString()} - ';
      } else {
        result += '${getPoints.toString()} - ';
      }
    }

    switch (getModeIn) {
      case ModeOutIn.Single:
        result += 'Single in - ';
        break;
      case ModeOutIn.Double:
        result += 'Double in - ';
        break;
      case ModeOutIn.Master:
        result += 'Master in - ';
        break;
    }

    switch (getModeOut) {
      case ModeOutIn.Single:
        result += 'Single out';
        break;
      case ModeOutIn.Double:
        result += 'Double out';
        break;
      case ModeOutIn.Master:
        result += 'Master out';
        break;
    }

    return result;
  }

  String getSuddenDeathInfo() {
    return '(Sudden death - after max. ${getMaxExtraLegs.toString()} leg${getMaxExtraLegs > 1 ? 's' : ''})';
  }

  switchSingleOrTeamMode() {
    if (getSingleOrTeam == SingleOrTeamEnum.Single) {
      setSingleOrTeam = SingleOrTeamEnum.Team;
    } else {
      setSingleOrTeam = SingleOrTeamEnum.Single;
    }

    notify();
  }

  switchBestOfOrFirstTo() {
    if (getBestOfOrFirstTo == BestOfOrFirstToEnum.BestOf) {
      setBestOfOrFirstTo = BestOfOrFirstToEnum.FirstTo;

      if (getDrawMode) {
        setDrawMode = false;
      }

      if (getSetsEnabled) {
        setLegs = DEFAULT_LEGS_FIRST_TO_SETS_ENABLED;
        setSets = DEFAULT_SETS_FIRST_TO_SETS_ENABLED;
      } else {
        setLegs = DEFAULT_LEGS_FIRST_TO_NO_SETS;
      }
    } else {
      setBestOfOrFirstTo = BestOfOrFirstToEnum.BestOf;

      if (getSetsEnabled) {
        setSets = DEFAULT_SETS_BEST_OF_SETS_ENABLED;
        setLegs = DEFAULT_LEGS_BEST_OF_SETS_ENABLED;
      } else {
        setLegs = DEFAULT_LEGS_BEST_OF_NO_SETS;
      }
    }

    notify();
  }

  setsBtnClicked() {
    setSetsEnabled = !getSetsEnabled;
    setWinByTwoLegsDifference = false;
    setSuddenDeath = false;
    setMaxExtraLegs = DEFAULT_MAX_EXTRA_LEGS;

    if (getDrawMode) {
      setSets = DEFAULT_SETS_DRAW_MODE;
      setLegs = getSetsEnabled
          ? DEFAULT_LEGS_DRAW_MODE_SETS_ENABLED
          : DEFAULT_LEGS_DRAW_MODE;
    } else {
      if (getBestOfOrFirstTo == BestOfOrFirstToEnum.FirstTo) {
        setSets = DEFAULT_SETS_FIRST_TO_SETS_ENABLED;
        setLegs = getSetsEnabled
            ? DEFAULT_LEGS_FIRST_TO_SETS_ENABLED
            : DEFAULT_LEGS_FIRST_TO_NO_SETS;
      } else {
        setSets = DEFAULT_SETS_BEST_OF_SETS_ENABLED;
        setLegs = getSetsEnabled
            ? setLegs = DEFAULT_LEGS_BEST_OF_SETS_ENABLED
            : setSets = DEFAULT_LEGS_BEST_OF_NO_SETS;
      }
    }

    notify();
  }

  reset() {}
}
