import 'dart:ui';

// import 'package:appsflyer_sdk/appsflyer_sdk.dart';
import 'package:appsflyer_sdk/appsflyer_sdk.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:fitness/screens/create/choose_work_out_screen.dart';
import 'package:fitness/screens/create/create_exercise_final.dart';
import 'package:fitness/screens/create/name_work_out_screen.dart';
import 'package:fitness/screens/create/training_detailed_pre_start.dart';
import 'package:fitness/screens/main_menu_screen.dart';
import 'package:fitness/screens/onboarding/basal_metabolic_rate_screen.dart';
import 'package:fitness/screens/onboarding/body_mass_index_screen.dart';
import 'package:fitness/screens/onboarding/burpees_screen.dart';
import 'package:fitness/screens/onboarding/current_weight_screen.dart';
import 'package:fitness/screens/onboarding/deep_squats_screen.dart';
import 'package:fitness/screens/onboarding/focus_area_screen.dart';
import 'package:fitness/screens/onboarding/gender_screen.dart';
import 'package:fitness/screens/onboarding/high_knees_screen.dart';
import 'package:fitness/screens/onboarding/loader_screen.dart';
import 'package:fitness/screens/onboarding/main_goal_screen.dart';
import 'package:fitness/screens/onboarding/motivation_screen.dart';
import 'package:fitness/screens/onboarding/paywall_screen.dart';
import 'package:fitness/screens/onboarding/plan_calculation_screen.dart';
import 'package:fitness/screens/onboarding/plank_screen.dart';
import 'package:fitness/screens/onboarding/push_ups_screen.dart';
import 'package:fitness/screens/onboarding/sit_ups_screen.dart';
import 'package:fitness/screens/onboarding/target_weight_screen.dart';
import 'package:fitness/screens/onboarding/training_set_screen.dart';
import 'package:fitness/screens/onboarding/user_age_screen.dart';
import 'package:fitness/screens/onboarding/user_height_screen.dart';
import 'package:fitness/screens/onboarding/user_name_screen.dart';
import 'package:fitness/screens/plan/work_out_end_screen.dart';
import 'package:fitness/screens/plan/work_out_plan_detailed_screen.dart';
import 'package:fitness/screens/profile/change_weight_height.dart';
import 'package:fitness/screens/profile/profile_about_me_screen.dart';
import 'package:fitness/screens/profile/profile_change_details.dart';
import 'package:fitness/screens/profile/profile_reminder.dart';
import 'package:fitness/screens/profile/reminder_time_chooser.dart';
import 'package:fitness/screens/splash_screen.dart';
import 'package:fitness/utils/const.dart';
import 'package:fitness/utils/notification_class.dart';
import 'package:fitness/utils/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_flurry_sdk/flurry.dart' as flury;
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
// import 'package:flutter_flurry_sdk/flurry.dart';
// import 'package:onesignal_flutter/onesignal_flutter.dart';

final _purchaseConfiguration = PurchasesConfiguration("appl_HHjfdScMzYanKVoZbmEJTxSMhYC");

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  MobileAds.instance.initialize();
  await Purchases.configure(_purchaseConfiguration);
  // FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  init();

  AwesomeNotifications().initialize(null, [
    NotificationChannel(
        channelGroupKey: 'scheduled_channel',
        channelKey: 'scheduled_notification',
        channelName: 'Fitness reminder',
        channelDescription: 'Notification channel for reminder',
        defaultColor: Color(0xFF9D50DD),
        ledColor: Colors.white,
        importance: NotificationImportance.High,
        soundSource: "assets/sounds/alarm.mp3")
  ]);
  await EasyLocalization.ensureInitialized();

  runApp(EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('de')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      child: const MyApp()));
}

void init() async {
  Future.delayed(Duration(seconds: 3), (){
    FlutterNativeSplash.remove();
  });
  _firebaseInit();
  _oneSignalInit();
  _appsFlyerInit();
  _initFlurry();
}

void _firebaseInit() async{
  await Firebase.initializeApp();
  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };
  // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };
  FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  FirebaseAnalyticsObserver(analytics: analytics);
}

void _oneSignalInit(){
  OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);
  OneSignal.shared.setAppId("a884c067-bca2-486b-b624-50abb2e8ea9b");
  OneSignal.shared.promptUserForPushNotificationPermission().then((accepted) {
    print("Accepted permission: $accepted");
  });
}



void _appsFlyerInit(){
  AppsFlyerOptions appsFlyerOptions = AppsFlyerOptions(
      afDevKey: "J89vWfemKuJpyqwuzFSPtc",
      appId: "6448538242",
      showDebug: true,
      timeToWaitForATTUserAuthorization: 50, // for iOS 14.5
      disableAdvertisingIdentifier: false, // Optional field
      disableCollectASA: false); // Optional field

  appsflyerSdk = AppsflyerSdk(appsFlyerOptions);

  appsflyerSdk.initSdk(
      registerConversionDataCallback: true,
      registerOnAppOpenAttributionCallback: true,
      registerOnDeepLinkingCallback: true
  );
}

