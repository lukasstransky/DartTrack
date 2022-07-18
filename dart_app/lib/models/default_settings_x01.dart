import 'package:dart_app/constants.dart';
import 'package:dart_app/models/player.dart';
import 'package:flutter/cupertino.dart';

class DefaultSettingsX01 with ChangeNotifier {
  String _id = '';
  bool _isSelected = false;

  late List<Player> _players;
  late List<String> _playersNames;
  late List<int> _botNamingIds;
  late SingleOrTeamEnum _singleOrTeam;
  late BestOfOrFirstToEnum _mode;
  late int _points;
  late int _customPoints;
  late int _legs;
  late int _sets;
  late bool _setsEnabled;
  late SingleOrDouble _modeIn;
  late SingleOrDouble _modeOut;
  late bool _winByTwoLegsDifference;
  late bool _suddenDeath;
  late int _maxExtraLegs;
  late bool _enableCheckoutCounting;
  late bool _checkoutCountingFinallyDisabled;
  late bool _showAverage;
  late bool _showFinishWays;
  late bool _showThrownDartsPerLeg;
  late bool _showLastThrow;
  late bool _callerEnabled;
  late bool _vibrationFeedbackEnabled;
  late bool _automaticallySubmitPoints;
  late bool _showMostScoredPoints;
  late InputMethod _inputMethod;
  late bool _showInputMethodInGameScreen;

  DefaultSettingsX01() {
    this.resetValues();
  }

