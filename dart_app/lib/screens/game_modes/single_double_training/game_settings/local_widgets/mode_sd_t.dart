import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/game_settings_single_double_training_p.dart';
import 'package:dart_app/utils/button_styles.dart';
import 'package:dart_app/utils/utils.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class ModeSingleDoubleTraining extends StatelessWidget {
  const ModeSingleDoubleTraining({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 1.h),
      child: Center(
        child: Container(
          width: WIDTH_GAMESETTINGS.w,
          height: WIDGET_HEIGHT_GAMESETTINGS.h,
          child: Selector<GameSettingsSingleDoubleTraining_P, SelectorModel>(
            selector: (_, gameSettingsSingleDoubleTraining) => SelectorModel(
              mode: gameSettingsSingleDoubleTraining.getMode,
              isTargetNumberEnabled:
                  gameSettingsSingleDoubleTraining.getIsTargetNumberEnabled,
            ),
            builder: (_, selectorModel, __) => Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AscendingBtn(
                  isAscendingMode:
                      selectorModel.mode == ModesSingleDoubleTraining.Ascending,
                  isTargetNumberEnabled: selectorModel.isTargetNumberEnabled,
                ),
                DescendingBtn(
                  isDescendingMode: selectorModel.mode ==
                      ModesSingleDoubleTraining.Descending,
                  isTargetNumberEnabled: selectorModel.isTargetNumberEnabled,
                ),
                RandomBtn(
                  isRandomBtn:
                      selectorModel.mode == ModesSingleDoubleTraining.Random,
                  isTargetNumberEnabled: selectorModel.isTargetNumberEnabled,
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
      child: Container(
        height: 4.h,
        child: ElevatedButton(
          onPressed: () {
            Utils.handleVibrationFeedback(context);
            context
                .read<GameSettingsSingleDoubleTraining_P>()
                .changeMode(ModesSingleDoubleTraining.Random);
          },
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              'Random',
              style: TextStyle(
                color: Utils.getTextColorForGameSettingsBtn(
                    isRandomBtn && !isTargetNumberEnabled, context),
                fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
              ),
            ),
          ),
          style: ButtonStyles.primaryColorBtnStyle(
                  context, isRandomBtn && !isTargetNumberEnabled)
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
        height: 4.h,
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Utils.getPrimaryColorDarken(context),
              width: GAME_SETTINGS_BTN_BORDER_WITH.w,
            ),
            bottom: BorderSide(
              color: Utils.getPrimaryColorDarken(context),
              width: GAME_SETTINGS_BTN_BORDER_WITH.w,
            ),
          ),
        ),
        child: ElevatedButton(
          onPressed: () {
            Utils.handleVibrationFeedback(context);
            context
                .read<GameSettingsSingleDoubleTraining_P>()
                .changeMode(ModesSingleDoubleTraining.Descending);
          },
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              'Descending',
              style: TextStyle(
                color: Utils.getTextColorForGameSettingsBtn(
                    isDescendingMode && !isTargetNumberEnabled, context),
                fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
              ),
            ),
          ),
          style: ButtonStyles.primaryColorBtnStyle(
                  context, isDescendingMode && !isTargetNumberEnabled)
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
      child: Container(
        height: 4.h,
        child: ElevatedButton(
          onPressed: () {
            Utils.handleVibrationFeedback(context);
            context
                .read<GameSettingsSingleDoubleTraining_P>()
                .changeMode(ModesSingleDoubleTraining.Ascending);
          },
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              'Ascending',
              style: TextStyle(
                color: Utils.getTextColorForGameSettingsBtn(
                    isAscendingMode && !isTargetNumberEnabled, context),
                fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
              ),
            ),
          ),
          style: ButtonStyles.primaryColorBtnStyle(
                  context, isAscendingMode && !isTargetNumberEnabled)
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
      ),
    );
  }
}

class SelectorModel {
  final ModesSingleDoubleTraining mode;
  final bool isTargetNumberEnabled;

  SelectorModel({
    required this.mode,
    required this.isTargetNumberEnabled,
  });
}
