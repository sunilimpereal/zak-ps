import 'package:flutter/material.dart';
import 'package:zak_mobile_app/utility/colors.dart';
import 'package:zak_mobile_app/utility/utility.dart';

class TotalAmountButton extends StatelessWidget {
  final double total;
  final int numberOfAnimals;
  final Function onPressed;

  TotalAmountButton({this.onPressed, this.total, this.numberOfAnimals});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: getGradientDecoration(),
      child: FlatButton(
        disabledColor: ZAKGreen.withOpacity(0.5),
        disabledTextColor: Colors.white,
        color: ZAKGreen,
        textColor: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Text(
                      ('TOTAL - INR ' + total.toString()),
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          letterSpacing: -0.2),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                    ),
                  ),
                  numberOfAnimals != null
                      ? Text(
                          (numberOfAnimals.toString() +
                              (numberOfAnimals == 1 ? ' animal' : ' animals')),
                          style: TextStyle(
                              fontSize: 8,
                              fontWeight: FontWeight.w500,
                              letterSpacing: -0.12),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                        )
                      : Container()
                ],
              ),
              Spacer(),
              Text(
                'Proceed',
                style: subtitleTextStyle(FontWeight.w500),
                textAlign: TextAlign.center,
                maxLines: 1,
              ),
            ],
          ),
        ),
        onPressed: onPressed,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
      ),
    );
  }
}
