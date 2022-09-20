import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/game_settings_x01.dart';
import 'package:dart_app/utils/utils.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class ModeOut extends StatelessWidget {
  _singleOutClicked(GameSettingsX01 gameSettingsX01) {
    gameSettingsX01.setModeOut = ModeOutIn.Single;
    gameSettingsX01.setEnableCheckoutCounting = false;
    gameSettingsX01.notify();
  }

  _doubleOutClicked(GameSettingsX01 gameSettingsX01) {
    gameSettingsX01.setEnableCheckoutCounting = false;
    gameSettingsX01.setModeOut = ModeOutIn.Double;
    gameSettingsX01.notify();
  }

  _masterOutClicked(GameSettingsX01 gameSettingsX01) {
    gameSettingsX01.setModeOut = ModeOutIn.Master;
    gameSettingsX01.setEnableCheckoutCounting = false;
    gameSettingsX01.notify();
  }

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
                child: SizedBox(
                  child: ElevatedButton(
                    onPressed: () => _singleOutClicked(gameSettingsX01),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: const Text('Single Out'),
                    ),
                    style: ButtonStyle(
                      splashFactory:
                          gameSettingsX01.getModeOut == ModeOutIn.Single
                              ? NoSplash.splashFactory
                              : InkRipple.splashFactory,
                      shadowColor:
                          MaterialStateProperty.all(Colors.transparent),
                      overlayColor:
                          gameSettingsX01.getModeOut == ModeOutIn.Single
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
                          gameSettingsX01.getModeOut == ModeOutIn.Single
                              ? Utils.getColor(
                                  Theme.of(context).colorScheme.primary)
                              : Utils.getColor(Colors.grey),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border(
                      left: BorderSide(width: 1.0, color: Colors.white),
                      right: BorderSide(width: 1.0, color: Colors.white),
                    ),
                    color: Colors.white,
                  ),
                  child: ElevatedButton(
                    onPressed: () => _doubleOutClicked(gameSettingsX01),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: const Text('Double Out'),
                    ),
                    style: ButtonStyle(
                      splashFactory:
                          gameSettingsX01.getModeOut == ModeOutIn.Double
                              ? NoSplash.splashFactory
                              : InkRipple.splashFactory,
                      shadowColor:
                          MaterialStateProperty.all(Colors.transparent),
                      overlayColor:
                          gameSettingsX01.getModeOut == ModeOutIn.Double
                              ? MaterialStateProperty.all(Colors.transparent)
                              : Utils.getDefaultOverlayColor(context),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.zero),
                        ),
                      ),
                      backgroundColor:
                          gameSettingsX01.getModeOut == ModeOutIn.Double
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
                    onPressed: () => _masterOutClicked(gameSettingsX01),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: const Text('Master Out'),
                    ),
                    style: ButtonStyle(
                      splashFactory:
                          gameSettingsX01.getModeOut == ModeOutIn.Master
                              ? NoSplash.splashFactory
                              : InkRipple.splashFactory,
                      shadowColor:
                          MaterialStateProperty.all(Colors.transparent),
                      overlayColor:
                          gameSettingsX01.getModeOut == ModeOutIn.Master
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
                          gameSettingsX01.getModeOut == ModeOutIn.Master
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
