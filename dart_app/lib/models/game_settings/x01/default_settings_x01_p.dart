import 'package:dart_app/constants.dart';
import 'package:dart_app/models/player.dart';
import 'package:flutter/cupertino.dart';

class DefaultSettingsX01_P with ChangeNotifier {
  String _id = '';
  bool _isSelected = false;
  bool _loadSettings = true;

  late List<Player> _players;
  late SingleOrTeamEnum _singleOrTeam;
  late BestOfOrFirstToEnum _mode;
  late int _points;
  late int _customPoints;
  late int _legs;
  late int _sets;
  late bool _setsEnabled;
  late ModeOutIn _modeIn;
  late ModeOutIn _modeOut;
  late bool _winByTwoLegsDifference;
  late bool _suddenDeath;
  late int _maxExtraLegs;
  late bool _enableCheckoutCounting;
  late bool _checkoutCountingFinallyDisabled;
  late bool _showAverage;
  late bool _showFinishWays;
  late bool _showThrownDartsPerLeg;
  late bool _showLastThrow;
  late bool _automaticallySubmitPoints;
  late bool _showMostScoredPoints;
  late List<String> _mostScoredPoints;
  late InputMethod _inputMethod;
  late bool _showInputMethodInGameScreen;
  late bool _drawMode;

  DefaultSettingsX01_P() {
    this.resetValues(null);
  }

  fromMap(map) {
    switch (map['modeIn']) {
      case 'Single':
        modeIn = ModeOutIn.Single;
        break;
      case 'Double':
        modeIn = ModeOutIn.Double;
        break;
      case 'Master':
        modeIn = ModeOutIn.Master;
        break;
    }
    switch (map['modeOut']) {
      case 'Single':
        modeOut = ModeOutIn.Single;
        break;
      case 'Double':
        modeOut = ModeOutIn.Double;
        break;
      case 'Master':
        modeOut = ModeOutIn.Master;
        break;
    }

    id = map['id'];
    singleOrTeam = map['singleOrTeam'] == 'Single'
        ? SingleOrTeamEnum.Single
        : SingleOrTeamEnum.Team;
    isSelected = map['isSelected'];
    mode = map['mode'] == 'First to'
        ? BestOfOrFirstToEnum.FirstTo
        : BestOfOrFirstToEnum.BestOf;
    points = map['points'];
    customPoints = map['customPoints'];
    legs = map['legs'];
    sets = map['sets'];
    setsEnabled = map['setsEnabled'];
    winByTwoLegsDifference = map['winByTwoLegsDifference'];
    suddenDeath = map['suddenDeath'];
    maxExtraLegs = map['maxExtraLegs'];
    enableCheckoutCounting = map['enableCheckoutCounting'];
    checkoutCountingFinallyDisabled = map['checkoutCountingFinallyDisabled'];
    showAverage = map['showAverage'];
    showFinishWays = map['showFinishWays'];
    showThrownDartsPerLeg = map['showThrownDartsPerLeg'];
    showLastThrow = map['showLastThrow'];
    automaticallySubmitPoints = map['automaticallySubmitPoints'];
    showMostScoredPoints = map['showMostScoredPoints'];
    mostScoredPoints = map['mostScoredPoints'] == null
        ? []
        : map['mostScoredPoints'].cast<String>();
    inputMethod = map['inputMethod'] == 'Round'
        ? InputMethod.Round
        : InputMethod.ThreeDarts;
    showInputMethodInGameScreen = map['showInputMethodInGameScreen'];

    players = map['players'] == null
        ? []
        : map['players'].map<Player>((item) {
            return Player.fromMap(item);
          }).toList();

    drawMode = map['drawMode'];
  }

  Map<String, dynamic> toMap() {
    String modeInResult = '';
    String modeOutResult = '';
    switch (modeIn) {
      case ModeOutIn.Single:
        modeInResult = 'Single';
        break;
      case ModeOutIn.Double:
        modeInResult = 'Double';
        break;
      case ModeOutIn.Master:
        modeInResult = 'Master';
        break;
    }
    switch (modeOut) {
      case ModeOutIn.Single:
        modeOutResult = 'Single';
        break;
      case ModeOutIn.Double:
        modeOutResult = 'Double';
        break;
      case ModeOutIn.Master:
        modeOutResult = 'Master';
        break;
    }

    return {
      'id': id,
      'isSelected': isSelected,
      'singleOrTeam':
          singleOrTeam == SingleOrTeamEnum.Single ? 'Single' : 'Team',
      'mode': mode == BestOfOrFirstToEnum.FirstTo ? 'First to' : 'Best of',
      'points': points,
      'customPoints': customPoints,
      'legs': legs,
      'sets': sets,
      'setsEnabled': setsEnabled,
      'modeIn': modeInResult,
      'modeOut': modeOutResult,
      'winByTwoLegsDifference': winByTwoLegsDifference,
      'suddenDeath': suddenDeath,
      'maxExtraLegs': maxExtraLegs,
      'enableCheckoutCounting': enableCheckoutCounting,
      'checkoutCountingFinallyDisabled': checkoutCountingFinallyDisabled,
      'showAverage': showAverage,
      'showFinishWays': showFinishWays,
      'showThrownDartsPerLeg': showThrownDartsPerLeg,
      'showLastThrow': showLastThrow,
      'automaticallySubmitPoints': automaticallySubmitPoints,
      'showMostScoredPoints': showMostScoredPoints,
      'mostScoredPoints': mostScoredPoints,
      'inputMethod': inputMethod == InputMethod.Round ? 'Round' : 'Three Darts',
      'showInputMethodInGameScreen': showInputMethodInGameScreen,
      if (players.isNotEmpty)
        'players': players.map((player) {
          return player.toMap(player);
        }).toList(),
      'drawMode': drawMode,
    };
  }

  get id => this._id;

  set id(value) => this._id = value;

  get isSelected => this._isSelected;

  set isSelected(value) => this._isSelected = value;

  bool get loadSettings => this._loadSettings;
  set loadSettings(bool value) => this._loadSettings = value;

  List<Player> get players => this._players;

  set players(List<Player> value) => this._players = value;

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

  get automaticallySubmitPoints => this._automaticallySubmitPoints;

  set automaticallySubmitPoints(value) =>
      this._automaticallySubmitPoints = value;

  get showMostScoredPoints => this._showMostScoredPoints;

  set showMostScoredPoints(value) => this._showMostScoredPoints = value;

  List<String> get mostScoredPoints => this._mostScoredPoints;

  set mostScoredPoints(List<String> value) => this._mostScoredPoints = value;

  get inputMethod => this._inputMethod;

  set inputMethod(value) => this._inputMethod = value;

  get showInputMethodInGameScreen => this._showInputMethodInGameScreen;

  set showInputMethodInGameScreen(value) =>
      this._showInputMethodInGameScreen = value;

  get drawMode => this._drawMode;

  set drawMode(value) => this._drawMode = value;

  resetValues(String? username) async {
    players = [];
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
    automaticallySubmitPoints = DEFAULT_AUTO_SUBMIT_POINTS;
    showMostScoredPoints = DEFAULT_SHOW_MOST_SCORED_POINTS;
    mostScoredPoints = DEFAULT_MOST_SCORED_POINTS;
    inputMethod = DEFAULT_INPUT_METHOD;
    showInputMethodInGameScreen = DEFAULT_SHOW_INPUT_METHOD_IN_GAME_SCREEN;
    drawMode = DEFAULT_DRAW_MODE;
  }
}
