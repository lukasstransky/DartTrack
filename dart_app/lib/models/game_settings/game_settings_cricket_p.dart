import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/game_settings_p.dart';

class GameSettingsCricket_P extends GameSettings_P {
  SingleOrTeamEnum _singleOrTeam = SingleOrTeamEnum.Single;
  SetsOrLegsEnum _setsOrLegs = SetsOrLegsEnum.Legs;
  BestOfOrFirstToEnum _bestOfOrFirstTo = BestOfOrFirstToEnum.FirstTo;
  CricketMode _mode = CricketMode.Standard;
  int _legs = 3;
  int _sets = 2;
  bool _setsEnabled = false;

  SingleOrTeamEnum get getSingleOrTeam => this._singleOrTeam;
  set setSingleOrTeam(SingleOrTeamEnum value) => this._singleOrTeam = value;

  SetsOrLegsEnum get getSetsOrLegs => this._setsOrLegs;
  set setSetsOrLegs(SetsOrLegsEnum value) => this._setsOrLegs = value;

  BestOfOrFirstToEnum get getBestOfOrFirstTo => this._bestOfOrFirstTo;
  set setBestOfOrFirstTo(BestOfOrFirstToEnum value) =>
      this._bestOfOrFirstTo = value;

  CricketMode get getMode => this._mode;
  set setMode(CricketMode value) => this._mode = value;

  int get getLegs => this._legs;
  set setLegs(int value) => this._legs = value;

  int get getSets => this._sets;
  set setSets(int value) => this._sets = value;

  bool get getSetsEnabled => this._setsEnabled;
  set setSetsEnabled(bool value) => this._setsEnabled = value;

  GameSettingsCricket_P() {}

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

      if (getSetsEnabled) {
        setLegs = DEFAULT_LEGS_FIRST_TO_SETS_ENABLED_CRICKET;
        setSets = DEFAULT_SETS_FIRST_TO_SETS_ENABLED_CRICKET;
      } else {
        setLegs = DEFAULT_LEGS_FIRST_TO_NO_SETS_CRICKET;
      }
    } else {
      setBestOfOrFirstTo = BestOfOrFirstToEnum.BestOf;

      if (getSetsEnabled) {
        setSets = DEFAULT_SETS_BEST_OF_SETS_ENABLED_CRICKET;
        setLegs = DEFAULT_LEGS_BEST_OF_SETS_ENABLED_CRICKET;
      } else {
        setLegs = DEFAULT_LEGS_BEST_OF_NO_SETS_CRICKET;
      }
    }

    notify();
  }

  reset() {
    setSingleOrTeam = SingleOrTeamEnum.Single;
    setSetsOrLegs = SetsOrLegsEnum.Legs;
    setBestOfOrFirstTo = BestOfOrFirstToEnum.FirstTo;
    setMode = CricketMode.Standard;
    setLegs = 3;
    setSets = 2;

    setPlayers = [];
    setTeams = [];
  }

  setsBtnClicked() {
    setSetsEnabled = !getSetsEnabled;

    if (getBestOfOrFirstTo == BestOfOrFirstToEnum.FirstTo) {
      setSets = DEFAULT_SETS_FIRST_TO_SETS_ENABLED_CRICKET;
      setLegs = getSetsEnabled
          ? DEFAULT_LEGS_FIRST_TO_SETS_ENABLED_CRICKET
          : DEFAULT_LEGS_FIRST_TO_NO_SETS_CRICKET;
    } else {
      setSets = DEFAULT_SETS_BEST_OF_SETS_ENABLED_CRICKET;
      setLegs = getSetsEnabled
          ? setLegs = DEFAULT_LEGS_BEST_OF_SETS_ENABLED_CRICKET
          : setSets = DEFAULT_LEGS_BEST_OF_NO_SETS_CRICKET;
    }

    notify();
  }
}
