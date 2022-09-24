import 'package:dart_app/constants.dart';
import 'package:dart_app/models/games/game_x01.dart';
import 'package:dart_app/models/player_statistics/player_game_statistics_x01.dart';
import 'package:dart_app/screens/game_modes/x01/game/local_widgets/three_darts/point_btn_three_darts.dart';
import 'package:dart_app/screens/game_modes/x01/game/local_widgets/revert_btn.dart';
import 'package:dart_app/screens/game_modes/x01/game/local_widgets/submit_points_btn.dart';
import 'package:dart_app/utils/utils.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class PointsBtnsThreeDarts extends StatelessWidget {
  const PointsBtnsThreeDarts({Key? key}) : super(key: key);

  bool _isBustClickable(GameX01 gameX01) {
    final PlayerGameStatisticsX01 stats =
        gameX01.getCurrentPlayerGameStatistics();
    final int currentPoints = stats.getCurrentPoints;

    if (gameX01.getAmountOfDartsThrown() == 0) {
      return true;
    }

    if (currentPoints <= 59 &&
        gameX01.getAmountOfDartsThrown() != 3 &&
        stats.getCurrentPoints != 0) {
      return true;
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    final gameX01 = Provider.of<GameX01>(context, listen: false);
    final PlayerGameStatisticsX01 stats =
        gameX01.getCurrentPlayerGameStatistics();

    return Expanded(
      child: Column(
        children: [
          Container(
            height: 6.h,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(
                      bottom: POINTS_BUTTON_MARGIN,
                    ),
                    child: ElevatedButton(
                      style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero,
                          ),
                        ),
                        backgroundColor: MaterialStateProperty.all(Utils.darken(
                            Theme.of(context).colorScheme.primary, 20)),
                        overlayColor:
                            MaterialStateProperty.all(Colors.transparent),
                      ),
                      child: FittedBox(
                        child: Text(
                          gameX01.getCurrentThreeDarts[0],
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      onPressed: () {
                        null;
                      },
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(
                      bottom: POINTS_BUTTON_MARGIN,
                      left: POINTS_BUTTON_MARGIN,
                    ),
                    child: ElevatedButton(
                      style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero,
                          ),
                        ),
                        backgroundColor: MaterialStateProperty.all(Utils.darken(
                            Theme.of(context).colorScheme.primary, 20)),
                        overlayColor:
                            MaterialStateProperty.all(Colors.transparent),
                      ),
                      child: FittedBox(
                        child: Text(
                          gameX01.getCurrentThreeDarts[1],
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      onPressed: () {
                        null;
                      },
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(
                      bottom: POINTS_BUTTON_MARGIN,
                      left: POINTS_BUTTON_MARGIN,
                    ),
                    child: ElevatedButton(
                      style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero,
                          ),
                        ),
                        backgroundColor: MaterialStateProperty.all(Utils.darken(
                            Theme.of(context).colorScheme.primary, 20)),
                        overlayColor:
                            MaterialStateProperty.all(Colors.transparent),
                      ),
                      child: FittedBox(
                        child: Text(
                          gameX01.getCurrentThreeDarts[2],
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      onPressed: () {
                        null;
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Container(
                      margin: const EdgeInsets.only(
                        bottom: POINTS_BUTTON_MARGIN,
                        right: POINTS_BUTTON_MARGIN,
                      ),
                      child: RevertBtn()),
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(
                      right: POINTS_BUTTON_MARGIN,
                      bottom: POINTS_BUTTON_MARGIN,
                    ),
                    child: gameX01.shouldPointBtnBeDisabled('25')
                        ? PointBtnThreeDart(
                            point: '25',
                            activeBtn: false,
                          )
                        : PointBtnThreeDart(
                            point: '25',
                            activeBtn: true,
                          ),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(
                      right: POINTS_BUTTON_MARGIN,
                      bottom: POINTS_BUTTON_MARGIN,
                    ),
                    child: gameX01.shouldPointBtnBeDisabled('Bull')
                        ? PointBtnThreeDart(
                            point: 'Bull',
                            activeBtn: false,
                          )
                        : PointBtnThreeDart(
                            point: 'Bull',
                            activeBtn: true,
                          ),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(
                      right: POINTS_BUTTON_MARGIN,
                      bottom: POINTS_BUTTON_MARGIN,
                    ),
                    child: ElevatedButton(
                      style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero,
                          ),
                        ),
                        backgroundColor: _isBustClickable(gameX01)
                            ? MaterialStateProperty.all(
                                Theme.of(context).colorScheme.primary)
                            : MaterialStateProperty.all(Utils.darken(
                                Theme.of(context).colorScheme.primary, 25)),
                        overlayColor: _isBustClickable(gameX01)
                            ? Utils.getColorOrPressed(
                                Theme.of(context).colorScheme.primary,
                                Utils.darken(
                                    Theme.of(context).colorScheme.primary, 15),
                              )
                            : MaterialStateProperty.all(Colors.transparent),
                      ),
                      child: FittedBox(
                        child: Text(
                          'Bust',
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      onPressed: () => {
                        if (_isBustClickable(gameX01)) gameX01.bust(context)
                      },
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(
                      right: POINTS_BUTTON_MARGIN,
                      bottom: POINTS_BUTTON_MARGIN,
                    ),
                    child: gameX01.shouldPointBtnBeDisabled('0')
                        ? PointBtnThreeDart(
                            point: '0',
                            activeBtn: false,
                          )
                        : PointBtnThreeDart(
                            point: '0',
                            activeBtn: true,
                          ),
                  ),
                ),
                if (!gameX01.getGameSettings.getAutomaticallySubmitPoints)
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(
                        bottom: POINTS_BUTTON_MARGIN,
                      ),
                      child: SubmitPointsBtn(),
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(
                      right: POINTS_BUTTON_MARGIN,
                      bottom: POINTS_BUTTON_MARGIN,
                    ),
                    child: gameX01.shouldPointBtnBeDisabled('1')
                        ? PointBtnThreeDart(
                            point: '1',
                            activeBtn: false,
                          )
                        : PointBtnThreeDart(
                            point: '1',
                            activeBtn: true,
                          ),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(
                      right: POINTS_BUTTON_MARGIN,
                      bottom: POINTS_BUTTON_MARGIN,
                    ),
                    child: gameX01.shouldPointBtnBeDisabled('2')
                        ? PointBtnThreeDart(
                            point: '2',
                            activeBtn: false,
                          )
                        : PointBtnThreeDart(
                            point: '2',
                            activeBtn: true,
                          ),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(
                      right: POINTS_BUTTON_MARGIN,
                      bottom: POINTS_BUTTON_MARGIN,
                    ),
                    child: gameX01.shouldPointBtnBeDisabled('3')
                        ? PointBtnThreeDart(
                            point: '3',
                            activeBtn: false,
                          )
                        : PointBtnThreeDart(
                            point: '3',
                            activeBtn: true,
                          ),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(
                      right: POINTS_BUTTON_MARGIN,
                      bottom: POINTS_BUTTON_MARGIN,
                    ),
                    child: gameX01.shouldPointBtnBeDisabled('4')
                        ? PointBtnThreeDart(
                            point: '4',
                            activeBtn: false,
                          )
                        : PointBtnThreeDart(
                            point: '4',
                            activeBtn: true,
                          ),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(
                      bottom: POINTS_BUTTON_MARGIN,
                    ),
                    child: gameX01.shouldPointBtnBeDisabled('5')
                        ? PointBtnThreeDart(
                            point: '5',
                            activeBtn: false,
                          )
                        : PointBtnThreeDart(
                            point: '5',
                            activeBtn: true,
                          ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(
                      right: POINTS_BUTTON_MARGIN,
                      bottom: POINTS_BUTTON_MARGIN,
                    ),
                    child: gameX01.shouldPointBtnBeDisabled('6')
                        ? PointBtnThreeDart(
                            point: '6',
                            activeBtn: false,
                          )
                        : PointBtnThreeDart(
                            point: '6',
                            activeBtn: true,
                          ),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(
                      right: POINTS_BUTTON_MARGIN,
                      bottom: POINTS_BUTTON_MARGIN,
                    ),
                    child: gameX01.shouldPointBtnBeDisabled('7')
                        ? PointBtnThreeDart(
                            point: '7',
                            activeBtn: false,
                          )
                        : PointBtnThreeDart(
                            point: '7',
                            activeBtn: true,
                          ),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(
                      right: POINTS_BUTTON_MARGIN,
                      bottom: POINTS_BUTTON_MARGIN,
                    ),
                    child: gameX01.shouldPointBtnBeDisabled('8')
                        ? PointBtnThreeDart(
                            point: '8',
                            activeBtn: false,
                          )
                        : PointBtnThreeDart(
                            point: '8',
                            activeBtn: true,
                          ),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(
                      right: POINTS_BUTTON_MARGIN,
                      bottom: POINTS_BUTTON_MARGIN,
                    ),
                    child: gameX01.shouldPointBtnBeDisabled('9')
                        ? PointBtnThreeDart(
                            point: '9',
                            activeBtn: false,
                          )
                        : PointBtnThreeDart(
                            point: '9',
                            activeBtn: true,
                          ),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(
                      bottom: POINTS_BUTTON_MARGIN,
                    ),
                    child: gameX01.shouldPointBtnBeDisabled('10')
                        ? PointBtnThreeDart(
                            point: '10',
                            activeBtn: false,
                          )
                        : PointBtnThreeDart(
                            point: '10',
                            activeBtn: true,
                          ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(
                      right: POINTS_BUTTON_MARGIN,
                      bottom: POINTS_BUTTON_MARGIN,
                    ),
                    child: gameX01.shouldPointBtnBeDisabled('11')
                        ? PointBtnThreeDart(
                            point: '11',
                            activeBtn: false,
                          )
                        : PointBtnThreeDart(
                            point: '11',
                            activeBtn: true,
                          ),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(
                      right: POINTS_BUTTON_MARGIN,
                      bottom: POINTS_BUTTON_MARGIN,
                    ),
                    child: gameX01.shouldPointBtnBeDisabled('12')
                        ? PointBtnThreeDart(
                            point: '12',
                            activeBtn: false,
                          )
                        : PointBtnThreeDart(
                            point: '12',
                            activeBtn: true,
                          ),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(
                      right: POINTS_BUTTON_MARGIN,
                      bottom: POINTS_BUTTON_MARGIN,
                    ),
                    child: gameX01.shouldPointBtnBeDisabled('13')
                        ? PointBtnThreeDart(
                            point: '13',
                            activeBtn: false,
                          )
                        : PointBtnThreeDart(
                            point: '13',
                            activeBtn: true,
                          ),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(
                      right: POINTS_BUTTON_MARGIN,
                      bottom: POINTS_BUTTON_MARGIN,
                    ),
                    child: gameX01.shouldPointBtnBeDisabled('14')
                        ? PointBtnThreeDart(
                            point: '14',
                            activeBtn: false,
                          )
                        : PointBtnThreeDart(
                            point: '14',
                            activeBtn: true,
                          ),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(
                      bottom: POINTS_BUTTON_MARGIN,
                    ),
                    child: gameX01.shouldPointBtnBeDisabled('15')
                        ? PointBtnThreeDart(
                            point: '15',
                            activeBtn: false,
                          )
                        : PointBtnThreeDart(
                            point: '15',
                            activeBtn: true,
                          ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(
                      right: POINTS_BUTTON_MARGIN,
                      bottom: POINTS_BUTTON_MARGIN,
                    ),
                    child: gameX01.shouldPointBtnBeDisabled('16')
                        ? PointBtnThreeDart(
                            point: '16',
                            activeBtn: false,
                          )
                        : PointBtnThreeDart(
                            point: '16',
                            activeBtn: true,
                          ),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(
                      right: POINTS_BUTTON_MARGIN,
                      bottom: POINTS_BUTTON_MARGIN,
                    ),
                    child: gameX01.shouldPointBtnBeDisabled('17')
                        ? PointBtnThreeDart(
                            point: '17',
                            activeBtn: false,
                          )
                        : PointBtnThreeDart(
                            point: '17',
                            activeBtn: true,
                          ),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(
                      right: POINTS_BUTTON_MARGIN,
                      bottom: POINTS_BUTTON_MARGIN,
                    ),
                    child: gameX01.shouldPointBtnBeDisabled('18')
                        ? PointBtnThreeDart(
                            point: '18',
                            activeBtn: false,
                          )
                        : PointBtnThreeDart(
                            point: '18',
                            activeBtn: true,
                          ),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(
                      right: POINTS_BUTTON_MARGIN,
                      bottom: POINTS_BUTTON_MARGIN,
                    ),
                    child: gameX01.shouldPointBtnBeDisabled('19')
                        ? PointBtnThreeDart(
                            point: '19',
                            activeBtn: false,
                          )
                        : PointBtnThreeDart(
                            point: '19',
                            activeBtn: true,
                          ),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(
                      bottom: POINTS_BUTTON_MARGIN,
                    ),
                    child: gameX01.shouldPointBtnBeDisabled('20')
                        ? PointBtnThreeDart(
                            point: '20',
                            activeBtn: false,
                          )
                        : PointBtnThreeDart(
                            point: '20',
                            activeBtn: true,
                          ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(
                      right: POINTS_BUTTON_MARGIN,
                      bottom: POINTS_BUTTON_MARGIN,
                    ),
                    child: ElevatedButton(
                      style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero,
                          ),
                        ),
                        backgroundColor:
                            gameX01.getCurrentPointType == PointType.Single ||
                                    stats.getCurrentPoints == 0 ||
                                    gameX01.getAmountOfDartsThrown() == 3
                                ? MaterialStateProperty.all(Utils.darken(
                                    Theme.of(context).colorScheme.primary, 25))
                                : MaterialStateProperty.all(
                                    Theme.of(context).colorScheme.primary),
                        overlayColor: gameX01.getCurrentPointType ==
                                    PointType.Single ||
                                stats.getCurrentPoints == 0 ||
                                gameX01.getAmountOfDartsThrown() == 3
                            ? MaterialStateProperty.all(Colors.transparent)
                            : Utils.getColorOrPressed(
                                Theme.of(context).colorScheme.primary,
                                Utils.darken(
                                    Theme.of(context).colorScheme.primary, 15),
                              ),
                      ),
                      child: FittedBox(
                        child: const Text(
                          'Single',
                          style: TextStyle(
                            fontSize: THREE_DARTS_BUTTON_TEXT_SIZE,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      onPressed: () {
                        if (stats.getCurrentPoints != 0 &&
                            gameX01.getAmountOfDartsThrown() != 3) {
                          gameX01.setCurrentPointType = PointType.Single;
                          gameX01.notify();
                        }
                      },
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(
                      right: POINTS_BUTTON_MARGIN,
                      bottom: POINTS_BUTTON_MARGIN,
                    ),
                    child: ElevatedButton(
                      style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero,
                          ),
                        ),
                        backgroundColor:
                            gameX01.getCurrentPointType == PointType.Double ||
                                    stats.getCurrentPoints == 0 ||
                                    gameX01.getAmountOfDartsThrown() == 3
                                ? MaterialStateProperty.all(Utils.darken(
                                    Theme.of(context).colorScheme.primary, 25))
                                : MaterialStateProperty.all(
                                    Theme.of(context).colorScheme.primary),
                        overlayColor: gameX01.getCurrentPointType ==
                                    PointType.Double ||
                                stats.getCurrentPoints == 0 ||
                                gameX01.getAmountOfDartsThrown() == 3
                            ? MaterialStateProperty.all(Colors.transparent)
                            : Utils.getColorOrPressed(
                                Theme.of(context).colorScheme.primary,
                                Utils.darken(
                                    Theme.of(context).colorScheme.primary, 15),
                              ),
                      ),
                      child: FittedBox(
                        child: const Text(
                          'Double',
                          style: TextStyle(
                            fontSize: THREE_DARTS_BUTTON_TEXT_SIZE,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      onPressed: () {
                        if (stats.getCurrentPoints != 0 &&
                            gameX01.getAmountOfDartsThrown() != 3) {
                          gameX01.setCurrentPointType = PointType.Double;
                          gameX01.notify();
                        }
                      },
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(
                      right: POINTS_BUTTON_MARGIN,
                      bottom: POINTS_BUTTON_MARGIN,
                    ),
                    child: ElevatedButton(
                      style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero,
                          ),
                        ),
                        backgroundColor:
                            gameX01.getCurrentPointType == PointType.Tripple ||
                                    stats.getCurrentPoints == 0 ||
                                    gameX01.getAmountOfDartsThrown() == 3
                                ? MaterialStateProperty.all(Utils.darken(
                                    Theme.of(context).colorScheme.primary, 25))
                                : MaterialStateProperty.all(
                                    Theme.of(context).colorScheme.primary),
                        overlayColor: gameX01.getCurrentPointType ==
                                    PointType.Tripple ||
                                stats.getCurrentPoints == 0 ||
                                gameX01.getAmountOfDartsThrown() == 3
                            ? MaterialStateProperty.all(Colors.transparent)
                            : Utils.getColorOrPressed(
                                Theme.of(context).colorScheme.primary,
                                Utils.darken(
                                    Theme.of(context).colorScheme.primary, 15),
                              ),
                      ),
                      child: FittedBox(
                        child: const Text(
                          'Tripple',
                          style: TextStyle(
                            fontSize: THREE_DARTS_BUTTON_TEXT_SIZE,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      onPressed: () {
                        if (stats.getCurrentPoints != 0 &&
                            gameX01.getAmountOfDartsThrown() != 3) {
                          gameX01.setCurrentPointType = PointType.Tripple;
                          gameX01.notify();
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
