import 'package:flutter/material.dart';

import 'package:zak_mobile_app/extensions/text.dart';
import 'package:zak_mobile_app/utility/colors.dart';
import 'package:zak_mobile_app/utility/utility.dart';

enum ImageAlignment { Right, Center, Left }

class EmptyActivity extends StatelessWidget {
  final String imagePath;
  final String primaryText;
  final String secondaryText;
  final ImageAlignment alignment;

  EmptyActivity(
      {@required this.imagePath,
      @required this.secondaryText,
      @required this.primaryText,
      this.alignment});

  Matrix4 _getImagePosition() {
    if (alignment == ImageAlignment.Right) {
      return Matrix4.translationValues(40, 0, 0);
    } else if (alignment == ImageAlignment.Center) {
      return Matrix4.translationValues(-70, 0, 0);
    } else {
      return Matrix4.translationValues(-60, 0, 0);
    }
  }

  Matrix4 _getPatternPosition() {
    if (alignment == ImageAlignment.Right) {
      return Matrix4.translationValues(80, 0, 0);
    } else if (alignment == ImageAlignment.Center) {
      return Matrix4.translationValues(-20, 0, 0);
    } else {
      return Matrix4.translationValues(-40, 0, 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 107),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              (alignment == ImageAlignment.Center ||
                      alignment == ImageAlignment.Left)
                  ? Container()
                  : Spacer(),
              Container(
                  transform: _getPatternPosition(),
                  child: Image.asset(alignment == ImageAlignment.Left
                      ? imagePath
                      : 'assets/images/RightBackgroundPattern.png')),
              Container(
                transform: _getImagePosition(),
                child: Image.asset(
                  alignment == ImageAlignment.Left
                      ? 'assets/images/BackgroundPattern.png'
                      : imagePath,
                ),
              ),
              (alignment == ImageAlignment.Center ||
                      alignment == ImageAlignment.Left)
                  ? Spacer()
                  : Container()
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 16),
          child: primaryText.withStyle(
              style: subtitleTextStyle(FontWeight.normal), color: ZAKDarkGreen),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 80),
          child: Text(
            (secondaryText),
            style: subtitleTextStyle(FontWeight.normal),
            strutStyle: StrutStyle(height: 1.6),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
