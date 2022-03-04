import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/game_settings_x01_model.dart';
import 'package:dart_app/models/games/game_x01_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class CustomAppBarGameX01 extends StatelessWidget with PreferredSizeWidget {
  final GameSettingsX01 _gameSettingsX01;

  const CustomAppBarGameX01(this._gameSettingsX01);

  String getTitle(GameSettingsX01 gameSettingsX01) {
    String result = "";
    if (gameSettingsX01.getMode == BestOfOrFirstTo.BestOf)
      result += "Best Of ";
    else
      result += "First To ";

    if (gameSettingsX01.getSetsEnabled)
      result += gameSettingsX01.getSets.toString() +
          " Sets - " +
          gameSettingsX01.getLegs.toString() +
          " Legs";
    else
      result += gameSettingsX01.getLegs.toString() + " Legs";

    return result;
  }

  String getSubTitle(GameSettingsX01 gameSettingsX01) {
    String result = "";
    if (gameSettingsX01.getModeIn == SingleOrDouble.SingleField)
      result += "Single In / ";
    else
      result += "Double In / ";

    if (gameSettingsX01.getModeOut == SingleOrDouble.SingleField)
      result += "Single Out";
    else
      result += "Double Out";

    if (gameSettingsX01.getSuddenDeath)
      result += " / SD - after " +
          gameSettingsX01.getMaxExtraLegs.toString() +
          " Legs";

    return result;
  }

  @override
  Widget build(BuildContext context) {
    final gameX01 = Provider.of<GameX01>(context, listen: false);

    return AppBar(
      centerTitle: true,
      title: Column(
        children: [
          Text(
            getTitle(this._gameSettingsX01),
            style: TextStyle(fontSize: 12.sp),
          ),
          Text(
            getSubTitle(this._gameSettingsX01),
            style: TextStyle(
                fontSize: _gameSettingsX01.getSuddenDeath ? 8.sp : 10.sp),
          )
        ],
      ),
      leading: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            onPressed: () {
              gameX01.reset();
              Navigator.of(context).pushNamed("/settingsX01");
            },
            icon: Icon(Icons.close_sharp),
          )
        ],
      ),
      actions: [
        IconButton(
          onPressed: () => {
            Navigator.of(context).pushNamed("/statisticsX01"),
          },
          icon: Icon(Icons.bar_chart_rounded),
        ),
        IconButton(
          onPressed: () =>
              Navigator.of(context).pushNamed("/inGameSettingsX01"),
          icon: Icon(Icons.settings),
        )
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
