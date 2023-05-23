import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/game_settings_p.dart';
import 'package:dart_app/models/games/game_cricket_p.dart';
import 'package:dart_app/models/player.dart';
import 'package:dart_app/models/team.dart';

class GameSettingsCricket_P extends GameSettings_P {
  SingleOrTeamEnum _singleOrTeam = DEFAULT_SINGLE_OR_TEAM_CRICKET;
  BestOfOrFirstToEnum _bestOfOrFirstTo = DEFAULT_BEST_OF_OR_FIRST_TO_CRICKET;
  CricketMode _mode = DEFAULT_CRICKET_MODE;
  int _legs = DEFAULT_LEGS_FIRST_TO_NO_SETS_CRICKET;
  int _sets = DEFAULT_SETS_FIRST_TO_SETS_ENABLED_CRICKET;
  bool _setsEnabled = DEFAULT_SETS_ENABLED_CRICKET;

  SingleOrTeamEnum get getSingleOrTeam => this._singleOrTeam;
  set setSingleOrTeam(SingleOrTeamEnum value) => this._singleOrTeam = value;

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

  GameSettingsCricket_P.firestore({
    required SingleOrTeamEnum singleOrTeam,
    required BestOfOrFirstToEnum bestOfOrFirstTo,
    required CricketMode mode,
    required int legs,
    required int sets,
    required bool setsEnabled,
    List<Player>? players,
    List<Team>? teams,
  }) {
    this.setSingleOrTeam = singleOrTeam;
    this.setBestOfOrFirstTo = bestOfOrFirstTo;
    this.setMode = mode;
    this.setLegs = legs;
    this.setSets = sets;
    this.setSetsEnabled = setsEnabled;

    if (players != null) {
      setPlayers = players;
    }
    if (teams != null) {
      setTeams = teams;
    }
  }

  switchSingleOrTeamMode() {
    if (getSingleOrTeam == SingleOrTeamEnum.Single) {
      setSingleOrTeam = SingleOrTeamEnum.Team;
    } else {
      if (getPlayers.length > 4) {
        for (int i = 4; i < getPlayers.length; i++) {
          removePlayer(getPlayers.elementAt(i), true, true);
        }
      }
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
    setBestOfOrFirstTo = BestOfOrFirstToEnum.FirstTo;
    setMode = CricketMode.Standard;
    setLegs = DEFAULT_LEGS_FIRST_TO_NO_SETS_CRICKET;
    setSets = DEFAULT_SETS_FIRST_TO_SETS_ENABLED_CRICKET;
    setSetsEnabled = false;

    setPlayers = [];
    setTeams = [];
    setTeamNamingIds = [];
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

  String getModeStringFinishScreen(bool isOpenGame, GameCricket_P game) {
    return '${getMode.name} mode';
  }
}
