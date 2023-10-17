import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fitness/model/plan_model_static.dart';
import 'package:fitness/model/work_out_plan_item_model.dart';
import 'package:fitness/screens/challenges/challenge_screen.dart';
import 'package:fitness/screens/plan/work_out_start_screen.dart';
import 'package:fitness/utils/back_button.dart';
import 'package:fitness/utils/colors.dart';
import 'package:fitness/utils/const.dart';
import 'package:fitness/utils/next_button.dart';
import 'package:fitness/utils/routes.dart';
import 'package:flutter/material.dart';

import '../../custom_class/divider_circle_painter.dart';
import '../../model/challane_model.dart';
import '../../model/workout_model.dart';
import '../../model/workout_model_count.dart';
import '../../utils/words.dart';

class ChallengeDetailedScreen extends StatefulWidget {
  const ChallengeDetailedScreen({Key? key, required this.map}) : super(key: key);

  final Map<String, Object> map;

  @override
  State<ChallengeDetailedScreen> createState() => _ChallengeScreenState();
}

class _ChallengeScreenState extends State<ChallengeDetailedScreen> {

  late List<PlanModelStatic> planModelStatic;
  late ChallengeModel challengeItem;
  List<WorkOutModel> listCount = [];
  List<WorkoutModelCount> list = [];

  @override
  void initState() {
    planModelStatic = widget.map[challenge_plans] as List<PlanModelStatic>;
    challengeItem = widget.map[challenge_model] as ChallengeModel;
    databaseHelper.getWorkoutModels().then((value) {
      if (value.isNotEmpty) {
        listCount.addAll(value);
      }
    });
    super.initState();
  }

  void fillList(List<int> a, List<int> b) {
    for (int i = 0; i < a.length; i++) {
      list.add(WorkoutModelCount(
          workOutModel: a[i], count: b[i], isTime: b[i] > 1000));
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Column(children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(flex: 1, child: backButton(context)),
                Expanded(
                  flex: 9,
                  child: Text(
                    challengeItem.name!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontWeight: FontWeight.w500, color: Colors.black, fontSize: 20),
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      challengeItem.image!,
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Stack(
                children: [
                  GridView.count(crossAxisCount: 5,
                  children: List.generate(planModelStatic.length, (index) =>
                      challengeItemWidget(
                          challengeItem.isPassed![index],index,  () {
                      print(index);
                        PlanModelStatic item = planModelStatic[index];
                      final warmUp = item.warmUp!;
                      final warmUpTime = item.warmUpTime!;
                      final training = item.training!;
                      final trainingTime = item.trainingTime!;
                      final hitch = item.hitch!;
                      final hitchTime = item.hitchTime!;
                      fillList(warmUp, warmUpTime);
                      fillList(training, trainingTime);
                      fillList(hitch, hitchTime);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => WorkoutStartScreen(
                                name: item.name!,
                                workoutCount: list,
                                workoutModel: listCount,
                                restTime: item.restBetweenExercises == null ? 0 : item.restBetweenExercises!,
                                timeMinutes: item.trainingInMinutes == null ? 0 : item.trainingInMinutes!,
                                challengeItem: challengeItem,
                              )),
                        );
                  })),),
                  !user.isSubscribed ?
                  Positioned(
                    bottom: -40,
                    right: -10,
                    child: lockedScreen(),
                  ) : SizedBox(),
                ],
              )
            ),
          ]),
        ),
      ),
    );
  }

  Widget challengeItemWidget(bool isChecked,  int index, Function() clicked){
    return GestureDetector(
      onTap: () {
        if(!isChecked)
        clicked();
      },
      child: Stack(
        children: [
          Container(
            margin: EdgeInsets.all(10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(60),
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [colorMainGradLeft, colorMainGradRight],
                )),
            child: !isChecked ? Padding(
              padding: const EdgeInsets.all(2),
              child: Center(
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(60),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Colors.white, Colors.white],
                      )),

                ),
              ),
            ) : null,
          ),
          isChecked ? Positioned.fill(
            child: Align(
              alignment: Alignment.center,
              child: Icon(
                Icons.check,
                color: Colors.white,
              ),
            ),
          ) : Positioned.fill(
            child: Align(
              alignment: Alignment.center,
              child: Text(
                (index + 1).toString(),
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                fontSize: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget lockedScreen(){
    return GestureDetector(
      onTap: () async {
        if(user.isSubscribed == false){
          await changeScreen(payWallScreen, context, argument: canPop);
          setState(() {});
        }
      },
      child: Container(
        padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height / 2,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/back_challenge.png"),
            fit: BoxFit.cover
          )
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset("assets/images/lock.png", height: 30,),
                SizedBox(width: 10,),
                Text(unlockTxt.tr(), style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.black),)
              ],
            ),
            SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  premium.tr(),
                  style: const TextStyle(
                      fontSize: 30, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  width: 10,
                ),
                Image.asset("assets/images/premium.png"),

              ],
            ),
          ],
        ),
      ),
    );
  }
}
