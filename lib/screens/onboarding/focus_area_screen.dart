import 'package:easy_localization/easy_localization.dart';
import 'package:fitness/custom_widgets/check_box_list.dart';
import 'package:fitness/model/custom_check_box_model.dart';
import 'package:fitness/utils/Routes.dart';
import 'package:fitness/utils/const.dart';
import 'package:fitness/utils/words.dart';
import 'package:flutter/material.dart';

import '../../model/user_info_enums.dart';
import '../../utils/back_button.dart';
import '../../utils/next_button.dart';

class FocusAreaScreen extends StatefulWidget {
  const FocusAreaScreen({Key? key}) : super(key: key);

  @override
  State<FocusAreaScreen> createState() => _FocusAreaScreenState();
}

class _FocusAreaScreenState extends State<FocusAreaScreen> {
  bool isNextActive = false;
  late MenuListView menuList;
  List<CheckBoxState> list = [];
  final List<FocusArea> _focusArea = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(flex: 2, child: backButton(context)),
              Expanded(
                  flex: 3,
                  child: Image.asset(
                    "assets/images/onboard_2.png",
                    alignment: Alignment.centerLeft,
                  ))
            ],
          ),
          Text(
            focusArea.tr(),
            style: const TextStyle(
                color: Colors.black, fontWeight: FontWeight.w900, fontSize: onboardingTextSize),
          ),
          // MenuGridView(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                flex: 1,
                child: Image.asset(user.gender == Gender.male
                    ? "assets/images/male.png"
                    : "assets/images/female.png"),
              ),
              Flexible(
                flex: 1,
                child: MenuListView(
                  passChosen: (list) {
                    this.list = list;
                    final a = list.where((e) => e.value == true).toList();
                    if (a.isNotEmpty) {
                      isNextActive = true;
                    } else {
                      isNextActive = false;
                    }
                    setState(() {});
                  },
                ),
              )
            ],
          ),

          next(context, mainGoalScreen, isNextActive, () {
            for (var element in list) {
              if (element.value) {
                _focusArea.add(element.focusArea);
              }
            }
            user.focusArea = _focusArea;
            sendEvent("onboarding_3");
          }),

          const SizedBox()
        ],
      )),
    );
  }
}
