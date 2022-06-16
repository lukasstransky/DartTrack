import 'package:dart_app/constants.dart';
import 'package:dart_app/models/bot.dart';
import 'package:dart_app/models/game_settings/game_settings_x01.dart';
import 'package:dart_app/models/player.dart';
import 'package:dart_app/models/team.dart';
import 'package:dart_app/screens/game_modes/x01/game_settings/local_widgets/bestof_or_first_to.dart';
import 'package:dart_app/screens/game_modes/x01/game_settings/local_widgets/checkout_counting.dart';
import 'package:dart_app/screens/game_modes/x01/game_settings/local_widgets/custom_points.dart';
import 'package:dart_app/screens/game_modes/x01/game_settings/local_widgets/players_teams.dart';
import 'package:dart_app/screens/game_modes/x01/game_settings/local_widgets/points.dart';
import 'package:dart_app/screens/game_modes/x01/game_settings/local_widgets/sets_or_legs.dart';
import 'package:dart_app/screens/game_modes/x01/game_settings/local_widgets/single_or_double_in.dart';
import 'package:dart_app/screens/game_modes/x01/game_settings/local_widgets/single_or_double_out.dart';
import 'package:dart_app/screens/game_modes/x01/game_settings/local_widgets/single_or_team.dart';
import 'package:dart_app/screens/game_modes/x01/game_settings/local_widgets/start_game_btn.dart';
import 'package:dart_app/screens/game_modes/x01/game_settings/local_widgets/win_by_two_legs_diff.dart';
import 'package:dart_app/services/auth_service.dart';
import 'package:dart_app/utils/app_bars/custom_app_bar.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'dart:developer';
import 'package:tuple/tuple.dart';
import 'package:sizer/sizer.dart';

class GameSettings extends StatefulWidget {
  static const routeName = "/settingsX01";

  const GameSettings({Key? key}) : super(key: key);

  @override
  _GameSettingsState createState() => _GameSettingsState();
}

class _GameSettingsState extends State<GameSettings> {
  final TextEditingController _newPlayerController =
      new TextEditingController();
  final TextEditingController _newTeamController = new TextEditingController();
  //final ScrollController _scrollControllerPlayers = new ScrollController();

  final GlobalKey<FormState> _formKeyNewTeam = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKeyNewPlayer = GlobalKey<FormState>();

  NewPlayer? _newPlayer = NewPlayer.Bot;
  double _botAvgSliderValue = PREDEFINED_BOT_AVERAGE_SLIDER_VALUE;

  @override
  void initState() {
    super.initState();
    addCurrentUserToPlayers();
    //addPlayersForTesting();
  }

  @override
  void dispose() {
    _newPlayerController.dispose();
    _newTeamController.dispose();
    super.dispose();
  }

  //just for testing -> to automatically have 2 players inserted
  void addPlayersForTesting() {
    final gameSettingsX01 =
        Provider.of<GameSettingsX01>(context, listen: false);
    if (gameSettingsX01.getPlayers.length < 2) {
      gameSettingsX01.addPlayer(new Player(name: "Strainski"));
      gameSettingsX01.addPlayer(new Player(name: "GG"));
    }
  }

  //adds the current logged in user to the players listview
  void addCurrentUserToPlayers() async {
    final Player? currentUserAsPlayer =
        await context.read<AuthService>().getPlayer;
    final gameSettingsX01 =
        Provider.of<GameSettingsX01>(context, listen: false);
    //reset all values to default (player starts new game -> in order to not have the settings from the previous game saved)
    gameSettingsX01.resetValues();

    //check if user already inserted -> in case of switching between othe screen -> would get inserted 2 times (method gets called in initstate)
    if (currentUserAsPlayer != null &&
        !gameSettingsX01.checkIfPlayerAlreadyInserted(currentUserAsPlayer)) {
      Player toAdd = new Player(name: currentUserAsPlayer.getName);
      gameSettingsX01.addPlayer(toAdd);
    }
  }

