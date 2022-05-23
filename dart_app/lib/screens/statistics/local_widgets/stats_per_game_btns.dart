import 'package:dart_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class StatsPerGameBtns extends StatelessWidget {
  const StatsPerGameBtns({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: 10),
          child: Text(
            "Stats per Game",
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Container(
          width: 40.w,
          child: ElevatedButton(
            onPressed: () => {
              Navigator.of(context)
                  .pushNamed("/statsPerGameList", arguments: {"mode": "X01"}),
            },
            child: FittedBox(
              fit: BoxFit.fitWidth,
              child: const Text("X01"),
            ),
            style: ButtonStyle(
              shadowColor: MaterialStateProperty.all(Colors.transparent),
              overlayColor: Utils.getColor(
                Theme.of(context).colorScheme.primary,
                Utils.darken(Theme.of(context).colorScheme.primary, 15),
              ),
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10.0),
                  ),
                ),
              ),
              backgroundColor: MaterialStateProperty.all(
                  Theme.of(context).colorScheme.primary),
            ),
          ),
        ),
        Container(
          width: 40.w,
          child: ElevatedButton(
            onPressed: () => {
              Navigator.of(context).pushNamed("/statsPerGameList",
                  arguments: {"mode": "Cricket"}),
            },
            child: FittedBox(
              fit: BoxFit.fitWidth,
              child: const Text("Cricket"),
            ),
            style: ButtonStyle(
              shadowColor: MaterialStateProperty.all(Colors.transparent),
              overlayColor: Utils.getColor(
                Theme.of(context).colorScheme.primary,
                Utils.darken(Theme.of(context).colorScheme.primary, 15),
              ),
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10.0),
                  ),
                ),
              ),
              backgroundColor: MaterialStateProperty.all(
                  Theme.of(context).colorScheme.primary),
            ),
          ),
        ),
        Container(
          width: 40.w,
          child: ElevatedButton(
            onPressed: () => {
              Navigator.of(context).pushNamed("/statsPerGameList",
                  arguments: {"mode": "Singles Training"}),
            },
            child: FittedBox(
              fit: BoxFit.fitWidth,
              child: const Text("Singles Training"),
            ),
            style: ButtonStyle(
              shadowColor: MaterialStateProperty.all(Colors.transparent),
              overlayColor: Utils.getColor(
                Theme.of(context).colorScheme.primary,
                Utils.darken(Theme.of(context).colorScheme.primary, 15),
              ),
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10.0),
                  ),
                ),
              ),
              backgroundColor: MaterialStateProperty.all(
                  Theme.of(context).colorScheme.primary),
            ),
          ),
        ),
        Container(
          width: 40.w,
          child: ElevatedButton(
            onPressed: () => {
              Navigator.of(context).pushNamed("/statsPerGameList",
                  arguments: {"mode": "Doubles Training"}),
            },
            child: FittedBox(
              fit: BoxFit.fitWidth,
              child: const Text("Doubles Training"),
            ),
            style: ButtonStyle(
              shadowColor: MaterialStateProperty.all(Colors.transparent),
              overlayColor: Utils.getColor(
                Theme.of(context).colorScheme.primary,
                Utils.darken(Theme.of(context).colorScheme.primary, 15),
              ),
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10.0),
                  ),
                ),
              ),
              backgroundColor: MaterialStateProperty.all(
                  Theme.of(context).colorScheme.primary),
            ),
          ),
        ),
      ],
    );
  }
}
