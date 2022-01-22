import 'package:flutter/material.dart';

import 'package:zak_mobile_app/utility/colors.dart';
import 'package:zak_mobile_app/extensions/text.dart';
import 'package:zak_mobile_app/utility/utility.dart';
import 'package:zak_mobile_app/view/widgets/bullet_point.dart';
import 'package:zak_mobile_app/view/widgets/zak_flat_button.dart';

class ZooOverviewCard extends StatelessWidget {
  final String title;
  final String placeName;
  final String buttonTitle;
  final String subtitle;
  final Function onPressed;
  final List<String> benefits;

  ZooOverviewCard(
      {this.buttonTitle,
      this.onPressed,
      this.title,
      this.placeName,
      this.subtitle = '',
      this.benefits});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 24, left: 24, right: 24, bottom: 16),
      decoration: BoxDecoration(
        color: ZAKLightGrey,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          (title ?? '').withStyle(
              style: Theme.of(context).textTheme.headline6,
              color: ZAKDarkGreen),
          benefits != null
              ? Container()
              : Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: (placeName ?? '').withStyle(
                      style: subtitleTextStyle(FontWeight.normal),
                      color: ZAKDarkGreen),
                ),
          benefits != null
              ? Container()
              : (subtitle ?? '').isEmpty
                  ? Container()
                  : Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: subtitle.withStyle(
                          style: subtitleTextStyle(FontWeight.normal),
                          color: ZAKGrey),
                    ),
          benefits == null
              ? Container()
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8, top: 16),
                      child: Text(
                        'Benefits',
                        style: TextStyle(
                          fontSize:
                              Theme.of(context).textTheme.bodyText2.fontSize,
                          letterSpacing: Theme.of(context)
                              .textTheme
                              .bodyText2
                              .letterSpacing,
                          color: ZAKDarkGreen,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 5,
                      ),
                    ),
                    ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: benefits.length,
                        itemBuilder: (_, index) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: BulletPoint(benefits[index]),
                          );
                        }),
                  ],
                ),
          Padding(
            padding: const EdgeInsets.only(
              top: 4,
            ),
            child: ZAKFlatButton(
              title: buttonTitle,
              onPressed: onPressed,
            ),
          )
        ],
      ),
    );
  }
}
