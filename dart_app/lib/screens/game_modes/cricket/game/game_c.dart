import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/game_settings_cricket_p.dart';
import 'package:dart_app/models/games/game_cricket_p.dart';
import 'package:dart_app/screens/game_modes/cricket/game/local_widgets/game_field/game_field_c.dart';
import 'package:dart_app/screens/game_modes/cricket/game/local_widgets/submit_revert_btns_c.dart';
import 'package:dart_app/screens/game_modes/shared/game/point_btns_three_darts/local_widgets/single_double_or_tripple.dart';
import 'package:dart_app/screens/game_modes/shared/game/point_btns_three_darts/local_widgets/sixteen_to_twenty.dart';
import 'package:dart_app/screens/game_modes/shared/game/point_btns_three_darts/local_widgets/thrown_darts.dart';
import 'package:dart_app/utils/app_bars/custom_app_bar_game.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class GameCricket extends StatefulWidget {
  static const routeName = '/gameCricket';

  GameCricket({Key? key}) : super(key: key);

  @override
  State<GameCricket> createState() => _GameCricketState();
}

class _GameCricketState extends State<GameCricket> {
  @override
  void didChangeDependencies() {
    final Map arguments = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;

    // only init game for new game, not for open game
    if (arguments.isNotEmpty && !arguments['openGame']) {
      context.read<GameCricket_P>().init(context.read<GameSettingsCricket_P>());
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false, // ignore gestures
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: CustomAppBarGame(mode: GameMode.Cricket),
        body: Selector<GameCricket_P, bool>(
          selector: (_, game) => game.getShowLoadingSpinner,
          builder: (_, showLoadingSpinner, __) => showLoadingSpinner
              ? Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                )
              : Column(
                  children: [
                    GameFieldCricket(),
                    ThrownDarts(mode: GameMode.Cricket),
                    SubmitRevertnBtnsCricket(),
                    Selector<GameCricket_P, SelectorModel>(
                      selector: (_, gameCricket) => SelectorModel(
                        currentThreeDarts: gameCricket.getCurrentThreeDarts,
                        pointType: gameCricket.getCurrentPointType,
                      ),
                      builder: (_, currentPointType, __) =>
                          SixteenToTwentyBtnsThreeDarts(mode: GameMode.Cricket),
                    ),
                    Selector<GameCricket_P, SelectorModel>(
                      selector: (_, gameCricket) => SelectorModel(
                        currentThreeDarts: gameCricket.getCurrentThreeDarts,
                        pointType: gameCricket.getCurrentPointType,
                      ),
                      builder: (_, currentPointType, __) => Container(
                        height: _getHeightForSingleDoubleTrippleBtns(),
                        child: SingleDoubleOrTrippleBtns(
                          mode: GameMode.Cricket,
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  double _getHeightForSingleDoubleTrippleBtns() {
    final CricketMode mode =
        context.read<GameCricket_P>().getGameSettings.getMode;

    if (mode == CricketMode.NoScore) {
      return 8.h;
    }
    return 6.h;
  }
}

class SelectorModel {
  final PointType pointType;
  final List<String> currentThreeDarts;

  SelectorModel({
    required this.pointType,
    required this.currentThreeDarts,
  });
}
