import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:fitness/screens/plan/work_out_plan_item.dart';
import 'package:fitness/utils/Routes.dart';
import 'package:fitness/utils/const.dart';
import 'package:fitness/utils/words.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/plan_model_static.dart';
import '../../utils/colors.dart';
import '../onboarding/paywall_screen.dart';

class WorkOutPlanMainScreen extends StatefulWidget {
  const WorkOutPlanMainScreen({Key? key}) : super(key: key);

  @override
  State<WorkOutPlanMainScreen> createState() => _WorkOutPlanMainScreenState();
}

class _WorkOutPlanMainScreenState extends State<WorkOutPlanMainScreen> {
  String name = "";
  List<PlanModelStatic> planModels = [];
  double count = 0;
  bool isSubscribed = false;

  Future<void> _checkSubs() async {
    final shared = await SharedPreferences.getInstance();
    final res = shared.getString(date);
    if (res != null) {
      final a = DateTime.now().compareTo(DateTime.parse(res));
      isSubscribed = a < 0;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // _checkSubs();
    inita();
    _getUserName();
    getUser().then((value) => {
      isSubscribed = value.isSubscribed,
    });
  }

  void inita() async {
    await databaseHelper.init();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    // databaseHelper.close();
  }

  void _getUserName() async {

    name = user.name;
    count = user.totalCount.toDouble();
    final item = await getWorkoutWeekDate();
    if(item == null) {
      _setDatabase();
    } else if(item == false){
      planModels.addAll(await getWeekPlans());
      setState(() {});
    } else{
      _setDatabase();
    }
  }

  void _setDatabase()async {
    await databaseHelper.init();
    databaseHelper.getStaticPlanModels().then((value) =>
    {
      planModels.addAll(_getListStaticModel(
          value
              .where((element) => element.restBetweenExercises! > 0)
              .toList(),
          count)),
      _setWeeks(),
    });
  }

void _setWeeks()async {
  setWorkoutWeekDate();
  _setImages();
  setWeekPlans(planModels);
  setState(() {});
}

void _setImages(){
    List<int> numbers = [];
    for(var item in planModels){
      var random = Random().nextInt(62) + 1;
      while(numbers.contains(random)){
        random = Random().nextInt(62) + 1;
      }
      numbers.add(random);
      item.image = "assets/images/covers/$random.png";
    }
}

  List<PlanModelStatic> _getListStaticModel(
      List<PlanModelStatic> list, final double diff) {
    List<PlanModelStatic> retList = [];
    int a = 0;
    if (diff <= 3) {
      a = 3;
    } else if (diff > 3 && diff <= 4) {
      a = 4;
    } else {
      a = 5;
    }
    for (int i = 0; i < a; i++) {
      if (i == 0) {
        retList.add(getStaticModel("Cardio", list));
      } else if (i == 1) {
        retList.add(getStaticModel("Upper Body", list));
      } else if (i == 2) {
        retList.add(getStaticModel("Full Body", list));
      } else if (i == 3) {
        retList.add(getStaticModel("Core", list));
      } else if (i == 4) {
        retList.add(getStaticModel("Lower Body", list));
      }
    }
    return retList;
  }

  PlanModelStatic getStaticModel(
      String text, List<PlanModelStatic> chosenList) {
    List<PlanModelStatic> finalList =
        chosenList.where((element) =>
            element.type!.contains(text)
        ).toList();
    return finalList[Random().nextInt(finalList.length)];
  }
  final style = const TextStyle(
    color: Colors.black,
    fontWeight: FontWeight.bold,
    fontSize: 24,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: Column(
            children: [
              Wrap(
                runSpacing: 0,
                spacing: 5,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: RichText(
                      textAlign: TextAlign.start,
                      text: TextSpan(
                          children: [
                            TextSpan(
                              text: planNameHey.tr(),
                            ),
                            TextSpan(
                                text: name,
                                style: TextStyle(
                                    foreground: Paint()
                                      ..shader = textLinearGradient)),
                            const TextSpan(text: ", "),

                          ],
                          style: style),
                    ),
                  ),
                  Text(
                     planNameWorkout.tr(),
                      style: style
                  ,textAlign: TextAlign.start)
                ],
              ),

              SizedBox(
                height: 10,
              ),
              Expanded(
                  child: planModels.isEmpty ? Container(
                    alignment: Alignment.center,
                    child: const CircularProgressIndicator(),
                  ) : ListView.builder(
                      itemBuilder: (context, position) {
                        return Column(
                          children: [
                            WorkOutPlanItem(
                              workOutPlanItemModel: planModels[position],
                              workoutFunction: (workoutItem, isFree) async {
                                if (isFree) {
                                  changeScreen(planDetailedScreen, context,
                                      argument: workoutItem);
                                } else {
                                  await changeScreen(payWallScreen, context, argument: canPop);
                                  setState(() {});
                                }
                              },
                              image: planModels[position].image!,
                              isFree: position > 1 ? isSubscribed : true,
                            ),
                            position != planModels.length - 1
                                ? const SizedBox(
                                    height: 20,
                                  )
                                : const SizedBox()
                          ],
                        );
                      },
                      itemCount: planModels.length))
            ],
          ),
        ),
      ),
    );
  }
}
