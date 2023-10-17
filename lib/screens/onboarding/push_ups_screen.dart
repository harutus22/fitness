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

class PushUpsScreen extends StatefulWidget {
  const PushUpsScreen({Key? key}) : super(key: key);

  @override
  State<PushUpsScreen> createState() => _PushUpsScreenState();
}

class _PushUpsScreenState extends State<PushUpsScreen> {

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
    _controller = VideoPlayerController.asset('assets/videos/male_1.mp4');
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
                        "assets/images/onboard_10.png",
                        alignment: Alignment.centerLeft,
                      ))
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: onboardingTextSize),
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: howMany.tr(),
                      ),
                      TextSpan(
                          text: pushUp.tr(),
                          style: TextStyle(
                              foreground: Paint()..shader = textLinearGradient
                          )
                      ),
                      TextSpan(
                          text: oneSet.tr(),
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
              const SizedBox(height: 10,),
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
                      text: less5Times.tr(),
                    ),
                  ),
                  Flexible(
                    child: MyRadioOption<String>(
                      value: '2',
                      groupValue: _groupValue,
                      onChanged: _valueChangedHandler(),
                      label: '2',
                      text: from5To10Times.tr(),
                    ),
                  ),
                  Flexible(
                    child: MyRadioOption<String>(
                      value: '3',
                      groupValue: _groupValue,
                      onChanged: _valueChangedHandler(),
                      label: '3',
                      text: from10To15Times.tr(),
                    ),
                  ),
                  Flexible(
                    child: MyRadioOption<String>(
                      value: '4',
                      groupValue: _groupValue,
                      onChanged: _valueChangedHandler(),
                      label: '4',
                      text: from15To25Times.tr(),
                    ),
                  ),
                  Flexible(
                    child: MyRadioOption<String>(
                      value: '5',
                      groupValue: _groupValue,
                      onChanged: _valueChangedHandler(),
                      label: '5',
                      text: more25Times.tr(),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20,),
              next(context, sitUpsScreen, isNextActive, () {
                user.firstCount = TrainingCount.values[int.parse(_groupValue!)];
                sendEvent("onboarding_11");
              }),
              const SizedBox(height: 20,),
              GestureDetector(
                onTap: () {
                  user.firstCount = TrainingCount.noResult;
                  sendEvent("onboarding_11");
                  changeScreen(sitUpsScreen, context);
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
