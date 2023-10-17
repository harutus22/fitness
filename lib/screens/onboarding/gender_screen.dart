import 'package:carousel_slider/carousel_slider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fitness/custom_widgets/gender_image.dart';
import 'package:fitness/utils/Routes.dart';
import 'package:fitness/utils/back_button.dart';
import 'package:fitness/utils/const.dart';
import 'package:fitness/utils/next_button.dart';
import 'package:fitness/utils/words.dart';
import 'package:flutter/material.dart';

import '../../model/user_info_enums.dart';

class GenderScreen extends StatefulWidget {
  const GenderScreen({Key? key}) : super(key: key);

  @override
  State<GenderScreen> createState() => _GenderScreenState();
}

class _GenderScreenState extends State<GenderScreen> {
  bool isGenderChosen = false;
  bool isNextActive = false;
  bool isMaleChosen = false;
  bool isFemaleChosen = false;
  int initialPage = 0;
  late GenderImage maleImg;
  late GenderImage femaleImg;
  CarouselController buttonCarouselController = CarouselController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    maleImg = GenderImage(
      isClicked: isMaleChosen,
      image: "assets/images/male.png",
      gender: male,
      click: () {
        _maleChosen();
      },
    );
    femaleImg = GenderImage(
      isClicked: isFemaleChosen,
      image: "assets/images/female.png",
      gender: female,
      click: () {
        _femaleChosen();
      },
    );
    return Scaffold(
      body: SafeArea(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(flex: 2, child: Container()),
              Expanded(
                  flex: 3,
                  child: Image.asset(
                    "assets/images/onboard_1.png",
                    alignment: Alignment.centerLeft,
                  ))
            ],
          ),
          Text(
            whatGender.tr(),
            style: const TextStyle(
                color: Colors.black, fontWeight: FontWeight.w900, fontSize: onboardingTextSize),
          ),
          Container(
            child: !isGenderChosen
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [maleImg, femaleImg],
                  )
                : CarouselSlider(
              carouselController: buttonCarouselController,
                    items: [maleImg, femaleImg],
                    options: CarouselOptions(
                      height: MediaQuery.of(context).size.height * 0.55,
                      autoPlay: false,
                      enableInfiniteScroll: false,
                      enlargeCenterPage: true,
                      viewportFraction: 0.5,
                      aspectRatio: 0.7,
                      enlargeFactor: 0.3,
                      initialPage: initialPage,
                      onPageChanged: callbackFunction,
                      scrollPhysics: ClampingScrollPhysics(),

                    ),
                  ),
          ),
          next(context, focusAreaScreen, isNextActive, (){
            if(isMaleChosen) {
              user.gender = Gender.male;
            } else {
              user.gender = Gender.female;
            }
            sendEvent("onboarding_2");
          }),
        ],
      )),
    );
  }
  dynamic callbackFunction(int index, CarouselPageChangedReason reason) async {
      if(index == 0) {
        _maleChosen();
      } else {
        _femaleChosen();
      }}

  void _maleChosen() {
    isGenderChosen = true;
    isMaleChosen = true;
    isFemaleChosen = false;
    isNextActive = true;
    if(_isFirstTime) {
      _isFirstTime = false;
      initialPage = 0;
    } else
    buttonCarouselController.previousPage();
    setState(() {});
  }

  void _femaleChosen() {
    isGenderChosen = true;
    isFemaleChosen = true;
    isMaleChosen = false;
    isNextActive = true;
    if(_isFirstTime) {
      _isFirstTime = false;
      initialPage = 1;
    } else
    buttonCarouselController.nextPage();
    setState(() {});
  }

  bool _isFirstTime= true;
}
