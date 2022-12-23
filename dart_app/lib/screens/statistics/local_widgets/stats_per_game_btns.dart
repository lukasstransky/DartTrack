import 'package:dart_app/constants.dart';
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
            'Stats per Game',
            style: TextStyle(fontSize: 16.sp, color: Colors.white),
          ),
        ),
        X01Btn(),
        CricketBtn(),
        SinglesTrainingBtn(),
        DoublesTrainingBtn(),
      ],
    );
  }
}

class DoublesTrainingBtn extends StatelessWidget {
  const DoublesTrainingBtn({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40.w,
      child: ElevatedButton(
        onPressed: () => Navigator.of(context).pushNamed('/statsPerGameList',
            arguments: {'mode': 'Doubles Training'}),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            'Doubles Training',
            style: TextStyle(
                fontSize: 10.sp,
                color: Theme.of(context).colorScheme.secondary),
          ),
        ),
        style: ButtonStyle(
          shadowColor: MaterialStateProperty.all(Colors.transparent),
          overlayColor: Utils.getColorOrPressed(
            Theme.of(context).colorScheme.primary,
            Utils.darken(Theme.of(context).colorScheme.primary, 15),
          ),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(12.0),
              ),
            ),
          ),
          backgroundColor: MaterialStateProperty.all(
            Utils.darken(Theme.of(context).colorScheme.primary, GENERAL_DARKEN),
          ),
        ),
      ),
    );
  }
}

class SinglesTrainingBtn extends StatelessWidget {
  const SinglesTrainingBtn({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40.w,
      child: ElevatedButton(
        onPressed: () => Navigator.of(context).pushNamed('/statsPerGameList',
            arguments: {'mode': 'Singles Training'}),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            'Singles Training',
            style: TextStyle(
                fontSize: 12.sp,
                color: Theme.of(context).colorScheme.secondary),
          ),
        ),
        style: ButtonStyle(
          shadowColor: MaterialStateProperty.all(Colors.transparent),
          overlayColor: Utils.getColorOrPressed(
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
            Utils.darken(Theme.of(context).colorScheme.primary, GENERAL_DARKEN),
          ),
        ),
      ),
    );
  }
}

class CricketBtn extends StatelessWidget {
  const CricketBtn({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40.w,
      child: ElevatedButton(
        onPressed: () => Navigator.of(context)
            .pushNamed('/statsPerGameList', arguments: {'mode': 'Cricket'}),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            'Cricket',
            style: TextStyle(
                fontSize: 12.sp,
                color: Theme.of(context).colorScheme.secondary),
          ),
        ),
        style: ButtonStyle(
          shadowColor: MaterialStateProperty.all(Colors.transparent),
          overlayColor: Utils.getColorOrPressed(
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
            Utils.darken(Theme.of(context).colorScheme.primary, GENERAL_DARKEN),
          ),
        ),
      ),
    );
  }
}

class X01Btn extends StatelessWidget {
  const X01Btn({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40.w,
      child: ElevatedButton(
        onPressed: () => Navigator.of(context)
            .pushNamed('/statsPerGameList', arguments: {'mode': 'X01'}),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            'X01',
            style: TextStyle(
                fontSize: 12.sp,
                color: Theme.of(context).colorScheme.secondary),
          ),
        ),
        style: ButtonStyle(
          shadowColor: MaterialStateProperty.all(Colors.transparent),
          overlayColor: Utils.getColorOrPressed(
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
            Utils.darken(Theme.of(context).colorScheme.primary, GENERAL_DARKEN),
          ),
        ),
      ),
    );
  }
}
