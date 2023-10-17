import 'package:easy_localization/easy_localization.dart';
import 'package:fitness/model/training_done_model.dart';
import 'package:fitness/screens/challenges/challenge_screen.dart';
import 'package:fitness/screens/main_menu_screen.dart';
import 'package:fitness/utils/const.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../model/challane_model.dart';
import '../../utils/colors.dart';
import '../../utils/words.dart';

class WorkOutEndScreen extends StatefulWidget {
  const WorkOutEndScreen({Key? key}) : super(key: key);

  @override
  State<WorkOutEndScreen> createState() => _WorkOutEndScreenState();
}

class _WorkOutEndScreenState extends State<WorkOutEndScreen> {

  int _selectedFeedback = -1;
  int day = 1;
  bool _adShowed = false;

  @override
  void initState() {
    getWorkoutFirstDate().then((value){
      if(value == null){
        setWorkoutFirstDate();
      } else {
        final now = DateTime.now().millisecondsSinceEpoch - value;
        day = Duration(milliseconds: now).inDays;
      }
    });
    // if(!user.isSubscribed)
    //   createInterstitialAd('ca-app-pub-5842953747532713/4776224817');
    if(!user.isSubscribed && isInterstitialLoaded){
      showInterstitialAd();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final map = ModalRoute.of(context)?.settings.arguments as Map;
    final name = map[planExerciseName] as String;
    final kcal = map[planExerciseKcal] as double;
    final exerciseCount = map[planExerciseCount] as int;
    final time = map[planExerciseTime] as String;
    final total = map[planExerciseTotal] as int;
    final challengeItem = map[challenge_item] as ChallengeModel?;
    int dayCount = challengeItem != null ? challengeItem.isPassed!.contains(true) ? challengeItem.isPassed!.indexWhere((element) => element == false) + 1 : 1 : 1;

    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Stack(
        children: [
          SizedBox.expand(
            child: FittedBox(
              fit: BoxFit.cover,
              // fit: BoxFit.cover
              child: SizedBox(
                // width: _controller.value.size.width,
                // height: _controller.value.size.height,
                // child: VideoPlayer(_controller),
                child: Image.asset("assets/images/result_exercise_cover.png"),
              ),
            ),
          ),
          SafeArea(
            child: Container(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 40,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        workoutFinished.tr(),
                        style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Row(
                        children: [
                          Text(
                            name,
                            style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                          ),
                          const SizedBox(width: 10,),
                          const Icon(
                            Icons.circle,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 10,),
                          Text(
                            "${dayText.tr()} ${dayCount == 1 ? day : dayCount}",
                            style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 60,
                    ),
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color(0xff242423).withOpacity(0.7),
                          border: Border.all(color: const Color(0xffCDCDCF)),
                          borderRadius: const BorderRadius.all(Radius.circular(20))),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IntrinsicHeight(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                itemColumn(firstLExer.tr(), exerciseCount.toString()),
                                VerticalDivider( color: const Color(0xffCDCDCF).withOpacity(0.7), thickness: 1,),
                                itemColumn(kcalText.tr(), kcal.toStringAsFixed(2)),
                                VerticalDivider( color: const Color(0xffCDCDCF).withOpacity(0.7), thickness: 1,),
                                itemColumn(timeText.tr(), time),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20,),
                          InkWell(
                            onTap: () {
                              var dateCurrent = DateTime.now();
                              var date = DateTime(dateCurrent.year, dateCurrent.month, dateCurrent.day);
                              final training = TrainingDone(date: date, caloriesBurnt: kcal.toInt(), timePassed: total);
                              databaseHelper.insertTrainingDone(training);
                              if(challengeItem != null) {
                                for (var item = 0; item < challengeItem.isPassed!.length; item++){
                                  if(challengeItem.isPassed![item] == false){
                                    challengeItem.isPassed![item] = true;
                                    break;
                                  }
                                }
                                databaseHelper.updateChallenge(challengeItem);
                              }
                              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (BuildContext context){
                                return MainMenuScreen(numer: challengeItem != null ? 1 : null);
                              }), (r){
                                return false;
                              });
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 30),
                              width: width,
                              decoration: BoxDecoration(
                                  color: const Color(0xff444A5A),
                                  borderRadius: BorderRadius.circular(24)),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 20),
                                child: RichText(
                                  textAlign: TextAlign.start,
                                  text: TextSpan(
                                    children: [
                                      WidgetSpan(
                                        child: SizedBox(width: (width) / 6,),
                                      ),
                                      const WidgetSpan(
                                        child: Icon(Icons.check, size: 18, color: Colors.white,),
                                      ),
                                      const WidgetSpan(
                                        child: SizedBox(width: 20,),
                                      ),
                                      TextSpan(text: finishText.tr(), style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),)
                                      ,
                                      // textAlign: TextAlign.center,

                                    ]
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20,),
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                          color: const Color(0xff242423).withOpacity(0.7),
                          border: Border.all(color: const Color(0xffCDCDCF)),
                          borderRadius: const BorderRadius.all(Radius.circular(20))),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 10),
                        child: Column(
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                howDoYouFell.tr(),
                                style:
                                TextStyle(fontWeight: FontWeight.bold, foreground: Paint()..shader = textLinearGradient, fontSize: 22),
                              ),
                            ),
                            const SizedBox(height: 20,),
                            Text(
                              provideFeedback.tr(),
                              style:
                              const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 18),
                            ),
                            const SizedBox(height: 20,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                itemHappiness(_selectedFeedback == 0 ? "assets/images/exercise_bad.png": "assets/images/exercise_bad_not.png", tooHard.tr(), 0),
                                const SizedBox(width: 10,),
                                itemHappiness(_selectedFeedback == 1 ? "assets/images/exercise_medium.png": "assets/images/exercise_medium_not.png", justRight.tr(), 1),
                                const SizedBox(width: 10,),
                                itemHappiness(_selectedFeedback == 2 ? "assets/images/exercise_good.png": "assets/images/exercise_good_not.png", tooEasy.tr(), 2),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget itemHappiness(String image, String title, int number){
    final paint = Paint()..shader = textLinearGradient;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InkWell(
          onTap: (){
            _selectedFeedback = number;
            setState(() {});
          },
          child: Container(
              decoration: BoxDecoration(
                // border: Border.all(width: 2, color: _selectedFeedback != number ? const Color(0xffCDCDCF) : Colors.transparent),
                borderRadius: BorderRadius.circular(100), //<-- SEE HERE
              ),
              child: Image.asset(image)
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Text(
          title,
          style:
          TextStyle(fontWeight: FontWeight.bold, color: number == _selectedFeedback ?null : Colors.white,
        foreground: number == _selectedFeedback ? paint : null,
        ),
        )
      ],
    );
  }

  Widget itemColumn(String title, String item) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          title,
          style:
              const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        const SizedBox(
          height: 10,
        ),
        Text(
          item,
          style: TextStyle(
              foreground: Paint()..shader = textLinearGradient,
              fontWeight: FontWeight.w800,
          fontSize: 20),
        )
      ],
    );
  }




  @override
  void dispose() {

    super.dispose();
  }
}
