import 'package:dart_app/models/game_settings/game_settings_p.dart';
import 'package:dart_app/models/team.dart';
import 'package:dart_app/screens/game_modes/shared/game_settings/players_teams_list/teams_list/teams_list_entry.dart';
import 'package:dart_app/utils/globals.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class TeamsList extends StatefulWidget {
  const TeamsList({
    Key? key,
    required this.gameSettings,
    required this.teams,
  }) : super(key: key);

  final GameSettings_P gameSettings;
  final List<Team> teams;

  @override
  State<TeamsList> createState() => _TeamsListX01State();
}

class _TeamsListX01State extends State<TeamsList> {
  @override
  initState() {
    super.initState();
    newScrollControllerTeams();
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: 20.h),
      child: ListView.builder(
        shrinkWrap: true,
        controller: newScrollControllerTeams(),
        itemCount: widget.teams.length,
        itemBuilder: (BuildContext context, int index) {
          return TeamsListEntry(
            team: widget.teams[index],
            gameSettings: widget.gameSettings,
          );
        },
      ),
    );
  }
}
