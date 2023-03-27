import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/game_settings_single_double_training_p.dart';
import 'package:dart_app/utils/utils.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:tuple/tuple.dart';

class ModeSingleDoubleTraining extends StatelessWidget {
  const ModeSingleDoubleTraining({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: context
                    .watch<GameSettingsSingleDoubleTraining_P>()
                    .getPlayers
                    .length ==
                MAX_PLAYERS_SINGLE_DOUBLE_SCORE_TRAINING
            ? 1.5.h
            : 0,
        bottom: 0.5.h,
      ),
      child: Center(
        child: Container(
          width: WIDTH_GAMESETTINGS.w,
          height: WIDGET_HEIGHT_GAMESETTINGS.h,
          child: Selector<GameSettingsSingleDoubleTraining_P,
              Tuple2<ModesSingleDoubleTraining, bool>>(
            selector: (_, settings) =>
                new Tuple2(settings.getMode, settings.getIsTargetNumberEnabled),
            builder: (_, tuple, __) => Row(
              children: [
                AscendingBtn(
                  isAscendingMode:
                      tuple.item1 == ModesSingleDoubleTraining.Ascending,
                  isTargetNumberEnabled: tuple.item2,
                ),
                DescendingBtn(
                  isDescendingMode:
                      tuple.item1 == ModesSingleDoubleTraining.Descending,
                  isTargetNumberEnabled: tuple.item2,
                ),
                RandomBtn(
                  isRandomBtn: tuple.item1 == ModesSingleDoubleTraining.Random,
                  isTargetNumberEnabled: tuple.item2,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class RandomBtn extends StatelessWidget {
  const RandomBtn(
      {Key? key,
      required this.isRandomBtn,
      required this.isTargetNumberEnabled})
      : super(key: key);

  final bool isRandomBtn;
  final bool isTargetNumberEnabled;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ElevatedButton(
        onPressed: () => context
            .read<GameSettingsSingleDoubleTraining_P>()
            .changeMode(ModesSingleDoubleTraining.Random),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            'Random',
            style: TextStyle(
              color: Utils.getTextColorForGameSettingsBtn(
                  isRandomBtn && !isTargetNumberEnabled, context),
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
                width: GAME_SETTINGS_BTN_BORDER_WITH,
              ),
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(BUTTON_BORDER_RADIUS),
                bottomRight: Radius.circular(BUTTON_BORDER_RADIUS),
              ),
            ),
          ),
          backgroundColor: isRandomBtn && !isTargetNumberEnabled
              ? Utils.getPrimaryMaterialStateColorDarken(context)
              : Utils.getColor(Theme.of(context).colorScheme.primary),
        ),
      ),
    );
  }
}

class DescendingBtn extends StatelessWidget {
  const DescendingBtn(
      {Key? key,
      required this.isDescendingMode,
      required this.isTargetNumberEnabled})
      : super(key: key);

  final bool isDescendingMode;
  final bool isTargetNumberEnabled;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
                color: Utils.getPrimaryColorDarken(context),
                width: GAME_SETTINGS_BTN_BORDER_WITH),
            bottom: BorderSide(
                color: Utils.getPrimaryColorDarken(context),
                width: GAME_SETTINGS_BTN_BORDER_WITH),
          ),
        ),
        child: ElevatedButton(
          onPressed: () => context
              .read<GameSettingsSingleDoubleTraining_P>()
              .changeMode(ModesSingleDoubleTraining.Descending),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              'Descending',
              style: TextStyle(
                color: Utils.getTextColorForGameSettingsBtn(
                    isDescendingMode && !isTargetNumberEnabled, context),
              ),
            ),
          ),
          style: ButtonStyle(
            splashFactory: NoSplash.splashFactory,
            shadowColor: MaterialStateProperty.all(Colors.transparent),
            overlayColor: MaterialStateProperty.all(Colors.transparent),
            backgroundColor: isDescendingMode && !isTargetNumberEnabled
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

class AscendingBtn extends StatelessWidget {
  const AscendingBtn(
      {Key? key,
      required this.isAscendingMode,
      required this.isTargetNumberEnabled})
      : super(key: key);

  final bool isAscendingMode;
  final bool isTargetNumberEnabled;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ElevatedButton(
        onPressed: () => context
            .read<GameSettingsSingleDoubleTraining_P>()
            .changeMode(ModesSingleDoubleTraining.Ascending),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            'Ascending',
            style: TextStyle(
              color: Utils.getTextColorForGameSettingsBtn(
                  isAscendingMode && !isTargetNumberEnabled, context),
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
                width: GAME_SETTINGS_BTN_BORDER_WITH,
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(BUTTON_BORDER_RADIUS),
                bottomLeft: Radius.circular(BUTTON_BORDER_RADIUS),
              ),
            ),
          ),
          backgroundColor: isAscendingMode && !isTargetNumberEnabled
              ? Utils.getPrimaryMaterialStateColorDarken(context)
              : Utils.getColor(Theme.of(context).colorScheme.primary),
        ),
      ),
    );
  }
}
