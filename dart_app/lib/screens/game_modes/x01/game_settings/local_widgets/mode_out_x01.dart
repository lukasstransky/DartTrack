import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/x01/game_settings_x01_p.dart';
import 'package:dart_app/utils/button_styles.dart';
import 'package:dart_app/utils/utils.dart';

import 'package:flutter/material.dart';
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
          height: WIDGET_HEIGHT_GAMESETTINGS.h,
          margin: EdgeInsets.only(top: MARGIN_GAMESETTINGS.h),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
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
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: Utils.getTextColorForGameSettingsBtn(
                    modeOut == ModeOutIn.Single,
                    context,
                  ),
                  fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
                ),
          ),
        ),
        style: ButtonStyles.primaryColorBtnStyle(
                context, modeOut == ModeOutIn.Single)
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
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Utils.getTextColorForGameSettingsBtn(
                      modeOut == ModeOutIn.Double,
                      context,
                    ),
                    fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
                  ),
            ),
          ),
          style: ButtonStyles.primaryColorBtnStyle(
                  context, modeOut == ModeOutIn.Double)
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
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Utils.getTextColorForGameSettingsBtn(
                      modeOut == ModeOutIn.Master,
                      context,
                    ),
                    fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
                  ),
            ),
          ),
          style: ButtonStyles.primaryColorBtnStyle(
                  context, modeOut == ModeOutIn.Master)
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
