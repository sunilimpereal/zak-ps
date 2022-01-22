import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:zak_mobile_app/models/ticket_summary.dart';
import 'package:zak_mobile_app/utility/colors.dart';
import 'package:zak_mobile_app/utility/utility.dart';
import 'package:zak_mobile_app/view/screens/user_ticket_screen.dart';
import 'package:zak_mobile_app/view/widgets/item_counter.dart';
import 'package:zak_mobile_app/view/widgets/zak_button.dart';
import 'package:zak_mobile_app/view/widgets/zak_gradient_button.dart';
import 'package:zak_mobile_app/view/widgets/zak_title.dart';
import 'package:zak_mobile_app/extensions/text.dart';

class TicketSummaryScreen extends StatefulWidget {
  final TicketSummary summary;
  TicketSummaryScreen(this.summary);

  @override
  _TicketSummaryScreenState createState() => _TicketSummaryScreenState();
}

class _TicketSummaryScreenState extends State<TicketSummaryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ZAKAppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: ZAKTitle(title: 'Ticket Summary'),
                  ),
                  Container(
                    width: double.infinity,
                    color: ZAKLightGrey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: widget.summary.zooName.withStyle(
                              color: ZAKDarkGreen,
                              style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: ZAKDarkGreen,
                                  letterSpacing: -0.2)),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            // _text('Animal, Amount/year'),
                            // _text('Duration (years)')
                          ],
                        ),
                        ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: widget.summary.lineitems.length,
                            itemBuilder: (_, index) {
                              return Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 8),
                                            child: widget
                                                .summary
                                                .lineitems[index]
                                                .subCategoryName
                                                .withStyle(
                                                    style: subtitleTextStyle(
                                                        FontWeight.w500),
                                                    color: ZAKDarkGreen),
                                          ),
                                          widget.summary.lineitems[index].price
                                              .withStyle(
                                                  style: subtitleTextStyle(
                                                      FontWeight.w500),
                                                  color: ZAKGrey),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(right: 16),
                                      child: Text(widget
                                          .summary.lineitems[index].quantity
                                          .toString()),
                                    ),
                                  ],
                                ),
                              );
                            })
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 16),
                    child: Row(
                      children: <Widget>[
                        'Total Amount'.withStyle(
                            style: subtitleTextStyle(FontWeight.w500),
                            color: ZAKDarkGreen),
                        Spacer(),
                        ('INR ${widget.summary.totalAmount.toString()}'
                            .withStyle(
                                style: TextStyle(
                                    fontSize: 20,
                                    letterSpacing: -0.3,
                                    fontWeight: FontWeight.w500),
                                color: ZAKDarkGreen))
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: ZAKButton(
                title: 'Next',
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => UserTicketFormScreen(
                            summary: widget.summary,
                          )));
                },
              ),
            ),
          ),
          SizedBox(
            height: 10,
          )
        ],
      ),
    );
  }
}
