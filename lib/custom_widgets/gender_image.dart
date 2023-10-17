import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../custom_class/text_painter.dart';

class GenderImage extends StatefulWidget {
  GenderImage(
      {Key? key,
      required this.isClicked,
      required this.image,
      required this.gender,
      required this.click})
      : super(key: key);

  bool isClicked;
  final String image;
  final String gender;
  final Function() click;
  bool slided = false;

  @override
  State<GenderImage> createState() => _GenderImageState();
}

class _GenderImageState extends State<GenderImage> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Stack(children: [
        if (widget.isClicked)
          CustomPaint(
            painter: OpenPainter(),
          ),
        Column(
          children: [
            Image.asset(
              widget.image,
              fit: BoxFit.fitWidth,
            ),
            const SizedBox(height: 10),
            Text(
              widget.gender.tr(),
              style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
            )
          ],
        ),
      ]),
      onTap: () {
        widget.click();
      },
    );
  }
}
