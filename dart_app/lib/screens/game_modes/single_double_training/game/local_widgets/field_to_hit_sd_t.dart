import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/game_settings_single_double_training_p.dart';
import 'package:dart_app/models/games/game_single_double_training_p.dart';
import 'package:dart_app/utils/utils.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class FieldToHitSingleDoubleTraining extends StatelessWidget {
  const FieldToHitSingleDoubleTraining({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isTargetNumberEnabled = context
        .read<GameSettingsSingleDoubleTraining_P>()
        .getIsTargetNumberEnabled;
    final double fontSizeFieldToHit = Utils.getResponsiveValue(
      context: context,
      mobileValue: 26,
      tabletValue: 20,
    );

    return Selector<GameSingleDoubleTraining_P, SelectorModel>(
      selector: (_, game) => SelectorModel(
        currentFieldToHit: game.getCurrentFieldToHit,
        amountOfRoundsRemaining: game.getAmountOfRoundsRemaining,
      ),
      builder: (_, selectorModel, __) => Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Utils.getPrimaryColorDarken(context),
              width: GENERAL_BORDER_WIDTH.w,
            ),
            left: Utils.isLandscape(context)
                ? BorderSide(
                    color: Utils.getPrimaryColorDarken(context),
                    width: GENERAL_BORDER_WIDTH.w,
                  )
                : BorderSide.none,
            right: context
                        .read<GameSingleDoubleTraining_P>()
                        .getSafeAreaPadding
                        .right >
                    0
                ? BorderSide(
                    color: Utils.getPrimaryColorDarken(context),
                    width: GENERAL_BORDER_WIDTH.w,
                  )
                : BorderSide.none,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RichText(
                    text: TextSpan(
                      text: 'Field to hit: ',
                      style: TextStyle(
                        fontSize:
                            Theme.of(context).textTheme.titleLarge!.fontSize,
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text: _getFieldToHit(
                              selectorModel.currentFieldToHit.toString(),
                              context),
                          style: TextStyle(
                            fontSize: fontSizeFieldToHit.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            if (isTargetNumberEnabled)
              Container(
                transform: Matrix4.translationValues(0.0, -0.5.h, 0.0),
                padding: EdgeInsets.only(top: 0.3.h),
                child: Text(
                  '(Remaining rounds: ${selectorModel.amountOfRoundsRemaining})',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  String _getFieldToHit(String field, BuildContext context) {
    if (context.read<GameSingleDoubleTraining_P>().getMode ==
        GameMode.DoubleTraining) {
      field = 'D${field}';
    }

    return field;
  }
}

class SelectorModel {
  final int currentFieldToHit;
  final int amountOfRoundsRemaining;

  SelectorModel({
    required this.currentFieldToHit,
    required this.amountOfRoundsRemaining,
  });
}
