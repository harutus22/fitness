import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:fitness/model/paymtent_item.dart';
import 'package:fitness/utils/Routes.dart';
import 'package:fitness/utils/const.dart';
import 'package:fitness/utils/paywall_radio_button.dart';
import 'package:fitness/utils/words.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
// import 'package:in_app_purchase/in_app_purchase.dart';
// import 'package:purchases_flutter/models/offering_wrapper.dart';
// import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/colors.dart';
import '../main_menu_screen.dart';

const Set<String> _productIds = <String>{'monthly, yearly'};
const date = 'DATE';

class PaywallScreen extends StatefulWidget {
  const PaywallScreen({Key? key}) : super(key: key);

  @override
  State<PaywallScreen> createState() => _PaywallScreenState();
}

class _PaywallScreenState extends State<PaywallScreen> {

  int chosenPayment = 0;
  final paymentsType = [
    PaymentItem(
        perYear: true, totalPrice: 39.99, weekPrice: 0.76, subsName: "yearly"),
    PaymentItem(
        perYear: false, totalPrice: 9.99, weekPrice: 2.50, subsName: "monthly"),
  ];

  // List<ProductDetails> _products = [];
  // InAppPurchase inAppPurchase = InAppPurchase.instance;
  bool isPro = false;
  // List<Package> packages = [];

  @override
  void dispose() {
    super.dispose();
  }

  Future getOfferings() async {
    final offerings = await Purchases.getOfferings();
    if(offerings.current != null){
      final packages = offerings.current?.availablePackages;
      for(int i = 0; i < packages!.length; i++) {
        final product = packages[i].storeProduct;
        if(product.identifier == "ft_premium_year") {
          paymentsType[0].totalPrice = product.price;
          paymentsType[0].weekPrice =
          product.price / 52;
        } else {
          paymentsType[1].totalPrice = product.price;
          paymentsType[1].weekPrice =
          product.price / 4.4;
        }
      }
    }
    setState(() {

    });
  }

