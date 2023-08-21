import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/x01/game_settings_x01_p.dart';
import 'package:dart_app/utils/globals.dart';
import 'package:dart_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:sizer/sizer.dart';

class MostScoredPointValue extends StatelessWidget {
  MostScoredPointValue({Key? key, required int this.i}) : super(key: key);

  final int i;
  final GlobalKey<FormState> _formKeyMostScoredPoint = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final GameSettingsX01_P gameSettingsX01 = context.read<GameSettingsX01_P>();

    return Container(
      width: 25.w,
      padding:
          ((i == 2 || i == 3) && ResponsiveBreakpoints.of(context).isTablet)
              ? EdgeInsets.only(
                  top: 1.h,
                  bottom: 1.h,
                )
              : null,
      child: Row(
        children: [
          Container(
            width: 6.w,
            child: Center(
              child: Text(
                '${i + 1}.',
                style: TextStyle(
                  fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          ElevatedButton(
            child: Container(
              alignment: Alignment.center,
              height: 4.h,
              width: 10.w,
              child: Text(
                gameSettingsX01.getMostScoredPoints[i],
                style: TextStyle(
                  color: Colors.white,
                  fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
                ),
              ),
            ),
            onPressed: () {
              Utils.handleVibrationFeedback(context);
              _showDialogForMostScoredPointInput(context, gameSettingsX01, i);
            },
            style: ButtonStyle(
              splashFactory: NoSplash.splashFactory,
              shadowColor: MaterialStateProperty.all(Colors.transparent),
              overlayColor: MaterialStateProperty.all(Colors.transparent),
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(
                  side: BorderSide(
                    color: Utils.getPrimaryColorDarken(context),
                    width: 0.5.w,
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(10.0),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _showDialogForMostScoredPointInput(
      BuildContext context, GameSettingsX01_P gameSettingsX01, int i) {
    newTextControllerForMostScoredPointGameSettingsX01(
        gameSettingsX01.getMostScoredPoints[i].toString());

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => Form(
        key: _formKeyMostScoredPoint,
        child: AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(DIALOG_SHAPE_ROUNDING),
          ),
          backgroundColor: Theme.of(context).colorScheme.primary,
          contentPadding: ResponsiveBreakpoints.of(context).isMobile
              ? DIALOG_CONTENT_PADDING_MOBILE
              : null,
          title: Text(
            'Enter a value',
            style: TextStyle(
              color: Colors.white,
              fontSize: Theme.of(context).textTheme.titleSmall!.fontSize,
            ),
          ),
          content: Container(
            width: DIALOG_SMALL_WIDTH.w,
            margin: EdgeInsets.only(
              left: 7.w,
              right: 7.w,
            ),
            child: TextFormField(
              controller: mostScoredPointController,
              validator: (value) {
                if (value!.isEmpty) {
                  return ('Please enter a value!');
                }
                if (int.parse(value) > 180) {
                  return ('Maximal value is 180!');
                }
                if (gameSettingsX01.getMostScoredPoints.contains(value)) {
                  return ('Value already defined!');
                }

                return null;
              },
              autofocus: true,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(3),
              ],
              textAlignVertical: TextAlignVertical.center,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
              ),
              decoration: InputDecoration(
                errorStyle: TextStyle(fontSize: DIALOG_ERROR_MSG_FONTSIZE.sp),
                hintText: 'Value',
                fillColor:
                    Utils.darken(Theme.of(context).colorScheme.primary, 10),
                filled: true,
                hintStyle: TextStyle(
                  fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
                  color: Utils.getPrimaryColorDarken(context),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(
                    width: 0,
                    style: BorderStyle.none,
                  ),
                ),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Utils.handleVibrationFeedback(context);
                Navigator.of(context).pop();
              },
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                  fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
                ),
              ),
              style: ButtonStyle(
                splashFactory: NoSplash.splashFactory,
                shadowColor: MaterialStateProperty.all(Colors.transparent),
                overlayColor: MaterialStateProperty.all(Colors.transparent),
                backgroundColor:
                    Utils.getPrimaryMaterialStateColorDarken(context),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(DIALOG_BTN_SHAPE_ROUNDING),
                  ),
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Utils.handleVibrationFeedback(context);
                _submitMostScoredPoint(context, i, gameSettingsX01);
              },
              child: Text(
                'Submit',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                  fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
                ),
              ),
              style: ButtonStyle(
                splashFactory: NoSplash.splashFactory,
                shadowColor: MaterialStateProperty.all(Colors.transparent),
                overlayColor: MaterialStateProperty.all(Colors.transparent),
                backgroundColor:
                    Utils.getPrimaryMaterialStateColorDarken(context),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(DIALOG_BTN_SHAPE_ROUNDING),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _submitMostScoredPoint(
      BuildContext context, int i, GameSettingsX01_P gameSettingsX01) {
    if (!_formKeyMostScoredPoint.currentState!.validate()) {
      return;
    }
    _formKeyMostScoredPoint.currentState!.save();

    gameSettingsX01.getMostScoredPoints[i] = mostScoredPointController.text;
    gameSettingsX01.notify();
    Navigator.of(context).pop();
    mostScoredPointController.clear();
  }
}