  void fromMap(map) {
    id = map['id'];
    singleOrTeam = map['singleOrTeam'] == 'Single'
        ? SingleOrTeamEnum.Single
        : SingleOrTeamEnum.Team;
    isSelected = map['isSelected'];
    mode = map['mode'] == 'First To'
        ? BestOfOrFirstToEnum.FirstTo
        : BestOfOrFirstToEnum.BestOf;
    points = map['points'];
    customPoints = map['customPoints'];
    legs = map['legs'];
    sets = map['sets'];
    setsEnabled = map['setsEnabled'];
    modeIn = map['modeIn'] == 'Single'
        ? SingleOrDouble.SingleField
        : SingleOrDouble.DoubleField;
    modeOut = map['modeOut'] == 'Single'
        ? SingleOrDouble.SingleField
        : SingleOrDouble.DoubleField;
    winByTwoLegsDifference = map['winByTwoLegsDifference'];
    suddenDeath = map['suddenDeath'];
    maxExtraLegs = map['maxExtraLegs'];
    enableCheckoutCounting = map['enableCheckoutCounting'];
    checkoutCountingFinallyDisabled = map['checkoutCountingFinallyDisabled'];
    showAverage = map['showAverage'];
    showFinishWays = map['showFinishWays'];
    showThrownDartsPerLeg = map['showThrownDartsPerLeg'];
    showLastThrow = map['showLastThrow'];
    callerEnabled = map['callerEnabled'];
    vibrationFeedbackEnabled = map['vibrationFeedbackEnabled'];
    automaticallySubmitPoints = map['automaticallySubmitPoints'];
    showMostScoredPoints = map['showMostScoredPoints'];
    inputMethod = map['inputMethod'] == 'Round'
        ? InputMethod.Round
        : InputMethod.ThreeDarts;
    showInputMethodInGameScreen = map['showInputMethodInGameScreen'];
    players = map['players'] == null
        ? []
        : map['players'].map<Player>((item) {
            return Player.fromMap(item);
          }).toList();
    if (players.isNotEmpty) {
      this.playersNames = [];
      for (Player player in this.players) {
        this.playersNames.add(player.getName);
      }
    }
    botNamingIds =
        map['botNamingIds'] == null ? [] : map['botNamingIds'].cast<int>();
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'isSelected': isSelected,
      'singleOrTeam':
          singleOrTeam == SingleOrTeamEnum.Single ? 'Single' : 'Team',
      'mode': mode == BestOfOrFirstToEnum.FirstTo ? 'First To' : 'Best Of',
      'points': points,
      'customPoints': customPoints,
      'legs': legs,
      'sets': sets,
      'setsEnabled': setsEnabled,
      'modeIn': modeIn == SingleOrDouble.SingleField ? 'Single' : 'Double',
      'modeOut': modeOut == SingleOrDouble.SingleField ? 'Single' : 'Double',
      'winByTwoLegsDifference': winByTwoLegsDifference,
      'suddenDeath': suddenDeath,
      'maxExtraLegs': maxExtraLegs,
      'enableCheckoutCounting': enableCheckoutCounting,
      'checkoutCountingFinallyDisabled': checkoutCountingFinallyDisabled,
      'showAverage': showAverage,
      'showFinishWays': showFinishWays,
      'showThrownDartsPerLeg': showThrownDartsPerLeg,
      'showLastThrow': showLastThrow,
      'callerEnabled': callerEnabled,
      'vibrationFeedbackEnabled': vibrationFeedbackEnabled,
      'automaticallySubmitPoints': automaticallySubmitPoints,
      'showMostScoredPoints': showMostScoredPoints,
      'inputMethod': inputMethod == InputMethod.Round ? 'Round' : 'Three Darts',
      'showInputMethodInGameScreen': showInputMethodInGameScreen,
      if (botNamingIds.isNotEmpty) 'botNamingIds': botNamingIds,
      if (players.isNotEmpty)
        'players': players.map((player) {
          return player.toMap(player);
        }).toList(),
    };
  }

  get id => this._id;

  set id(value) => this._id = value;

  get isSelected => this._isSelected;

  set isSelected(value) => this._isSelected = value;

  List<Player> get players => this._players;

  set players(List<Player> value) => this._players = value;

  List<String> get playersNames => this._playersNames;

  set playersNames(List<String> value) => this._playersNames = value;

  List<int> get botNamingIds => this._botNamingIds;

  set botNamingIds(List<int> value) => this._botNamingIds = value;

  get singleOrTeam => this._singleOrTeam;

  set singleOrTeam(value) => this._singleOrTeam = value;

  get mode => this._mode;

  set mode(value) => this._mode = value;

  get points => this._points;

  set points(value) => this._points = value;

  get customPoints => this._customPoints;

  set customPoints(value) => this._customPoints = value;

  get legs => this._legs;

  set legs(value) => this._legs = value;

  get sets => this._sets;

  set sets(value) => this._sets = value;

  get setsEnabled => this._setsEnabled;

  set setsEnabled(value) => this._setsEnabled = value;

  get modeIn => this._modeIn;

  set modeIn(value) => this._modeIn = value;

  get modeOut => this._modeOut;

  set modeOut(value) => this._modeOut = value;

  get winByTwoLegsDifference => this._winByTwoLegsDifference;

  set winByTwoLegsDifference(value) => this._winByTwoLegsDifference = value;

  get suddenDeath => this._suddenDeath;

  set suddenDeath(value) => this._suddenDeath = value;

  get maxExtraLegs => this._maxExtraLegs;

  set maxExtraLegs(value) => this._maxExtraLegs = value;

  get enableCheckoutCounting => this._enableCheckoutCounting;

  set enableCheckoutCounting(value) => this._enableCheckoutCounting = value;

  get checkoutCountingFinallyDisabled => this._checkoutCountingFinallyDisabled;

  set checkoutCountingFinallyDisabled(value) =>
      this._checkoutCountingFinallyDisabled = value;

  get showAverage => this._showAverage;

  set showAverage(value) => this._showAverage = value;

  get showFinishWays => this._showFinishWays;

  set showFinishWays(value) => this._showFinishWays = value;

  get showThrownDartsPerLeg => this._showThrownDartsPerLeg;

  set showThrownDartsPerLeg(value) => this._showThrownDartsPerLeg = value;

  get showLastThrow => this._showLastThrow;

  set showLastThrow(value) => this._showLastThrow = value;

  get callerEnabled => this._callerEnabled;

  set callerEnabled(value) => this._callerEnabled = value;

  get vibrationFeedbackEnabled => this._vibrationFeedbackEnabled;

  set vibrationFeedbackEnabled(value) => this._vibrationFeedbackEnabled = value;

  get automaticallySubmitPoints => this._automaticallySubmitPoints;

  set automaticallySubmitPoints(value) =>
      this._automaticallySubmitPoints = value;

  get showMostScoredPoints => this._showMostScoredPoints;

  set showMostScoredPoints(value) => this._showMostScoredPoints = value;

  get inputMethod => this._inputMethod;

  set inputMethod(value) => this._inputMethod = value;

  get showInputMethodInGameScreen => this._showInputMethodInGameScreen;

  set showInputMethodInGameScreen(value) =>
      this._showInputMethodInGameScreen = value;

  void resetValues() {
    players = [];
    playersNames = [];
    botNamingIds = [];

    singleOrTeam = DEFAULT_SINGLE_OR_TEAM;
    mode = DEFAULT_MODE;
    points = DEFAULT_POINTS;
    customPoints = DEFAULT_CUSTOM_POINTS;
    legs = DEFAULT_LEGS;
    sets = DEFAULT_SETS;
    setsEnabled = DEFAULT_SETS_ENABLED;
    modeIn = DEFAULT_MODE_IN;
    modeOut = DEFAULT_MODE_OUT;
    winByTwoLegsDifference = DEFAULT_WIN_BY_TWO_LEGS_DIFFERENCE;
    suddenDeath = DEFAULT_SUDDEN_DEATH;
    maxExtraLegs = DEFAULT_MAX_EXTRA_LEGS;
    enableCheckoutCounting = DEFAULT_ENABLE_CHECKOUT_COUNTING;
    checkoutCountingFinallyDisabled =
        DEFAULT_CHECKOUT_COUNTING_FINALLY_DISABLED;
    showAverage = DEFAULT_SHOW_AVG;
    showFinishWays = DEFAULT_SHOW_FINISH_WAYS;
    showThrownDartsPerLeg = DEFAULT_SHOW_THROWN_DARTS_PER_LEG;
    showLastThrow = DEFAULT_SHOW_LAST_THROW;
    callerEnabled = DEFAULT_CALLER_ENABLED;
    vibrationFeedbackEnabled = DEFAULT_VIBRATION_FEEDBACK;
    automaticallySubmitPoints = DEFAULT_AUTO_SUBMIT_POINTS;
    showMostScoredPoints = DEFAULT_SHOW_MOST_SCORED_POINTS;
    inputMethod = DEFAULT_INPUT_METHOD;
    showInputMethodInGameScreen = DEFAULT_SHOW_INPUT_METHOD_IN_GAME_SCREEN;
  }

  bool samePlayers(List<Player> players) {
    int count = 0;
    for (Player player in players) {
      if (this.playersNames.contains(player.getName)) {
        count++;
      }
    }

    if (count == players.length &&
        !(this.playersNames.length > 0 && this.players.length == 0)) {
      return true;
    }
    return false;
  }
}
