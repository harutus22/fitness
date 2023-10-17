import 'package:easy_localization/easy_localization.dart';
import 'package:fitness/model/custom_check_box_motivation_model.dart';
import 'package:fitness/model/user_info_enums.dart';
import 'package:fitness/utils/const.dart';
import 'package:flutter/material.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';

import '../../utils/back_button.dart';
import '../../utils/colors.dart';
import '../../utils/next_button.dart';
import '../../utils/routes.dart';
import '../../utils/words.dart';

class MotivationScreen extends StatefulWidget {
  const MotivationScreen({Key? key}) : super(key: key);

  @override
  State<MotivationScreen> createState() => _MotivationScreenState();
}

class _MotivationScreenState extends State<MotivationScreen> {
  bool isNextActive = false;
  final list = [
    CheckBoxMotivationState(
        title: feelConfident.tr(), motivation: Motivations.feelConfident, image: "assets/images/feel_confident.png"),
    CheckBoxMotivationState(
        title: releaseStress.tr(), motivation: Motivations.releaseStress, image: "assets/images/release_stress.png"),
    CheckBoxMotivationState(
        title: improveHealth.tr(), motivation: Motivations.improveHealth, image: "assets/images/improve_health.png"),
    CheckBoxMotivationState(
        title: boostEnergy.tr(), motivation: Motivations.boostEnergy, image: "assets/images/boost_energy.png"),
    CheckBoxMotivationState(
        title: getShaped.tr(), motivation: Motivations.getShaped, image: "assets/images/get_shaped.png"),
  ];
  List<Motivations> _motivations = [];

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
                    "assets/images/onboard_4.png",
                    alignment: Alignment.centerLeft,
                  ))
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              motivation.tr(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: Colors.black, fontWeight: FontWeight.w900, fontSize: onboardingTextSize),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              listItem(list[0]),
              listItem(list[1]),
              listItem(list[2]),
              listItem(list[3]),
              listItem(list[4]),
            ],
          ),
          next(context, userNameScreen, isNextActive, () {
            for(var item in list) {
              if(item.value) {
                _motivations.add(item.motivation);
              }
            }
            sendEvent("onboarding_5");
            user.motivations = _motivations;
          }),
          const SizedBox()
        ],
      )),
    );
  }

  Widget listItem(CheckBoxMotivationState item) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 0.5,
            blurRadius: 10,
            offset: const Offset(0, 0), // changes position of shadow
          ),
        ],
      ),
      child: GestureDetector(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            decoration: !item.value
                ? BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: GradientBoxBorder(
                gradient: linearGradient,
                width: 1,
              ),
            )
                : const BoxDecoration(
              gradient: linearGradient,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Image.asset(item.image, height: 20,),
                SizedBox(width: 10,),
                Text(
                  item.title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: !item.value ?Colors.black: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 20),
                ),
              ],
            ),
          ),
        ),
        onTap: () {
          item.value = !item.value;
          final a = list.where((element) => element.value == true).toList();
          if (a.isNotEmpty) {
            isNextActive = true;
          } else {
            isNextActive = false;
          }
          setState(() {});
        },
      ),
    );
  }
}
