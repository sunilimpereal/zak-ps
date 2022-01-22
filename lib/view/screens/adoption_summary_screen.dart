import 'package:flutter/material.dart';
import 'package:zak_mobile_app/extensions/text.dart';
import 'package:zak_mobile_app/models/animal.dart';
import 'package:zak_mobile_app/models/zoo.dart';
import 'package:zak_mobile_app/utility/colors.dart';
import 'package:zak_mobile_app/utility/utility.dart';
import 'package:zak_mobile_app/view/screens/provide_adoption_details_screen.dart';
import 'package:zak_mobile_app/view/widgets/item_counter.dart';
import 'package:zak_mobile_app/view/widgets/zak_button.dart';
import 'package:zak_mobile_app/view/widgets/zak_title.dart';

class AdoptionSummaryScreen extends StatefulWidget {
  final List<Animal> selectedAnimals;
  final double totalAmount;
  final Zoo zoo;

  AdoptionSummaryScreen({
    this.totalAmount,
    this.selectedAnimals,
    this.zoo,
  });

  @override
  _AdoptionSummaryScreenState createState() => _AdoptionSummaryScreenState();
}

class _AdoptionSummaryScreenState extends State<AdoptionSummaryScreen> {
  double totalAmount = 0;
  Text _text(String title) {
    return Text(title,
        style: TextStyle(
            fontSize: Theme.of(context).textTheme.caption.fontSize,
            color: ZAKGrey));
  }

  @override
  void initState() {
    totalAmount = widget.totalAmount;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    void addToTotalAmount(double value) {
      setState(() {
        totalAmount += value;
      });
    }

    void subtractFromTotalAmount(double value) {
      setState(() {
        totalAmount -= value;
      });
    }

    const padding = 16.0;
    return Scaffold(
      appBar: ZAKAppBar(),
      body: Stack(
        children: <Widget>[
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(padding),
                  child: ZAKTitle(
                    title: 'Adoption summary',
                  ),
                ),
                Container(
                  width: double.infinity,
                  color: ZAKLightGrey,
                  child: Padding(
                    padding: const EdgeInsets.all(padding),
                    child: widget.selectedAnimals == null
                        ? Text('You havent added anything yet!')
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(bottom: padding),
                                child: widget.zoo.name.withStyle(
                                    color: ZAKDarkGreen,
                                    style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                        color: ZAKDarkGreen,
                                        letterSpacing: -0.2)),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  _text('Animal, Amount/year'),
                                  _text('Duration (years)')
                                ],
                              ),
                              ListView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: widget.selectedAnimals.length,
                                  itemBuilder: (_, index) {
                                    return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: padding),
                                        child: Row(
                                          children: <Widget>[
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            bottom: 8),
                                                    child: widget
                                                        .selectedAnimals[index]
                                                        .name
                                                        .withStyle(
                                                            style:
                                                                subtitleTextStyle(
                                                                    FontWeight
                                                                        .w500),
                                                            color:
                                                                ZAKDarkGreen),
                                                  ),
                                                  ('INR ' +
                                                          widget
                                                              .selectedAnimals[
                                                                  index]
                                                              .amount
                                                              .toString())
                                                      .withStyle(
                                                          style:
                                                              subtitleTextStyle(
                                                                  FontWeight
                                                                      .w500),
                                                          color: ZAKGrey),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 16),
                                              child: Text(widget
                                                  .selectedAnimals[index]
                                                  .numberOfYears
                                                  .toString()),
                                            ),
                                          ],
                                        ));
                                  })
                            ],
                          ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 21, vertical: 16),
                  child: Row(
                    children: <Widget>[
                      'Total Amount'.withStyle(
                          style: subtitleTextStyle(FontWeight.w500),
                          color: ZAKDarkGreen),
                      Spacer(),
                      ('INR ' + totalAmount.toString()).withStyle(
                          style: TextStyle(
                              fontSize: 20,
                              letterSpacing: -0.3,
                              fontWeight: FontWeight.w500),
                          color: ZAKDarkGreen)
                    ],
                  ),
                ),
                SizedBox(height: 100)
              ],
            ),
          ),
          Column(
            children: <Widget>[
              Spacer(),
              Padding(
                padding: const EdgeInsets.only(bottom: 40),
                child: ZAKButton(
                  onPressed: totalAmount == 0
                      ? null
                      : () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (_) => ProvideAdoptionDetailsScreen(
                                  totalAmount,
                                  widget.selectedAnimals,
                                  widget.zoo)));
                        },
                  title: 'Next',
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
