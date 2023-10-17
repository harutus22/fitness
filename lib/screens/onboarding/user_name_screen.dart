import 'package:easy_localization/easy_localization.dart';
import 'package:fitness/utils/Routes.dart';
import 'package:fitness/utils/colors.dart';
import 'package:fitness/utils/words.dart';
import 'package:flutter/material.dart';

import '../../utils/back_button.dart';
import '../../utils/const.dart';
import '../../utils/next_button.dart';

class UserNameScreen extends StatefulWidget {
  const UserNameScreen({Key? key}) : super(key: key);

  @override
  State<UserNameScreen> createState() => _UserNameScreenState();
}

class _UserNameScreenState extends State<UserNameScreen> {

  bool isNextActive = false;
  String name = "";

  @override
  void initState() {
    super.initState();
  }

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
                        "assets/images/onboard_5.png",
                        alignment: Alignment.centerLeft,
                      ))
                ],
              ),
              RichText(
                text: TextSpan(
                    text: whatName.tr(),
                  style: const TextStyle(
                      color: Colors.black, fontWeight: FontWeight.w900, fontSize: onboardingTextSize,
                  )
                ),
              ),
              // MenuGridView(),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: colorGreyTextField,
                          border: Border.all(
                              width: 1, color: colorGreyBoarder, style: BorderStyle.solid)),
                      child: TextFormField(
                        onChanged: (text) {
                          if(text.isNotEmpty) {
                            isNextActive = true;
                          } else {
                            isNextActive = false;
                          }
                          name = text;
                          setState(() {
                          });
                        },
                        decoration: InputDecoration(
                            hintText: enterName.tr(),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                            border: InputBorder.none
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30,),
                  InkWell(onTap: (){
                    sendEvent("onboarding_6");
                    changeScreen(userAgeScreen, context);
                  },
                    child: Text("Skip", style: TextStyle(
                        color: Colors.black.withOpacity(0.38),
                        fontSize: 16
                    ),),),
                ],
              ),

              next(context, userAgeScreen, isNextActive, () {
                user.name = name;
                sendEvent("onboarding_6");
              }),
              const SizedBox()
            ],
          )),
    );
  }
}
