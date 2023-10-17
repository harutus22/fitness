import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fitness/utils/Routes.dart';
import 'package:fitness/utils/const.dart';
import 'package:fitness/utils/next_button.dart';
import 'package:fitness/utils/words.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _askPermission(context);
    _controller = VideoPlayerController.asset("assets/videos/splash_video.mp4")
      ..initialize().then((value) => {
            _controller.play(),
            _controller.setLooping(true),
            // Ensure the first frame is shown after the video is initialized.
            setState(() {})
          });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox.expand(
            child: FittedBox(
              fit: BoxFit.cover,
              // fit: BoxFit.cover
              child: SizedBox(
                width: _controller.value.size.width,
                height: _controller.value.size.height,
                child: VideoPlayer(_controller),
                // child: Image.asset("assets/images/splash_image.png"),
              ),
            ),
          ),
          SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                next(context, genderScreen, true, () {
                  sendEvent("onboarding_1");
                }),
                const SizedBox(
                  height: 35,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: RichText(
                    textAlign: TextAlign.center,
                      text: TextSpan(
                          style:
                              const TextStyle(fontSize: 10, color: Colors.white),
                          children: [
                            TextSpan(text:"${byContinuingAccept.tr()} ", ),
                            TextSpan(
                              text: privacy.tr(),
                              recognizer: TapGestureRecognizer()..onTap = () async {
                                final uri = Uri.parse("https://sites.google.com/view/homeworkoutsformenwomen-privac/home-workouts-for-men-women-privacy-policy");
                                if (!await launchUrl(uri)) {
                                  throw Exception('Could not launch $uri');
                                }
                              },
                              style: const TextStyle(
                                  decoration:
                                  TextDecoration.underline), //<-- SEE HERE
                            ),
                            TextSpan(text: "\n ${and.tr()} "),
                        TextSpan(
                          text: termsCondition.tr(),
                          recognizer: TapGestureRecognizer()..onTap = () async {
                            final uri = Uri.parse("https://sites.google.com/view/homeworkoutsformenwomen-te/home-workouts-for-men-women-terms-conditions");
                            if (!await launchUrl(uri)) {
                            throw Exception('Could not launch $uri');
                            }
                          },
                          style: const TextStyle(
                              decoration:
                                  TextDecoration.underline), //<-- SEE HERE
                        ),


                      ])),
                ),
                const SizedBox(
                  height: 80,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  Future<void> showCustomTrackingDialog(BuildContext context) async =>
      await showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Dear User'),
          content: const Text(
            'We care about your privacy and data security. We keep this app free by showing ads. '
                'Can we continue to use your data to tailor ads for you?\n\nYou can change your choice anytime in the app settings. '
                'Our partners will collect data and use a unique identifier on your device to show you ads.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Continue'),
            ),
          ],
        ),
      );

  void _askPermission(BuildContext context) async{
    final status = await AppTrackingTransparency.trackingAuthorizationStatus;
    if ( status ==
        TrackingStatus.notDetermined) {
      // Show a custom explainer dialog before the system dialog
      await showCustomTrackingDialog(context);
      // Wait for dialog popping animation
      await Future.delayed(const Duration(milliseconds: 200));
      // Request system's tracking authorization dialog
      await AppTrackingTransparency.requestTrackingAuthorization();
    }
  }
}
