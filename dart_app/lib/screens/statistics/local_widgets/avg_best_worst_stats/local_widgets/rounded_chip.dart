import 'package:dart_app/utils/button_styles.dart';
import 'package:dart_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class RoundedChip extends StatelessWidget {
  const RoundedChip({
    Key? key,
    required this.value,
    required this.type,
    this.darkenBackground = false,
  }) : super(key: key);

  final String value;
  final String type;
  final bool darkenBackground;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 3.5.h,
      padding: EdgeInsets.only(
        left: 1.w,
        right: 1.w,
      ),
      child: GestureDetector(
        child: ElevatedButton(
          onPressed: () {
            if (type != '') {
              Utils.handleVibrationFeedback(context);
            }

            if (this.type != '' && this.value != '-') {
              Navigator.of(context).pushNamed('/statsPerGameFilteredList',
                  arguments: {'type': this.type});
            }
          },
          child: FittedBox(
            fit: BoxFit.fitWidth,
            child: Text(
              value,
              style: TextStyle(
                color: Colors.white,
                fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
              ),
            ),
          ),
          style: ButtonStyles.anyColorBtnStyle(
                  context,
                  Utils.darken(Theme.of(context).colorScheme.primary,
                      darkenBackground ? 25 : 15),
                  darkenBackground)
              .copyWith(
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(10.0),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