  void _showDialogForAddingPlayer(GameSettingsX01 gameSettingsX01) {
    _newPlayer = gameSettingsX01.getSingleOrTeam == SingleOrTeamEnum.Single
        ? NewPlayer.Bot
        : NewPlayer.Guest;
    _botAvgSliderValue = PREDEFINED_BOT_AVERAGE_SLIDER_VALUE;

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => Form(
        key: _formKeyNewPlayer,
        child: AlertDialog(
          title: const Text("Add New Player"),
          content: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    title: const Text("Bot"),
                    leading: Radio<NewPlayer>(
                      value: NewPlayer.Bot,
                      groupValue: _newPlayer,
                      onChanged: (value) => {
                        setState(
                          () {
                            _newPlayerController.text = "";
                            _newPlayer = value;
                          },
                        ),
                      },
                    ),
                  ),
                  if (_newPlayer == NewPlayer.Bot)
                    Row(
                      children: [
                        Slider(
                          value: _botAvgSliderValue,
                          max: 120,
                          min: 10,
                          divisions: 120,
                          label:
                              _botAvgSliderValue.round().toString() + ' avg.',
                          onChanged: (value) => {
                            setState(
                              () {
                                _botAvgSliderValue = value;
                              },
                            ),
                          },
                        ),
                        Flexible(
                          child: Text(
                            _botAvgSliderValue.round().toString() + ' avg.',
                            style: TextStyle(
                              fontSize: 7.sp,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ListTile(
                    key: Key("guestPlayerRadioBtn"),
                    title: const Text("Guest"),
                    leading: Radio<NewPlayer>(
                      value: NewPlayer.Guest,
                      groupValue: _newPlayer,
                      onChanged: (value) => {
                        setState(
                          () {
                            _botAvgSliderValue = 50;
                            _newPlayer = value;
                          },
                        ),
                      },
                    ),
                  ),
                  if (_newPlayer == NewPlayer.Guest)
                    TextFormField(
                      key: Key("playerNameInput"),
                      controller: _newPlayerController,
                      textInputAction: TextInputAction.done,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return ("Please Enter a Name!");
                        }
                        if (gameSettingsX01.checkIfPlayerNameExists(value)) {
                          return "Playername already exists!";
                        }
                        return null;
                      },
                      keyboardType: TextInputType.text,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(
                            MAX_CHARACTERS_NEW_PLAYER_TEXTFIELD),
                      ],
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.person,
                        ),
                        hintText: "Name",
                        filled: true,
                        hintStyle: TextStyle(color: Colors.grey),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(
                            width: 0,
                            style: BorderStyle.none,
                          ),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => {
                Navigator.of(context).pop(),
                _botAvgSliderValue = PREDEFINED_BOT_AVERAGE_SLIDER_VALUE,
                _newPlayerController.clear(),
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              key: Key("submitPlayerBtn"),
              onPressed: () => _submitNewPlayer(gameSettingsX01),
              child: const Text("Submit"),
            ),
          ],
        ),
      ),
    );
  }

  void _submitNewPlayer(GameSettingsX01 gameSettingsX01) async {
    if (!_formKeyNewPlayer.currentState!.validate()) {
      return;
    }
    _formKeyNewPlayer.currentState!.save();

    Player playerToAdd;
    if (_newPlayer == NewPlayer.Bot) {
      playerToAdd = new Bot(name: "Bot", preDefinedAverage: _botAvgSliderValue);
    } else {
      playerToAdd = new Player(name: _newPlayerController.text);
    }

    Navigator.of(context).pop();

    if (gameSettingsX01.getSingleOrTeam == SingleOrTeamEnum.Team) {
      Team? teamToAdd = gameSettingsX01.checkIfMultipleTeamsToAdd();
      if (teamToAdd != null) {
        gameSettingsX01.addNewPlayerToSpecificTeam(playerToAdd, teamToAdd);
      } else {
        _showDialogForSelectingTeam(
            playerToAdd, gameSettingsX01.getTeams, gameSettingsX01);
      }
    } else {
      gameSettingsX01.addPlayer(playerToAdd);

      //scroll automatically smoothly to top in single player
      /*await Future.delayed(const Duration(milliseconds: 100));
      SchedulerBinding.instance?.addPostFrameCallback((_) {
        _scrollControllerPlayers.animateTo(
            _scrollControllerPlayers.position.maxScrollExtent,
            duration: Duration(milliseconds: 300),
            curve: Curves.fastOutSlowIn);
      });*/
    }

    _newPlayerController.clear();
  }

  void _showDialogForSelectingTeam(
      Player playerToAdd, List<Team> teams, GameSettingsX01 gameSettings) {
    Team? selectedTeam;
    if (teams.length >= 2) {
      selectedTeam = teams[0]; //set first team as default
    }

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Which Team?"),
          content: StatefulBuilder(
            builder: (context, setState) {
              return Container(
                width: 0.6.w, //not perfect

                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: teams.length,
                      itemBuilder: (BuildContext context, int index) {
                        final team = teams[index];

                        if (team.getPlayers.length != MAX_PLAYERS_PER_TEAM) {
                          return RadioListTile(
                              title: Text(team.getName),
                              value: team,
                              groupValue: selectedTeam,
                              onChanged: (Team? value) =>
                                  setState(() => selectedTeam = value));
                        } else {
                          return SizedBox.shrink();
                        }
                      },
                    ),
                  ],
                ),
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () => _submitNewTeamForPlayer(
                  playerToAdd, selectedTeam, gameSettings),
              child: const Text("Submit"),
            ),
          ],
        );
      },
    );
  }

  void _submitNewTeamForPlayer(
      Player player, Team? selectedTeam, GameSettingsX01 gameSettings) {
    gameSettings.addNewPlayerToSpecificTeam(player, selectedTeam);

    Navigator.of(context).pop();
  }

  void _showDialogForAddingPlayerOrTeam(GameSettingsX01 gameSettingsX01) {
    String? teamOrPlayer = "player";

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Wanna add a Team or Player?"),
          content: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (gameSettingsX01.getTeams.length < MAX_TEAMS)
                    RadioListTile(
                      title: const Text("Add Team"),
                      value: "team",
                      groupValue: teamOrPlayer,
                      onChanged: (String? value) {
                        setState(() => teamOrPlayer = value);
                      },
                    ),
                  if (gameSettingsX01.getTeams.length > 0)
                    RadioListTile(
                      title: const Text("Add Player"),
                      value: "player",
                      groupValue: teamOrPlayer,
                      onChanged: (String? value) {
                        setState(() => teamOrPlayer = value);
                      },
                    ),
                ],
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () => {
                Navigator.of(context).pop(),
                if (teamOrPlayer == "team")
                  {
                    _showDialogForAddingTeam(gameSettingsX01),
                  }
                else
                  {
                    _showDialogForAddingPlayer(gameSettingsX01),
                  }
              },
              child: const Text("Continue"),
            ),
          ],
        );
      },
    );
  }

  void _showDialogForAddingTeam(GameSettingsX01 gameSettingsX01) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return Form(
          key: _formKeyNewTeam,
          child: AlertDialog(
            title: const Text("Add Team"),
            content: StatefulBuilder(
              builder: (context, setState) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: _newTeamController,
                      textInputAction: TextInputAction.done,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return ("Please enter a Team name!");
                        }

                        if (gameSettingsX01.checkIfTeamNameExists(value)) {
                          return "Teamname already exists!";
                        }
                        return null;
                      },
                      keyboardType: TextInputType.text,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(
                            MAX_CHARACTERS_NEW_PLAYER_TEXTFIELD),
                      ],
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.group,
                        ),
                        hintText: "Team",
                        filled: true,
                        hintStyle: TextStyle(color: Colors.grey),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(
                            width: 0,
                            style: BorderStyle.none,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
            actions: [
              TextButton(
                onPressed: () => {
                  Navigator.of(context).pop(),
                  _newTeamController.clear(),
                },
                child: const Text("Cancel"),
              ),
              TextButton(
                onPressed: () => {
                  _submitNewTeam(gameSettingsX01),
                  _newTeamController.clear(),
                },
                child: const Text("Submit"),
              ),
            ],
          ),
        );
      },
    );
  }

  void _submitNewTeam(GameSettingsX01 gameSettingsX01) {
    if (!_formKeyNewTeam.currentState!.validate()) {
      return;
    }
    _formKeyNewTeam.currentState!.save();

    Navigator.of(context).pop();
    gameSettingsX01.addNewTeam(_newTeamController.text);
  }

  @override
  Widget build(BuildContext context) {
    final gameSettingsX01 =
        Provider.of<GameSettingsX01>(context, listen: false);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBar(true, "Game Settings"),
      body: SafeArea(
        child: Column(
          children: [
            SingleOrTeam(),
            PlayersTeams(),
            if (gameSettingsX01.getPlayers.length != MAX_PLAYERS)
              Container(
                width: 10.w,
                child: Selector<GameSettingsX01, List<Player>>(
                  selector: (_, gameSettingsX01) => gameSettingsX01.getPlayers,
                  builder: (_, players, __) => players.length < MAX_PLAYERS
                      ? FloatingActionButton(
                          key: Key("addPlayerBtn"),
                          onPressed: () => {
                            if (gameSettingsX01.getSingleOrTeam ==
                                    SingleOrTeamEnum.Single ||
                                gameSettingsX01.getTeams.length == MAX_TEAMS)
                              {
                                _showDialogForAddingPlayer(gameSettingsX01),
                              }
                            //case -> team full of players -> should not be possible to add a player, instead only allow to add team
                            else if (gameSettingsX01.getSingleOrTeam ==
                                    SingleOrTeamEnum.Team &&
                                gameSettingsX01.possibleToAddPlayer() == false)
                              {
                                _showDialogForAddingTeam(gameSettingsX01),
                              }
                            else
                              {
                                _showDialogForAddingPlayerOrTeam(
                                    gameSettingsX01),
                              },
                          },
                          child: Icon(Icons.add),
                        )
                      : SizedBox.shrink(),
                ),
              ),
            Column(
              children: [
                SingleOrDoubleIn(),
                SingleOrDoubleOut(),
                BestOfOrFirstTo(),
                SetsOrLegs(),
                Center(
                  child: Container(
                    width: WIDTH_GAMESETTINGS.w,
                    margin: EdgeInsets.only(top: MARGIN_GAMESETTINGS.h),
                    child: Row(
                      children: [
                        Points(points: 301, key: Key("points301Btn")),
                        Points(points: 501, key: Key("points501Btn")),
                        Points(points: 701, key: Key("points701Btn")),
                        CustomPoints(),
                      ],
                    ),
                  ),
                ),
                Selector<GameSettingsX01,
                        Tuple3<bool, BestOfOrFirstToEnum, int>>(
                    selector: (_, gameSettingsX01) => Tuple3(
                        gameSettingsX01.getSetsEnabled,
                        gameSettingsX01.getMode,
                        gameSettingsX01.getLegs),
                    builder: (_, tuple, __) {
                      if (tuple.item1 == false &&
                          tuple.item2 ==
                              BestOfOrFirstToEnum
                                  .FirstTo) if (gameSettingsX01.getLegs > 1) {
                        return WinByTwoLegsDifference();
                      }

                      return SizedBox.shrink();
                    }),
                CheckoutCounting(),
                Padding(
                  padding: EdgeInsets.only(left: 7.w),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton.icon(
                      onPressed: () {
                        Navigator.of(context).pushNamed("/inGameSettingsX01");
                      },
                      icon: Icon(
                        Icons.settings,
                      ),
                      label: const Text(
                        "Advanced Setttings",
                      ),
                      style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            StartGameBtn(),
          ],
        ),
      ),
    );
  }
}
