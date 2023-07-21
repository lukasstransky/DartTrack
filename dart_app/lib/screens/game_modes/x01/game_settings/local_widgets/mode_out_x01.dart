import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/x01/game_settings_x01_p.dart';
import 'package:dart_app/models/settings_p.dart';
import 'package:dart_app/utils/utils.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class ModeOutX01 extends StatelessWidget {
  const ModeOutX01({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Selector<GameSettingsX01_P, SelectorModel>(
        selector: (_, gameSettingsX01) => SelectorModel(
          modeOut: gameSettingsX01.getModeOut,
          singleOrTeam: gameSettingsX01.getSingleOrTeam,
        ),
        builder: (_, selectorModel, __) => Container(
          width: WIDTH_GAMESETTINGS.w,
          height: Utils.shouldShrinkWidget(context.read<GameSettingsX01_P>())
              ? WIDGET_HEIGHT_GAMESETTINGS_TEAMS.h
              : WIDGET_HEIGHT_GAMESETTINGS.h,
          margin: EdgeInsets.only(top: MARGIN_GAMESETTINGS.h),
          child: Row(
            children: [
              SingleOutBtn(modeOut: selectorModel.modeOut),
              DoubleOutBtn(modeOut: selectorModel.modeOut),
              MasterOutBtn(modeOut: selectorModel.modeOut),
            ],
          ),
        ),
      ),
    );
  }
}

class SingleOutBtn extends StatelessWidget {
  const SingleOutBtn({Key? key, required this.modeOut}) : super(key: key);

  final ModeOutIn modeOut;

  _singleOutClicked(GameSettingsX01_P gameSettingsX01) {
    gameSettingsX01.setModeOut = ModeOutIn.Single;
    gameSettingsX01.setEnableCheckoutCounting = false;
    gameSettingsX01.notify();
  }

  @override
  Widget build(BuildContext context) {
    final GameSettingsX01_P gameSettingsX01 = context.read<GameSettingsX01_P>();

    return Expanded(
      child: ElevatedButton(
        onPressed: () {
          Utils.handleVibrationFeedback(context);
          _singleOutClicked(gameSettingsX01);
        },
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            'Single out',
            style: TextStyle(
              color: Utils.getTextColorForGameSettingsBtn(
                  modeOut == ModeOutIn.Single, context),
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
          backgroundColor: modeOut == ModeOutIn.Single
              ? Utils.getPrimaryMaterialStateColorDarken(context)
              : Utils.getColor(Theme.of(context).colorScheme.primary),
        ),
      ),
    );
  }
}

class DoubleOutBtn extends StatelessWidget {
  const DoubleOutBtn({Key? key, required this.modeOut}) : super(key: key);

  final ModeOutIn modeOut;

  _doubleOutClicked(GameSettingsX01_P gameSettingsX01) {
    gameSettingsX01.setEnableCheckoutCounting = false;
    gameSettingsX01.setModeOut = ModeOutIn.Double;
    gameSettingsX01.notify();
  }

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
            _doubleOutClicked(gameSettingsX01);
          },
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              'Double out',
              style: TextStyle(
                color: Utils.getTextColorForGameSettingsBtn(
                    modeOut == ModeOutIn.Double, context),
              ),
            ),
          ),
          style: ButtonStyle(
            splashFactory: NoSplash.splashFactory,
            shadowColor: MaterialStateProperty.all(Colors.transparent),
            overlayColor: MaterialStateProperty.all(Colors.transparent),
            backgroundColor: modeOut == ModeOutIn.Double
                ? Utils.getPrimaryMaterialStateColorDarken(context)
                : Utils.getColor(Theme.of(context).colorScheme.primary),
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(borderRadius: BorderRadius.zero),
            ),
          ),
        ),
      ),
    );
  }
}

class MasterOutBtn extends StatelessWidget {
  const MasterOutBtn({Key? key, required this.modeOut}) : super(key: key);

  final ModeOutIn modeOut;

  _masterOutClicked(GameSettingsX01_P gameSettingsX01) {
    gameSettingsX01.setModeOut = ModeOutIn.Master;
    gameSettingsX01.setEnableCheckoutCounting = false;
    gameSettingsX01.notify();
  }

  @override
  Widget build(BuildContext context) {
    final GameSettingsX01_P gameSettingsX01 = context.read<GameSettingsX01_P>();

    return Expanded(
      child: SizedBox(
        child: ElevatedButton(
          onPressed: () {
            Utils.handleVibrationFeedback(context);
            _masterOutClicked(gameSettingsX01);
          },
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              'Master out',
              style: TextStyle(
                color: Utils.getTextColorForGameSettingsBtn(
                    modeOut == ModeOutIn.Master, context),
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
            backgroundColor: modeOut == ModeOutIn.Master
                ? Utils.getPrimaryMaterialStateColorDarken(context)
                : Utils.getColor(Theme.of(context).colorScheme.primary),
          ),
        ),
      ),
    );
  }
}

class SelectorModel {
  final ModeOutIn modeOut;
  final SingleOrTeamEnum singleOrTeam;

  SelectorModel({
    required this.modeOut,
    required this.singleOrTeam,
  });
}
