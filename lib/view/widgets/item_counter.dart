import 'package:flutter/material.dart';

import 'package:zak_mobile_app/extensions/text.dart';
import 'package:zak_mobile_app/utility/colors.dart';
import 'package:zak_mobile_app/utility/utility.dart';

class ItemCounter extends StatefulWidget {
  final String title;
  final String subtitle;
  final int count;
  final Function onInremented;
  final Function onDecremented;

  ItemCounter(
      {this.title,
      this.subtitle,
      this.count,
      this.onDecremented,
      this.onInremented});

  @override
  _ItemCounterState createState() => _ItemCounterState();
}

class _ItemCounterState extends State<ItemCounter> {
  int numberOfYears = 0;

  void _decrement() {
    if (numberOfYears > 0) {
      setState(() {
        numberOfYears -= 1;
      });
      widget.onDecremented(numberOfYears);
    }
  }

  void _increment() {
    setState(() {
      numberOfYears += 1;
    });
    widget.onInremented(numberOfYears);
  }

  @override
  void initState() {
    super.initState();
    numberOfYears = widget.count;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: widget.title.withStyle(
                      style: subtitleTextStyle(FontWeight.w500),
                      color: ZAKDarkGreen),
                ),
                widget.subtitle.withStyle(
                    style: subtitleTextStyle(FontWeight.w500), color: ZAKGrey),
              ],
            ),
          ),
          Container(
            height: 34,
            decoration: BoxDecoration(
                border: Border.all(color: ZAKGrey),
                borderRadius: BorderRadius.circular(17)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: InkWell(
                    onTap: _decrement,
                    child: Icon(
                      Icons.remove,
                      color: ZAKGreen,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Container(
                    // width: 20,
                    child: Center(
                      child: numberOfYears.toString().withStyle(
                          style: subtitleTextStyle(FontWeight.w500),
                          color: ZAKDarkGreen),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: InkWell(
                    onTap: _increment,
                    child: Icon(
                      Icons.add,
                      color: ZAKGreen,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
