import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:zak_mobile_app/utility/colors.dart';

class SegmentedControl extends StatelessWidget {
  final List<String> titles;
  final int groupValue;
  final Function onSegmentSelected;
  SegmentedControl({this.groupValue, this.onSegmentSelected, this.titles});

  Widget _segment({String title, int index}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 5),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
            color: groupValue == index ? ZAKGreen : Colors.transparent,
            borderRadius: BorderRadius.circular(19),
            boxShadow: [
              BoxShadow(
                  blurRadius: 6,
                  offset: Offset(0, 3),
                  color: groupValue == index
                      ? ZAKGreen.withOpacity(0.16)
                      : Colors.transparent)
            ]),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(
              title,
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: groupValue == index ? Colors.white : ZAKDarkGreen),
            ),
          ),
        ),
      ),
    );
  }

  Map<int, Widget> _getChildren() {
    final Map<int, Widget> children = {};
    for (var title in titles) {
      final index = titles.indexOf(title);
      children[index] = _segment(title: title, index: index);
    }
    return children;
  }

  @override
  Widget build(BuildContext context) {
    final children = _getChildren();

    return Container(
      decoration: BoxDecoration(
        color: ZAKLightGrey,
        borderRadius: BorderRadius.circular(19),
      ),
      child: CupertinoSegmentedControl(
        padding: EdgeInsets.all(0),
        borderColor: Colors.transparent,
        groupValue: groupValue,
        selectedColor: Colors.transparent,
        pressedColor: Colors.transparent,
        children: children,
        unselectedColor: Colors.transparent,
        onValueChanged: onSegmentSelected,
      ),
    );
  }
}
