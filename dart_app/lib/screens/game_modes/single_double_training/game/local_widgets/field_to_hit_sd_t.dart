import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/game_settings_single_double_training_p.dart';
import 'package:dart_app/models/games/game_single_double_training_p.dart';
import 'package:dart_app/utils/utils.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:sizer/sizer.dart';

class FieldToHitSingleDoubleTraining extends StatelessWidget {
  const FieldToHitSingleDoubleTraining({Key? key}) : super(key: key);

  String _getFieldToHit(String field, BuildContext context) {
    if (context.read<GameSingleDoubleTraining_P>().getMode ==
        GameMode.DoubleTraining) {
      field = 'D${field}';
    }

    return field;
  }

  double _getHeight(
      BuildContext context, int currentFieldToHit, bool isTargetNumberEnabled) {
    if (ResponsiveBreakpoints.of(context).isMobile) {
      if (isTargetNumberEnabled) {
        return 8.h;
      } else if (currentFieldToHit == -1) {
        return 6.h;
      }
      return 6.h;
    } else {
      // tablet
      if (isTargetNumberEnabled) {
        return 10.h;
      } else if (currentFieldToHit == -1) {
        return 8.h;
      }
      return 7.h;
    }
  }

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
        height: _getHeight(
            context, selectorModel.currentFieldToHit, isTargetNumberEnabled),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Utils.getPrimaryColorDarken(context),
              width: GENERAL_BORDER_WIDTH.w,
            ),
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
}

class SelectorModel {
  final int currentFieldToHit;
  final int amountOfRoundsRemaining;

  SelectorModel({
    required this.currentFieldToHit,
    required this.amountOfRoundsRemaining,
  });
}
