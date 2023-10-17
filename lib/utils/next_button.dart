import 'package:easy_localization/easy_localization.dart';
import 'package:fitness/utils/colors.dart';
import 'package:fitness/utils/words.dart';
import 'package:flutter/material.dart';

import 'Routes.dart';

Widget next(BuildContext context, String screen, bool isActive, Function() pressed, {String? text, double wide = 300, Object? argument}) {
  return Center(
      child: isActive ? Container(
    width: wide,
    height: 60,
    decoration: const ShapeDecoration(
      shape: StadiumBorder(),
      gradient: linearGradient,
    ),
    child: MaterialButton(
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      shape: const StadiumBorder(),
      child: Text(
        screen == genderScreen ? imReady.tr() : text ?? nextS.tr(),
        style: const TextStyle(fontSize: 20, color: Colors.white),
      ),
      onPressed: () {
        pressed();
        changeScreen(screen, context, argument: argument);
      },
    ),
  ) : Container(
        width: 300,
        height: 60,
        decoration: const ShapeDecoration(
          shape: StadiumBorder(),
          color: Colors.grey,
        ),
        child: MaterialButton(
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          shape: const StadiumBorder(),
          child: Text(
            screen == genderScreen ? imReady.tr() : nextS.tr(),
            style: const TextStyle(fontSize: 20, color: Colors.white),
          ),
          onPressed: () {

          },
        ),
      ));
}
