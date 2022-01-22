import 'package:flutter/material.dart';

class ZAKTitle extends StatelessWidget {
  final String title;

  ZAKTitle({this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title ?? '',
      style: Theme.of(context).accentTextTheme.headline3,
    );
  }
}
