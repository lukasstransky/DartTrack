import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/game_settings_x01.dart';
import 'package:dart_app/models/games/game_x01.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class SelectInputMethod extends StatelessWidget {
  const SelectInputMethod({Key? key}) : super(key: key);

  _switchInputMethod(BuildContext context) {
    final gameX01 = context.read<GameX01>();
    final gameSettingsX01 = context.read<GameSettingsX01>();

    if (gameSettingsX01.getInputMethod == InputMethod.Round) {
      gameSettingsX01.setInputMethod = InputMethod.ThreeDarts;
    } else {
      if (gameX01.getAmountOfDartsThrown() != 0) {
        Fluttertoast.showToast(
            msg: 'In order to switch, please finish the round!',
            toastLength: Toast.LENGTH_LONG);
      } else {
        gameSettingsX01.setInputMethod = InputMethod.Round;
      }
    }

    gameSettingsX01.notify();
  }

  @override
  Widget build(BuildContext context) {
    final inputMethod = context.read<GameSettingsX01>().getInputMethod;

    return Column(
      children: [
        Container(
          height: 4.h,
          padding: EdgeInsets.only(left: 5.w, right: 5.w),
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () => {
                    if (inputMethod == InputMethod.ThreeDarts)
                      _switchInputMethod(context)
                  },
                  child: FittedBox(
                    fit: BoxFit.fitWidth,
                    child: const Text('Round'),
                  ),
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10.0),
                          bottomLeft: Radius.circular(10.0),
                        ),
                      ),
                    ),
                    backgroundColor: inputMethod == InputMethod.Round
                        ? MaterialStateProperty.all(
                            Theme.of(context).colorScheme.primary)
                        : MaterialStateProperty.all<Color>(Colors.grey),
                    overlayColor: inputMethod == InputMethod.Round
                        ? MaterialStateProperty.all<Color>(Colors.transparent)
                        : MaterialStateProperty.all(
                            Theme.of(context).colorScheme.primary),
                    splashFactory: inputMethod == InputMethod.Round
                        ? NoSplash.splashFactory
                        : InkRipple.splashFactory,
                    shadowColor: MaterialStateProperty.all(Colors.transparent),
                  ),
                ),
              ),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    if (inputMethod == InputMethod.Round)
                      _switchInputMethod(context);
                  },
                  child: FittedBox(
                    fit: BoxFit.fitWidth,
                    child: const Text('3 Darts'),
                  ),
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(10.0),
                          bottomRight: Radius.circular(10.0),
                        ),
                      ),
                    ),
                    backgroundColor: inputMethod == InputMethod.ThreeDarts
                        ? MaterialStateProperty.all(
                            Theme.of(context).colorScheme.primary)
                        : MaterialStateProperty.all<Color>(Colors.grey),
                    overlayColor: inputMethod == InputMethod.ThreeDarts
                        ? MaterialStateProperty.all<Color>(Colors.transparent)
                        : MaterialStateProperty.all(
                            Theme.of(context).colorScheme.primary),
                    splashFactory: inputMethod == InputMethod.ThreeDarts
                        ? NoSplash.splashFactory
                        : InkRipple.splashFactory,
                    shadowColor: MaterialStateProperty.all(Colors.transparent),
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          height: 6.h,
          padding: EdgeInsets.only(left: 2.5.w),
          child: inputMethod == InputMethod.Round
              ? Center(
                  child: RichText(
                    text: TextSpan(
                      style: new TextStyle(
                        fontSize: 11.0.sp,
                        color: Colors.black,
                      ),
                      children: <TextSpan>[
                        new TextSpan(
                            text:
                                'Enter a complete round. This approach provides '),
                        new TextSpan(
                            text: 'less',
                            style: new TextStyle(fontWeight: FontWeight.bold)),
                        new TextSpan(text: ' statistics.'),
                      ],
                    ),
                  ),
                )
              : Center(
                  child: RichText(
                    text: TextSpan(
                      style: new TextStyle(
                        fontSize: 11.0.sp,
                        color: Colors.black,
                      ),
                      children: <TextSpan>[
                        new TextSpan(
                            text: 'Enter each Dart seperately. As a result '),
                        new TextSpan(
                            text: 'more',
                            style: new TextStyle(fontWeight: FontWeight.bold)),
                        new TextSpan(text: ' statistics are available.'),
                      ],
                    ),
                  ),
                ),
        ),
      ],
    );
  }
}
