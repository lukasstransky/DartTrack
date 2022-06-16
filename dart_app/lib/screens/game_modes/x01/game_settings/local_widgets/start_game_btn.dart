import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/game_settings_x01.dart';
import 'package:dart_app/models/player.dart';
import 'package:dart_app/models/team.dart';
import 'package:dart_app/services/auth_service.dart';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class StartGameBtn extends StatelessWidget {
  const StartGameBtn({Key? key}) : super(key: key);

  void _showDialogNoUserInPlayerWarning(
      BuildContext context, GameSettingsX01 gameSettingsX01) {
    String currentUserName = context.read<AuthService>().getPlayer!.getName;

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Game will not be stored for Statistics!"),
        content: RichText(
          text: TextSpan(
            text: 'No player with the current username ',
            style: DefaultTextStyle.of(context).style,
            children: <TextSpan>[
              TextSpan(
                  text: '\'$currentUserName\'',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              TextSpan(
                  text: ' is present, therefore the game will not be stored.'),
              TextSpan(
                  text:
                      '\n\n(In order to store the game, change the name of one player to \'$currentUserName\')'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () => {
              Navigator.of(context).pop(),
              _showDialogForBeginner(context, gameSettingsX01),
            },
            child: const Text("Continue anyways"),
          ),
        ],
      ),
    );
  }

  void _showDialogForBeginner(
      BuildContext context, GameSettingsX01 gameSettingsX01) {
    List<Player> players = gameSettingsX01.getPlayers;
    Player? selectedPlayer = gameSettingsX01.getPlayers[0];

    List<Team> teams = gameSettingsX01.getTeams;
    Team? selectedTeam = gameSettingsX01.getTeams[0];

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Who will begin?"),
        content: StatefulBuilder(
          builder: ((context, setState) {
            if (gameSettingsX01.getSingleOrTeam == SingleOrTeamEnum.Single)
              return Container(
                width: double.maxFinite,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: players.length,
                  itemBuilder: (BuildContext context, int index) {
                    final player = players[index];
                    return RadioListTile(
                      title: Text(player.getName),
                      value: player,
                      groupValue: selectedPlayer,
                      onChanged: (Player? value) {
                        setState(() => selectedPlayer = value);
                      },
                    );
                  },
                ),
              );
            if (gameSettingsX01.getSingleOrTeam == SingleOrTeamEnum.Team)
              return Container(
                width: double.maxFinite,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: teams.length,
                  itemBuilder: (BuildContext context, int index) {
                    final team = teams[index];
                    return RadioListTile(
                      title: Text(team.getName),
                      value: team,
                      groupValue: selectedTeam,
                      onChanged: (Team? value) {
                        setState(() => selectedTeam = value);
                      },
                    );
                  },
                ),
              );
            return SizedBox.shrink();
          }),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Cancel"),
          ),
          TextButton(
            key: Key("startGameDialogBtn"),
            onPressed: () => {
              if (gameSettingsX01.getSingleOrTeam == SingleOrTeamEnum.Single)
                {
                  gameSettingsX01.setBeginnerPlayer(selectedPlayer),
                }
              else
                {
                  gameSettingsX01.setBeginnerTeam(selectedTeam),
                },
              Navigator.of(context).pushNamed(
                "/gameX01",
                arguments: {'openGame': false},
              ),
            },
            child: const Text("Start Game"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final gameSettingsX01 =
        Provider.of<GameSettingsX01>(context, listen: false);

    return Expanded(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: SizedBox(
          width: 60.w,
          height: 5.h,
          child: TextButton(
            key: Key("startGameBtn"),
            child: const Text(
              "Start Game",
              style: TextStyle(color: Colors.white),
            ),
            style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                ),
              ),
              backgroundColor: MaterialStateProperty.all(
                  Theme.of(context).colorScheme.primary),
            ),
            onPressed: () => {
              if (gameSettingsX01.getPlayers.length < 2)
                {
                  Fluttertoast.showToast(
                    msg: "You need to have at least 2 Player to start a Game!",
                    toastLength: Toast.LENGTH_LONG,
                  ),
                }
              else
                {
                  //todo comment out
                  /*if (!gameSettingsX01.isCurrentUserInPlayers(context))
                    {
                      _showDialogNoUserInPlayerWarning(
                          context, gameSettingsX01),
                    }
                  else
                    {*/
                  _showDialogForBeginner(context, gameSettingsX01),
                  //}
                }
            },
          ),
        ),
      ),
    );
  }
}