  @override
  void initState() {

    final prefs = SharedPreferences.getInstance();
    prefs.then(
          (value) {
        final res = value.getString(date);
        if (res != null) {
          final a = DateTime.now().compareTo(DateTime.parse(res));
          isPro = a < 0;
        }
      },
    );
    getOfferings();
    // final Stream purchaseUpdated = inAppPurchase.purchaseStream;
    // _subscription = purchaseUpdated.listen((purchaseDetailsList) {
    //   _listenToPurchaseUpdated(purchaseDetailsList);
    // }, onDone: () {
    //   _subscription.cancel();
    // }, onError: (error) {});
    // initStoreInfo();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    final argument = ModalRoute.of(context)!.settings.arguments;
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: SingleChildScrollView(
            child: Stack(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Image.asset(
                          "assets/images/paywall.png",
                          fit: BoxFit.cover,
                        )),
                    SizedBox(height: 10,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          bePremiumText.tr(),
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 30,
                              foreground: Paint()..shader = textLinearGradient),
                        ),
                        const SizedBox(height: 10,),
                        Text(
                          getUnlimitedAccess.tr(),
                          style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                        const SizedBox(height: 10,),
                        Column(
                          children: [
                            consItem(personalPlanDesigned.tr()),
                            consItem(planDesignedToAchieveGoals.tr()),
                            consItem(createOwnTrainingPlan.tr()),
                            consItem(noAdsText.tr()),
                          ],
                        ),

                      ],
                    ),
                    SizedBox(height: 10,),
                    Column(
                      children: [
                        purchasePlanItem(paymentsType[0], 0, () => {}),
                        const SizedBox(height: 20,),
                        purchasePlanItem(paymentsType[1], 1, () => {})
                      ],
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    InkWell(
                      onTap: (){
                        pay(argument);
                      },
                      child: Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                        width: MediaQuery.of(context).size.width,
                        margin: const EdgeInsets.symmetric(horizontal: 40),
                        decoration: const BoxDecoration(
                            gradient: linearGradient,
                            borderRadius: BorderRadius.all(Radius.circular(20))
                        ),
                        child: Text(tryFreeAndSubscribe.tr(), style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold
                        ),),
                      ),
                    ),

                    const SizedBox(height: 10,),
                    RichText(
                      textAlign: TextAlign.center,
                        text: TextSpan(
                            style: const TextStyle(fontSize: 12, color: Color(0xff9E9E9E)),
                            children: [
                              TextSpan(text: "${byContinuingAccept.tr()} "),
                              TextSpan(
                                text: "${privacy.tr()}\n",
                                recognizer: TapGestureRecognizer()..onTap = () {
                                  launchUrlCall(Uri.parse("https://sites.google.com/view/homeworkoutsformenwomen-privac/home-workouts-for-men-women-privacy-policy"));

                                },
                                style: const TextStyle(
                                    decoration:
                                    TextDecoration.underline), //<-- SEE HERE
                              ),
                              TextSpan(text: " ${and.tr()} "),
                              TextSpan(
                                text: termsCondition.tr(),
                                recognizer: TapGestureRecognizer()..onTap = () {
                                  launchUrlCall(Uri.parse("https://sites.google.com/view/homeworkoutsformenwomen-te/home-workouts-for-men-women-terms-conditions"));

                                },
                                style: const TextStyle(
                                    decoration:
                                    TextDecoration.underline), //<-- SEE HERE
                              ),
                            ])),
                    const SizedBox(height: 10,),

                  ],
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    margin: const EdgeInsets.only(right: 10, top: 10),
                    padding: const EdgeInsets.all(5),
                    child: IconButton(
                        onPressed: () {
                          if(argument != null && argument == canPop){
                            //TODO subscription init
                            Navigator.of(context).pop();
                          } else {
                            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (BuildContext context){
                              return MainMenuScreen();
                            }), (r){
                              return false;
                            });
                          }
                        },
                        icon: Icon(
                          Icons.cancel,
                          color: Colors.black.withAlpha(70),
                        )),
                  ),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    margin: const EdgeInsets.only(right: 20, top: 25),
                    padding: const EdgeInsets.all(5),
                    child: InkWell(
                      onTap: () {
                        _restorePurchase(argument);
                      },
                      child: Text(
                        restoreText.tr(),
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 12),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget consItem(String title) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 40),
      width: MediaQuery.of(context).size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ShaderMask(
            shaderCallback: (Rect bounds) {
              return const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [colorMainGradLeft, colorMainGradRight],
              ).createShader(bounds);
            },
            child: const Icon(
              Icons.check_circle_rounded,
              color: Colors.white,
              size: 22.0,
            ),
          ),
          const SizedBox(
            width: 5,
          ),
          Flexible(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black,
              ),
              overflow: TextOverflow.visible,
              softWrap: true,
            ),
          )
        ],
      ),
    );
  }

  Widget purchasePlanItem(
      PaymentItem payment, int itemNumber, Function() callback) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        InkWell(
          onTap: () {
            chosenPayment = itemNumber;
            setState(() {});
          },
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 12,
            margin: const EdgeInsets.symmetric(horizontal: 40),
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(20)),
                gradient: itemNumber == chosenPayment ? linearGradient : null,
                color: itemNumber != chosenPayment
                    ? const Color(0xffD7D7D7)
                    : null),
            child: Container(
              margin: const EdgeInsets.all(2),
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(18)),
                  color: Colors.white),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 25,
                        width: 25,
                        decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(50)),
                            gradient: itemNumber == chosenPayment
                                ? linearGradient
                                : null,
                            color: itemNumber == chosenPayment
                                ? null
                                : const Color(0xffD7D7D7)),
                        child: Padding(
                          padding: const EdgeInsets.all(7),
                          child: Container(
                              decoration: const BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(25)),
                                  color: Colors.white)),
                        ),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            payment.perYear == true
                                ? "${yearlyText.tr()} - \$${payment.totalPrice.toStringAsFixed(2)}"
                                : "${monthlyText.tr()} - \$${payment.totalPrice.toStringAsFixed(2)}",
                            style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                            textAlign: TextAlign.start,
                          ),
                          // const SizedBox(
                          //   height: 4,
                          // ),
                          // Text(
                          //   freeTrialText.tr(),
                          //   style: const TextStyle(
                          //       fontSize: 12, color: Colors.black),
                          //   textAlign: TextAlign.start,
                          // )
                        ],
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ShaderMask(
                        shaderCallback: (bounds) => const LinearGradient(
                          colors: [colorMainGradLeft, colorMainGradRight],
                        ).createShader(
                            const Rect.fromLTWH(5.0, 40.0, 60.0, 60.0)),
                        child: Text(
                          "\$ ${payment.weekPrice.toStringAsFixed(2)}",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                            color: itemNumber == chosenPayment
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Text(
                        perWeekText.tr(),
                        style:
                            const TextStyle(fontSize: 12, color: Colors.black),
                        textAlign: TextAlign.start,
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
        itemNumber == 0 ?
        Positioned(
          right: MediaQuery.of(context).size.width / 7,
            top: -10,
            child:  itemNumber == chosenPayment ? Container(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            gradient: linearGradient
          ),
          child: Text(
            "${save.toString()} 70%", style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
        ): Container(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Colors.grey, Colors.grey],
                  )
              ),
              child: Text(
                "${save.toString()} 70%", style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            ))
            : SizedBox()
      ],
    );
  }

  pay(Object? argument) async {
    final payment = paymentsType[chosenPayment];
    final payId = payment.perYear ? "ft_premium_year" : "ft_premium_month";
    try {
      final result = await Purchases.purchaseProduct(payId);
      print(result.allExpirationDates[0]);
      print(result.activeSubscriptions);
      if(result.activeSubscriptions.isNotEmpty) {
        await getUser().then((user1){
          user1!.isSubscribed = true;
          setUser(user1);
          user.isSubscribed = true;
        });

      }
      if(argument != null && argument == canPop){
        //TODO subscription init
        Navigator.of(context).pop();
      } else {
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (BuildContext context){
          return MainMenuScreen();
        }), (r){
          return false;
        });
      }
      // result.
    } catch(e){
      debugPrint("Failed to subscribe due to: $e");
    }
  }

  void _restorePurchase(Object? argument) async {
    try {
      print("active subscriptions: clicked");
      final result = await Purchases.restorePurchases();
      print("active subscriptions: ${result.activeSubscriptions}");
      if (result.activeSubscriptions.isNotEmpty) {
        user.isSubscribed = true;
        setUser(user);
        if(argument != null && argument == canPop){
          //TODO subscription init
          Navigator.of(context).pop();
        } else {
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (BuildContext context){
            return MainMenuScreen();
          }), (r){
            return false;
          });
        }
      }
      print(result.allExpirationDates);
    } catch(e){}
  }

}

