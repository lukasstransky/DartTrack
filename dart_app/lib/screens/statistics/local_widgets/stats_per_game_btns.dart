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
                  .pushNamed("/statsPerGame", arguments: {"mode": "X01"}),
            },
            child: FittedBox(
              fit: BoxFit.fitWidth,
              child: const Text("X01"),
            ),
            style: ButtonStyle(
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
              Navigator.of(context)
                  .pushNamed("/statsPerGame", arguments: {"mode": "Cricket"}),
            },
            child: FittedBox(
              fit: BoxFit.fitWidth,
              child: const Text("Cricket"),
            ),
            style: ButtonStyle(
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
              Navigator.of(context).pushNamed("/statsPerGame",
                  arguments: {"mode": "Singles Training"}),
            },
            child: FittedBox(
              fit: BoxFit.fitWidth,
              child: const Text("Singles Training"),
            ),
            style: ButtonStyle(
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
              Navigator.of(context).pushNamed("/statsPerGame",
                  arguments: {"mode": "Doubles Training"}),
            },
            child: FittedBox(
              fit: BoxFit.fitWidth,
              child: const Text("Doubles Training"),
            ),
            style: ButtonStyle(
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
