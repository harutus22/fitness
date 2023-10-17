// import 'package:alarm/alarm.dart';
import 'dart:ffi';
import 'dart:io';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fitness/custom_widgets/download_progress.dart';
import 'package:fitness/screens/challenges/challenge_screen.dart';
import 'package:fitness/screens/create/create_main_screen.dart';
import 'package:fitness/screens/plan/work_out_plan_main_screen.dart';
import 'package:fitness/screens/profile/profile_main_screen.dart';
import 'package:fitness/utils/custom_icons/create_final_custom_icons.dart';
import 'package:fitness/utils/open_ad_manager.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import '../utils/Routes.dart';
import '../utils/colors.dart';
import '../utils/const.dart';
import '../utils/notification_class.dart';
import '../utils/words.dart';
import 'onboarding/paywall_screen.dart';

class MainMenuScreen extends StatefulWidget {
  MainMenuScreen({Key? key, this.numer}) : super(key: key);

  int? numer = null;

  @override
  State<MainMenuScreen> createState() => _MainMenuScreenState();
}

class _MainMenuScreenState extends State<MainMenuScreen> {

  var _selectedIndex = 0;
  final iconSize = 20.0;
  late Directory dir;
  int count = 0;
  final pages = [
    const WorkOutPlanMainScreen(),
    const ChallengeMainScreen(),
    const CreateMainScreen(),
    const ProfileMainScreen()
  ];

  @override
  void initState() {
    AwesomeNotifications().setListeners(
      onActionReceivedMethod: NotificationController.onActionReceivedMethod,
      onNotificationCreatedMethod: NotificationController.onNotificationCreatedMethod,
      onNotificationDisplayedMethod: NotificationController.onNotificationDisplayedMethod,
      onDismissActionReceivedMethod: NotificationController.onDismissActionReceivedMethod,
    );
    // if(!user.isSubscribed)
    //   createInterstitialAd('ca-app-pub-5842953747532713/1780274234');
    if(!user.isSubscribed && !OpenAdManager.haveShowed){
      openAdManager.createOpenAd("ca-app-pub-5842953747532713/1780274234", (){
        OpenAdManager.haveShowed = true;
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (BuildContext context){
          return PaywallScreen();
        }), (r){
          return false;
        });
      });
    }
    super.initState();
    if(widget.numer != null){
      _selectedIndex = widget.numer!;
    }
    inita();
  }

  void inita() async {
    await databaseHelper.init();
    // dir = await getApplicationDocumentsDirectory();
    // await Alarm.init();
  }

  @override
  void dispose() {
    super.dispose();
    // databaseHelper.close();
  }

  @override
  Widget build(BuildContext context) {
    return
      // FutureBuilder(
      //   future: getApplicationDocumentsDirectory(),
      // builder: (context, snapshot) {
      //   if (snapshot.data != null &&
      //       snapshot.connectionState ==
      //           ConnectionState.done) {
      //     return
          //   // !checkDownloaded(snapshot.data!.path) ?
          // Container(
          //   height: double.infinity,
          //   width: double.infinity,
          //   alignment: Alignment.center,
          //   color: Colors.grey.withOpacity(0.5),
          //   child: Center(child: DownloadProgressIndicator(count: count, close: (){
          //     setState(() {});
          //   },)),
          // )
        // :
        Stack(
            children: [
              Scaffold(
                body: SafeArea(
                  child: Center(
                    child: pages.elementAt(_selectedIndex),
                  ),
                ),
                bottomNavigationBar: BottomNavigationBar(
                  type: BottomNavigationBarType.fixed,
                  selectedItemColor: Colors.black,

                  unselectedItemColor: bottomItemColor,
                  currentIndex: _selectedIndex,
                  onTap: _onItemTapped,

                  items: <BottomNavigationBarItem>[
                    BottomNavigationBarItem(
                      icon: Icon(
                        FinalCreateIcons.lightning,
                        size: iconSize,
                      ),
                      label: plan.tr(),
                    ),
                    BottomNavigationBarItem(
                        icon: Icon(
                          FinalCreateIcons.trophy,
                          size: iconSize,
                        ),
                        label: challenges.tr()),
                    BottomNavigationBarItem(
                        icon: Icon(
                          FinalCreateIcons.edit,
                          size: iconSize,
                        ),
                        label: create.tr()),
                    BottomNavigationBarItem(
                        icon: Icon(
                          FinalCreateIcons.people_icon,
                          size: iconSize,
                        ),
                        label: profile.tr()),
                  ],
                ),
              ),
            ],
          );;

        // } else {
        //   return SizedBox();
        // }
      // }
    // );
  }

  void _onItemTapped(int index) async {
    if(index == 2 && !user.isSubscribed){
      await changeScreen(payWallScreen, context, argument: canPop);
      setState(() {});
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  bool checkDownloaded(String path){
    Directory dir = Directory("${path}/training_video/");
    if(!dir.existsSync()){
      dir.create();
    }
    List<FileSystemEntity> entities = dir.listSync();
    if(entities.length < 105){
      count = entities.length;
      return false;
    } else {
      return true;
    }
  }
}
