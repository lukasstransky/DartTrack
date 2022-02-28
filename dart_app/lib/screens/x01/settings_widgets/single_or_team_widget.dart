import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/game_settings_x01_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class SingleOrTeamWidget extends StatelessWidget {
  const SingleOrTeamWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final gameSettingsX01 =
        Provider.of<GameSettingsX01>(context, listen: false);

    return Center(
      child: Container(
        width: WIDTH_GAMESETTINGS.w,
        margin: EdgeInsets.only(top: MARGIN_GAMESETTINGS.h),
        child: Selector<GameSettingsX01, SingleOrTeam>(
          selector: (_, gameSettingsX01) => gameSettingsX01.getSingleOrTeam,
          builder: (_, singleOrTeam, __) => Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: HEIGHT_GAMESETTINGS_WIDGETS.h,
                  child: ElevatedButton(
                    onPressed: () => singleOrTeam == SingleOrTeam.Team
                        ? gameSettingsX01.switchSingleOrTeamMode()
                        : null,
                    child: FittedBox(
                      fit: BoxFit.fitWidth,
                      child: const Text("Single"),
                    ),
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10.0),
                            bottomLeft: Radius.circular(10.0),
                          ),
                        ),
                      ),
                      backgroundColor: singleOrTeam == SingleOrTeam.Single
                          ? MaterialStateProperty.all(
                              Theme.of(context).colorScheme.primary)
                          : MaterialStateProperty.all<Color>(Colors.grey),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: SizedBox(
                  height: HEIGHT_GAMESETTINGS_WIDGETS.h,
                  child: ElevatedButton(
                    onPressed: () => singleOrTeam == SingleOrTeam.Single
                        ? gameSettingsX01.switchSingleOrTeamMode()
                        : null,
                    child: FittedBox(
                      fit: BoxFit.fitWidth,
                      child: const Text("Teams"),
                    ),
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(10.0),
                            bottomRight: Radius.circular(10.0),
                          ),
                        ),
                      ),
                      backgroundColor: singleOrTeam == SingleOrTeam.Team
                          ? MaterialStateProperty.all(
                              Theme.of(context).colorScheme.primary)
                          : MaterialStateProperty.all<Color>(Colors.grey),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
