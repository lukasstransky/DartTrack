import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/game_settings_x01_model.dart';
import 'package:dart_app/models/player_model.dart';
import 'package:dart_app/models/team_model.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class StartGameBtn extends StatelessWidget {
  const StartGameBtn({Key? key}) : super(key: key);

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
            if (gameSettingsX01.getSingleOrTeam == SingleOrTeam.Single)
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
            if (gameSettingsX01.getSingleOrTeam == SingleOrTeam.Team)
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
            onPressed: () => Navigator.of(context).pushNamed("/gameX01"),
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
                  _showDialogForBeginner(context, gameSettingsX01),
                }
            },
          ),
        ),
      ),
    );
  }
}
