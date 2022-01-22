import 'package:flutter/material.dart';
import 'package:zak_mobile_app/constants.dart';
import 'package:zak_mobile_app/models/lineItem.dart';
import 'package:zak_mobile_app/models/ticket_category.dart';
import 'package:zak_mobile_app/models/ticket_subcategory.dart';
import 'package:zak_mobile_app/models/ticket_summary.dart';
import 'package:zak_mobile_app/models/zoo.dart';
import 'package:zak_mobile_app/utility/utility.dart';
import 'package:zak_mobile_app/view/screens/ticket_summary.dart';
import 'package:zak_mobile_app/view/widgets/total_amount_button.dart';
import 'package:zak_mobile_app/view/widgets/zak_gradient_button.dart';
import 'package:zak_mobile_app/view/widgets/zak_title.dart';
import 'package:zak_mobile_app/view/widgets/item_counter.dart';

class TicketQuantitySelectorScreen extends StatefulWidget {
  final String ticketType;
  final Zoo zoo;
  final TicketCategory category;

  TicketQuantitySelectorScreen(
      {this.ticketType, this.zoo, @required this.category});
  @override
  _TicketQuantitySelectorScreenState createState() =>
      _TicketQuantitySelectorScreenState();
}

class _TicketQuantitySelectorScreenState
    extends State<TicketQuantitySelectorScreen> {
  TicketSummary summary;
  List<TicketSubCategory> subcategories = [];
  int price = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ZAKAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 24),
            child: ZAKTitle(
              title: widget.zoo.name,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 24),
            child: Text('Select Number of ${widget.ticketType} Ticket'),
          ),
          Expanded(
            child: Column(
              children: List.generate(
                widget.category.subcategory.length,
                (index) => Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ItemCounter(
                    count: 0,
                    onInremented: (count) {
                      setState(() {
                        price += double.parse(
                                widget.category.subcategory[index].price)
                            .toInt();
                        widget.category.subcategory[index].quantity = count;
                        if (count == 1) {
                          subcategories.add(widget.category.subcategory[index]);
                        }
                      });
                    },
                    onDecremented: (count) {
                      setState(() {
                        price -= double.parse(
                                widget.category.subcategory[index].price)
                            .toInt();
                        widget.category.subcategory[index].quantity = count;
                        if (count < 1) {
                          subcategories
                              .remove(widget.category.subcategory[index]);
                        }
                      });
                    },
                    title: widget.category.subcategory[index].name +
                            "-" +
                            widget.category.subcategory[index].type ??
                        " ",
                    subtitle: widget.category.subcategory[index].price ?? " ",
                  ),
                ),
              ),
            ),
          ),
          TotalAmountButton(
            total: price.toDouble(),
            onPressed: () {
              if (subcategories.isNotEmpty) {
                List<LineItem> lineItems = [];
                for (var items in subcategories) {
                  lineItems.add(LineItem(
                      category: widget.ticketType,
                      price:
                          ((double.parse(items.price)).toInt() * items.quantity)
                              .toString(),
                      id: items.id,
                      quantity: items.quantity,
                      subCategoryName: items.name + "-" + items.type,
                      subCategoryPrice:
                          double.parse(items.price).toInt().toString(),
                      type: items.type));
                }
                summary = TicketSummary(
                    lineitems: lineItems,
                    organizationId: widget.zoo.organizationId,
                    totalAmount: price,
                    razorPayAPIkey: widget.zoo.razorPayAPIKey,
                    zooName: widget.zoo.name);
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => TicketSummaryScreen(summary)));
              }
            },
          ),
          SizedBox(
            height: 20,
          )
        ]),
      ),
    );
  }
}
