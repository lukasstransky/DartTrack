import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/x01/game_settings_x01_p.dart';
import 'package:dart_app/utils/button_styles.dart';
import 'package:dart_app/utils/utils.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class ModeInX01 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Selector<GameSettingsX01_P, SelectorModel>(
        selector: (_, gameSettingsX01) => SelectorModel(
          modeIn: gameSettingsX01.getModeIn,
          singleOrTeam: gameSettingsX01.getSingleOrTeam,
        ),
        builder: (_, selectorModel, __) => Container(
          width: WIDTH_GAMESETTINGS.w,
          height: WIDGET_HEIGHT_GAMESETTINGS.h,
          margin: EdgeInsets.only(top: MARGIN_GAMESETTINGS.h),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SingleInBtn(modeIn: selectorModel.modeIn),
              DoubleInBtn(modeIn: selectorModel.modeIn),
              MasterInBtn(modeIn: selectorModel.modeIn),
            ],
          ),
        ),
      ),
    );
  }
}

class MasterInBtn extends StatelessWidget {
  const MasterInBtn({
    Key? key,
    required this.modeIn,
  }) : super(key: key);

  final ModeOutIn modeIn;

  @override
  Widget build(BuildContext context) {
    final GameSettingsX01_P gameSettingsX01 = context.read<GameSettingsX01_P>();

    return Expanded(
      child: ElevatedButton(
        onPressed: () {
          Utils.handleVibrationFeedback(context);
          gameSettingsX01.setModeIn = ModeOutIn.Master;
          gameSettingsX01.notify();
        },
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            'Master in',
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: Utils.getTextColorForGameSettingsBtn(
                    modeIn == ModeOutIn.Master,
                    context,
                  ),
                  fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
                ),
          ),
        ),
        style: ButtonStyles.primaryColorBtnStyle(
                context, modeIn == ModeOutIn.Master)
            .copyWith(
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
        ),
      ),
    );
  }
}

class DoubleInBtn extends StatelessWidget {
  const DoubleInBtn({
    Key? key,
    required this.modeIn,
  }) : super(key: key);

  final ModeOutIn modeIn;

  @override
  Widget build(BuildContext context) {
    final GameSettingsX01_P gameSettingsX01 = context.read<GameSettingsX01_P>();

    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
                color: Utils.getPrimaryColorDarken(context),
                width: GAME_SETTINGS_BTN_BORDER_WITH.w),
            bottom: BorderSide(
                color: Utils.getPrimaryColorDarken(context),
                width: GAME_SETTINGS_BTN_BORDER_WITH.w),
          ),
        ),
        child: ElevatedButton(
          onPressed: () {
            Utils.handleVibrationFeedback(context);
            gameSettingsX01.setModeIn = ModeOutIn.Double;
            gameSettingsX01.notify();
          },
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              'Double in',
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Utils.getTextColorForGameSettingsBtn(
                      modeIn == ModeOutIn.Double,
                      context,
                    ),
                    fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
                  ),
            ),
          ),
          style: ButtonStyles.primaryColorBtnStyle(
                  context, modeIn == ModeOutIn.Double)
              .copyWith(
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(borderRadius: BorderRadius.zero),
            ),
          ),
        ),
      ),
    );
  }
}

class SingleInBtn extends StatelessWidget {
  const SingleInBtn({
    Key? key,
    required this.modeIn,
  }) : super(key: key);

  final ModeOutIn modeIn;

  @override
  Widget build(BuildContext context) {
    final GameSettingsX01_P gameSettingsX01 = context.read<GameSettingsX01_P>();

    return Expanded(
      child: ElevatedButton(
        onPressed: () {
          Utils.handleVibrationFeedback(context);
          gameSettingsX01.setModeIn = ModeOutIn.Single;
          gameSettingsX01.notify();
        },
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            'Single in',
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: Utils.getTextColorForGameSettingsBtn(
                    modeIn == ModeOutIn.Single,
                    context,
                  ),
                  fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
                ),
          ),
        ),
        style: ButtonStyles.primaryColorBtnStyle(
                context, modeIn == ModeOutIn.Single)
            .copyWith(
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
        ),
      ),
    );
  }
}

class SelectorModel {
  final ModeOutIn modeIn;
  final SingleOrTeamEnum singleOrTeam;

  SelectorModel({
    required this.modeIn,
    required this.singleOrTeam,
  });
}