void _initFlurry(){
  flury.Flurry.builder
        .withCrashReporting(true)
        .withLogEnabled(true)
        .withReportLocation(true)
        // .withMessaging(true, MyMessagingListener())
        .build(
        iosAPIKey: "M7JGW9N46N4ZY9TK7QVC");

  flury.Flurry.setLogLevel(flury.LogLevel.verbose);
}



class MyApp extends StatefulWidget {
  const MyApp({super.key});


  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  static FirebaseAnalyticsObserver observer =
  FirebaseAnalyticsObserver(analytics: analytics);

  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    _inita();
    super.initState();
  }
  void _inita() async {
    await databaseHelper.init();
  }
  @override
  void dispose() {
    interstitialAd?.dispose();
    databaseHelper.close();
    super.dispose();
  }

  void checkSubs() async{
    try {
      CustomerInfo customerInfo = await Purchases.getCustomerInfo();
      if(customerInfo.activeSubscriptions.isNotEmpty) {
        print("active subscriptions: ${customerInfo.activeSubscriptions}");
        print("latest expiration date: ${DateTime
            .parse(customerInfo.latestExpirationDate!)
            .year}");
        print("latest expiration date current: ${DateTime.now()}");
        user.isSubscribed = true;
        setUser(user);
      } else {
        user.isSubscribed = false;
        setUser(user);
      }
      // access latest customerInfo
    } on PlatformException catch (e) {
      // Error fetching customer info
    }
  }

  @override
  Widget build(BuildContext context) {

    return FutureBuilder(
      future: getUser(),
      builder: (context, snapshot) {
        final userCheck = snapshot.data;
        if(userCheck != null){
          user = userCheck;
          checkSubs();
        }
        return MaterialApp(
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          title: 'Fitness',
          initialRoute: userCheck == null ? splashScreen : mainMenuScreen,
          // initialRoute: splashScreen,
          routes: {
            splashScreen: (context) => const SplashScreen(),
            genderScreen: (context) => const GenderScreen(),
            mainGoalScreen: (context) => const MainGoalScreen(),
            focusAreaScreen: (context) => const FocusAreaScreen(),
            motivationScreen: (context) => const MotivationScreen(),
            trainingSetScreen: (context) => const TrainingSetScreen(),
            userNameScreen: (context) => const UserNameScreen(),
            userAgeScreen: (context) => const UserAgeScreen(),
            userHeightScreen: (context) => const UserHeightScreen(),
            userCurrentWeightScreen: (context) => const CurrentWeightScreen(),
            userTargetWeightScreen: (context) => const TargetWeightScreen(),
            deepSquatsScreen: (context) => const DeepSquatsScreen(),
            plankScreen: (context) => const PlankScreen(),
            highKneesScreen: (context) => const HighKneesScreen(),
            pushUpsScreen: (context) => const PushUpsScreen(),
            sitUpsScreen: (context) => const SitUpsScreen(),
            burpeesScreen: (context) => const BurpeesScreen(),
            planCalculationScreen: (context) => const PlanCalculationScreen(),
            basalMetabolicRateScreen: (context) =>
                const BasalMetabolicRateScreen(),
            bodyMassIndexScreen: (context) => const BodyMassIndexScreen(),
            loaderScreen: (context) => LoaderScreen(),
            payWallScreen: (context) => const PaywallScreen(),
            mainMenuScreen: (context) => MainMenuScreen(),
            planDetailedScreen: (context) => const PlanDetailedScreen(),
            // planWorkoutStartScreen: (context) => const WorkoutStartScreen(),
            planWorkoutEndScreen: (context) => const WorkOutEndScreen(),
            nameWorkoutScreen: (context) => const NameWorkoutScreen(),
            chooseWorkoutScreen: (context) => const ChooseWorkOutScreen(),
            createExerciseFinalScreen: (context) =>
                const CreateExerciseFinalScreen(),
            createdDetailedPreStartScreen: (context) =>
                const CreatedDetailedPreStartScreen(),
            profileAboutMeScreen: (context) => const AboutMeScreen(),
            profileChangeDetailsScreen: (context) =>
                const ProfileChangeDetails(),
            profileReminderScreen: (context) => const ProfileReminderScreen(),
            profileReminderTimeChooseScreen: (context) =>
                const ReminderTimeChooserScreen(),
          },
        );
      },
    );
  }
}

//TODO Easy Localization add IOS features
