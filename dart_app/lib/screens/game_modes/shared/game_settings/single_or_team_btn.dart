import 'package:dart_app/constants.dart';
import 'package:dart_app/services/auth_service.dart';
import 'package:dart_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class SingleOrTeamBtn extends StatelessWidget {
  const SingleOrTeamBtn({
    Key? key,
    required this.settings,
  }) : super(key: key);

  final dynamic settings;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: WIDTH_GAMESETTINGS.w,
      height: WIDGET_HEIGHT_GAMESETTINGS.h,
      margin: EdgeInsets.only(
        top: MARGIN_GAMESETTINGS.h,
        bottom: MARGIN_GAMESETTINGS.h,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SingleBtn(gameSettingsProvider: settings),
          TeamBtn(gameSettingsProvider: settings),
        ],
      ),
    );
  }
}

class SingleBtn extends StatelessWidget {
  const SingleBtn({
    Key? key,
    required this.gameSettingsProvider,
  }) : super(key: key);

  final dynamic gameSettingsProvider;

  @override
  Widget build(BuildContext context) {
    final SingleOrTeamEnum singleOrTeam = gameSettingsProvider.getSingleOrTeam;

    return Expanded(
      child: ElevatedButton(
        onPressed: () {
          Utils.handleVibrationFeedback(context);
          if (singleOrTeam != SingleOrTeamEnum.Single) {
            final String currentUsername = context
                    .read<AuthService>()
                    .getUsernameFromSharedPreferences() ??
                '';
            gameSettingsProvider.switchSingleOrTeamMode(currentUsername);
          }
        },
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            'Single ${singleOrTeam == SingleOrTeamEnum.Single ? '(${gameSettingsProvider.getPlayers.length})' : ''}',
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: Utils.getTextColorForGameSettingsBtn(
                      singleOrTeam == SingleOrTeamEnum.Single, context),
                  fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
                ),
          ),
        ),
        style: ButtonStyle(
          splashFactory: NoSplash.splashFactory,
          shadowColor: MaterialStateProperty.all(Colors.transparent),
          overlayColor: MaterialStateProperty.all(Colors.transparent),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              side: BorderSide(
                color: Utils.getPrimaryColorDarken(context),
                width: GAME_SETTINGS_BTN_BORDER_WITH.w,
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(BUTTON_BORDER_RADIUS),
                bottomLeft: Radius.circular(BUTTON_BORDER_RADIUS),
              ),
            ),
          ),
          backgroundColor: singleOrTeam == SingleOrTeamEnum.Single
              ? Utils.getPrimaryMaterialStateColorDarken(context)
              : Utils.getColor(Theme.of(context).colorScheme.primary),
        ),
      ),
    );
  }
}

class TeamBtn extends StatelessWidget {
  const TeamBtn({
    Key? key,
    required this.gameSettingsProvider,
  }) : super(key: key);

  final dynamic gameSettingsProvider;

  @override
  Widget build(BuildContext context) {
    final SingleOrTeamEnum singleOrTeam = gameSettingsProvider.getSingleOrTeam;

    return Expanded(
      child: ElevatedButton(
        onPressed: () {
          Utils.handleVibrationFeedback(context);
          if (singleOrTeam != SingleOrTeamEnum.Team) {
            gameSettingsProvider.switchSingleOrTeamMode();
          }
        },
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            'Team ${singleOrTeam == SingleOrTeamEnum.Team ? '(${gameSettingsProvider.getTeams.length})' : ''}',
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: Utils.getTextColorForGameSettingsBtn(
                      singleOrTeam == SingleOrTeamEnum.Team, context),
                  fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
                ),
          ),
        ),
        style: ButtonStyle(
          splashFactory: NoSplash.splashFactory,
          shadowColor: MaterialStateProperty.all(Colors.transparent),
          overlayColor: MaterialStateProperty.all(Colors.transparent),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              side: BorderSide(
                color: Utils.getPrimaryColorDarken(context),
                width: GAME_SETTINGS_BTN_BORDER_WITH.w,
              ),
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(BUTTON_BORDER_RADIUS),
                bottomRight: Radius.circular(BUTTON_BORDER_RADIUS),
              ),
            ),
          ),
          backgroundColor: singleOrTeam == SingleOrTeamEnum.Team
              ? Utils.getPrimaryMaterialStateColorDarken(context)
              : Utils.getColor(Theme.of(context).colorScheme.primary),
        ),
      ),
    );
  }
}
