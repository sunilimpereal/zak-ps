import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zak_mobile_app/models/animal.dart';
import 'package:zak_mobile_app/models/ticket_subcategory.dart';
import 'package:zak_mobile_app/utility/colors.dart';
import 'package:zak_mobile_app/extensions/text.dart';
import 'package:zak_mobile_app/view/widgets/item_counter.dart';
import 'package:zak_mobile_app/view/widgets/zak_circular_indicator.dart';
import 'package:zak_mobile_app/view_models/animal_view_model.dart';
import 'package:zak_mobile_app/view_models/authentication_view_model.dart';

class ZAKExpandablBookingSection extends StatefulWidget {
  final bool isExpanded;
  final String title;
  final String subTitle;
  final List<TicketSubCategory> tickets;
  final String groupID;
  final Widget widget;
  final Function onIncremented;
  final Function onDecremented;

  ZAKExpandablBookingSection(
      {this.isExpanded = false,
      this.title = '',
      this.subTitle = '',
      this.tickets,
      this.widget,
      this.groupID,
      this.onIncremented,
      this.onDecremented});
  @override
  _ZAKExpandablBookingSectionState createState() =>
      _ZAKExpandablBookingSectionState();
}

class _ZAKExpandablBookingSectionState
    extends State<ZAKExpandablBookingSection> {
  bool _isExpanded = false;
  AnimalViewModel animalVM;
  int totalNumberOfAnimals = 0;
  double totalAmount = 0;

  bool isLoading = false;
  List<TicketSubCategory> selectedTickets = [];
  List<TicketSubCategory> tickets;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.isExpanded;
    tickets = widget.tickets;
  }

  @override
  Widget build(BuildContext context) {
    Text _text(String title) {
      return Text(title,
          style: TextStyle(
              fontSize: Theme.of(context).textTheme.caption.fontSize,
              color: ZAKGrey));
    }

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

    return Container(
      color: _isExpanded ? Colors.transparent : ZAKLightGrey,
      child: ListTileTheme(
        contentPadding: const EdgeInsets.all(0),
        child: Theme(
          data: ThemeData(
              backgroundColor: Colors.transparent,
              dividerColor: Colors.transparent,
              fontFamily: 'Montserrat'),
          child: ExpansionTile(
            initiallyExpanded: widget.isExpanded,
            onExpansionChanged: (isExpanded) {
              setState(() {
                _isExpanded = isExpanded;
              });
            },
            title: Container(
              height: 83,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          //   width: MediaQuery.of(context).size.width * 0.7,
                          child: widget.title.withStyle(
                              color: ZAKDarkGreen,
                              style: Theme.of(context).textTheme.headline6,
                              overflow: true),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 11),
                          child: widget.subTitle.withStyle(
                            color: ZAKGrey,
                            style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                letterSpacing: -0.2,
                                height: 1.5),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    _isExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: ZAKGreen,
                  ),
                ],
              ),
            ),
            trailing: Container(width: 0),
            children: <Widget>[
              Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        _text('Ticket type'),
                        _text('Quantity')
                      ],
                    ),
                  ),
                  isLoading
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ZAKCircularIndicator(),
                          ),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: tickets.length,
                          itemBuilder: (_, index) {
                            return Padding(
                              padding: const EdgeInsets.all(16),
                              child: ItemCounter(
                                subtitle:
                                    'INR ' + tickets[index].price.toString(),
                                title: tickets[index].name +
                                    " " +
                                    tickets[index].type +
                                    " ",
                                count: tickets[index].quantity,
                                onDecremented: (int count) {
                                  if (count == 0) {
                                    if (selectedTickets
                                        .contains(tickets[index])) {
                                      selectedTickets.remove(tickets[index]);
                                    }
                                  }
                                  final difference =
                                      tickets[index].quantity - count;
                                  tickets[index].quantity = count;
                                  totalNumberOfAnimals -= 1;
                                  final amount = difference *
                                      double.parse(tickets[index].price);
                                  subtractFromTotalAmount(amount);
                                  widget.onDecremented(amount, tickets[index]);
                                },
                                onInremented: (int count) {
                                  if (count == 1) {
                                    if (!selectedTickets
                                        .contains(tickets[index])) {
                                      selectedTickets.add(tickets[index]);
                                    }
                                  }
                                  final difference =
                                      count - tickets[index].quantity;
                                  tickets[index].quantity = count;
                                  totalNumberOfAnimals += 1;
                                  final amount = difference *
                                      double.parse(tickets[index].price);
                                  addToTotalAmount(amount);
                                  widget.onIncremented(amount, tickets[index]);
                                },
                              ),
                            );
                          },
                        )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
