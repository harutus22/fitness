import 'package:easy_localization/easy_localization.dart';
import 'package:fitness/model/user_info_enums.dart';
import 'package:fitness/utils/colors.dart';
import 'package:fitness/utils/const.dart';
import 'package:fitness/utils/words.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../../utils/back_button.dart';
import '../../utils/custom_radio_button.dart';
import '../../utils/next_button.dart';
import '../../utils/routes.dart';

class HighKneesScreen extends StatefulWidget {
  const HighKneesScreen({Key? key}) : super(key: key);

  @override
  State<HighKneesScreen> createState() => _HighKneesScreenState();
}

class _HighKneesScreenState extends State<HighKneesScreen> {

  bool isNextActive = false;
  late VideoPlayerController _controller;
  String? _groupValue;

  ValueChanged<String?> _valueChangedHandler() {
    return (value) => {
      isNextActive = true,
      setState(() =>
      _groupValue = value!
      )
    };
  }
  double chooseHeight = 0;
  double chooseWidth = 0;


  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/videos/female_3.mp4');
    _controller.addListener(() {
      setState(() {});
    });
    _controller.setLooping(true);
    _controller.initialize().then((_) => setState(() {}));
    _controller.play();
  }



  @override
  Widget build(BuildContext context) {
    chooseWidth = MediaQuery.of(context).size.width * 0.25;
    chooseHeight = MediaQuery.of(context).size.height / 7 * 3;
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
                        "assets/images/onboard_12.png",
                        alignment: Alignment.centerLeft,
                      ))
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: youCanDo.tr(),
                      ),
                      TextSpan(
                          text: highKnees.tr(),
                          style: TextStyle(
                              foreground: Paint()..shader = textLinearGradient
                          )
                      ),
                      TextSpan(
                          text: forDo.tr(),
                      ),
                    ],
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w900,
                        fontSize: onboardingTextSize,
                      )),

                ),
              ),
              // MenuGridView(),
              Container(
                padding: const EdgeInsets.only(top: 20.0),
              ),
              Container(
                height: chooseHeight,
                padding: const EdgeInsets.all(20),
                child: AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: <Widget>[
                      VideoPlayer(_controller),
                    ],
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    child: MyRadioOption<String>(
                      value: '1',
                      groupValue: _groupValue,
                      onChanged: _valueChangedHandler(),
                      label: '1',
                      text: less5Minute.tr(),
                    ),
                  ),
                  Flexible(
                    child: MyRadioOption<String>(
                      value: '2',
                      groupValue: _groupValue,
                      onChanged: _valueChangedHandler(),
                      label: '2',
                      text: from5To10.tr(),
                    ),
                  ),
                  Flexible(
                    child: MyRadioOption<String>(
                      value: '3',
                      groupValue: _groupValue,
                      onChanged: _valueChangedHandler(),
                      label: '3',
                      text: from10To15.tr(),
                    ),
                  ),
                  Flexible(
                    child: MyRadioOption<String>(
                      value: '4',
                      groupValue: _groupValue,
                      onChanged: _valueChangedHandler(),
                      label: '4',
                      text: from15To25.tr(),
                    ),
                  ),
                  Flexible(
                    child: MyRadioOption<String>(
                      value: '5',
                      groupValue: _groupValue,
                      onChanged: _valueChangedHandler(),
                      label: '5',
                      text: more25Minutes.tr(),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20,),
              next(context, planCalculationScreen, isNextActive, () {
                user.thirdCount = TrainingCount.values[int.parse(_groupValue!)];
                sendEvent("onboarding_13");
              }),
              const SizedBox(height: 20,),
              GestureDetector(
                onTap: () {
                  user.thirdCount = TrainingCount.noResult;
                  sendEvent("onboarding_13");
                  changeScreen(planCalculationScreen, context);
                },
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(iDoNotKnow.tr(), style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 16
                  ),),
                ),
              ),
              const SizedBox(height: 10,)
            ],
          )),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
