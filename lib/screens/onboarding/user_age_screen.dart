import 'package:easy_localization/easy_localization.dart';
import 'package:fitness/utils/colors.dart';
import 'package:fitness/utils/routes.dart';
import 'package:fitness/utils/input_formater/age_input_formatter.dart';
import 'package:fitness/utils/words.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../utils/back_button.dart';
import '../../utils/const.dart';
import '../../utils/next_button.dart';

class UserAgeScreen extends StatefulWidget {
  const UserAgeScreen({Key? key}) : super(key: key);

  @override
  State<UserAgeScreen> createState() => _UserAgeScreenState();
}

class _UserAgeScreenState extends State<UserAgeScreen> {

  bool isNextActive = false;
  int pageNumber = 0;
  int age = 0;

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
                        "assets/images/onboard_6.png",
                        alignment: Alignment.centerLeft,
                      ))
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                      text: whatAge.tr(namedArgs: {"name":user.name}),
                      style: const TextStyle(
                        color: Colors.black, fontWeight: FontWeight.w900, fontSize: onboardingTextSize,
                      )
                  ),
                ),
              ),
              // MenuGridView(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: colorGreyTextField,
                      border: Border.all(
                          width: 1, color: colorGreyBoarder, style: BorderStyle.solid)),
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    inputFormatters: [AgeInputFormatter()],
                    onChanged: (text) {
                      if(text.isNotEmpty) {
                        isNextActive = true;
                        age = int.parse(text);
                      } else {
                        isNextActive = false;
                      }
                      setState(() {
                      });
                    },
                    decoration: InputDecoration(
                        hintText: enterAge.tr(),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                        border: InputBorder.none
                    ),
                  ),
                ),
              ),
              next(context, userHeightScreen, isNextActive, () {
                sendEvent("onboarding_7");
                user.age = age;
              }),
              const SizedBox()
            ],
          )),
    );
  }
}
