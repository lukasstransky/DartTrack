import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/game_settings_x01.dart';
import 'package:dart_app/utils/utils.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class BestOfOrFirstTo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Consumer<GameSettingsX01>(
        builder: (_, gameSettingsX01, __) => Container(
          width: WIDTH_GAMESETTINGS.w,
          height: Utils.getHeightForWidget(gameSettingsX01).h,
          margin: EdgeInsets.only(top: MARGIN_GAMESETTINGS.h),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border(
                      right: BorderSide(width: 1.0, color: Colors.white),
                    ),
                    color: Colors.white,
                  ),
                  child: ElevatedButton(
                    onPressed: () =>
                        gameSettingsX01.getMode == BestOfOrFirstToEnum.FirstTo
                            ? gameSettingsX01.switchBestOfOrFirstTo()
                            : null,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: const Text('Best Of'),
                    ),
                    style: ButtonStyle(
                      splashFactory:
                          gameSettingsX01.getMode == BestOfOrFirstToEnum.BestOf
                              ? NoSplash.splashFactory
                              : InkRipple.splashFactory,
                      shadowColor:
                          MaterialStateProperty.all(Colors.transparent),
                      overlayColor:
                          gameSettingsX01.getMode == BestOfOrFirstToEnum.BestOf
                              ? MaterialStateProperty.all(Colors.transparent)
                              : Utils.getDefaultOverlayColor(context),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(BUTTON_BORDER_RADIUS),
                            bottomLeft: Radius.circular(BUTTON_BORDER_RADIUS),
                          ),
                        ),
                      ),
                      backgroundColor:
                          gameSettingsX01.getMode == BestOfOrFirstToEnum.BestOf
                              ? Utils.getColor(
                                  Theme.of(context).colorScheme.primary)
                              : Utils.getColor(Colors.grey),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: SizedBox(
                  child: ElevatedButton(
                    onPressed: () =>
                        gameSettingsX01.getMode == BestOfOrFirstToEnum.BestOf
                            ? gameSettingsX01.switchBestOfOrFirstTo()
                            : null,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: const Text('First To'),
                    ),
                    style: ButtonStyle(
                      splashFactory:
                          gameSettingsX01.getMode == BestOfOrFirstToEnum.FirstTo
                              ? NoSplash.splashFactory
                              : InkRipple.splashFactory,
                      shadowColor:
                          MaterialStateProperty.all(Colors.transparent),
                      overlayColor:
                          gameSettingsX01.getMode == BestOfOrFirstToEnum.FirstTo
                              ? MaterialStateProperty.all(Colors.transparent)
                              : Utils.getDefaultOverlayColor(context),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(BUTTON_BORDER_RADIUS),
                            bottomRight: Radius.circular(BUTTON_BORDER_RADIUS),
                          ),
                        ),
                      ),
                      backgroundColor:
                          gameSettingsX01.getMode == BestOfOrFirstToEnum.FirstTo
                              ? Utils.getColor(
                                  Theme.of(context).colorScheme.primary)
                              : Utils.getColor(Colors.grey),
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
