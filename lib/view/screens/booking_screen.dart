import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zak_mobile_app/models/animal.dart';
import 'package:zak_mobile_app/models/lineItem.dart';
import 'package:zak_mobile_app/models/ticket_category.dart';
import 'package:zak_mobile_app/models/ticket_subcategory.dart';
import 'package:zak_mobile_app/models/ticket_summary.dart';
import 'package:zak_mobile_app/models/zoo.dart';
import 'package:zak_mobile_app/utility/utility.dart';
import 'package:zak_mobile_app/view/screens/ticket_quantity_screen.dart';
import 'package:zak_mobile_app/view/screens/ticket_summary.dart';
import 'package:zak_mobile_app/view/widgets/total_amount_button.dart';
import 'package:zak_mobile_app/view/widgets/zak_app_bar_with_logo.dart';
import 'package:zak_mobile_app/view/widgets/zak_dropdown_ticketbooking.dart';
import 'package:zak_mobile_app/view/widgets/zak_title.dart';
import 'package:zak_mobile_app/view/widgets/zoo_overview_card.dart';
import 'package:zak_mobile_app/view_models/authentication_view_model.dart';
import 'package:zak_mobile_app/view_models/ticket_view_model.dart';

class BookingScreen extends StatefulWidget {
  final Zoo zoo;
  BookingScreen({
    @required this.zoo,
  });

  @override
  _BookingScreenState createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  TicketViewModel ticketVM;

  TicketSummary summary;

  ValueNotifier<double> price = ValueNotifier(0);
  List<TicketSubCategory> selectedSubCategory = [];

  @override
  void initState() {
    final accessToken =
        Provider.of<AuthenticationViewModel>(context, listen: false).token;
    ticketVM = TicketViewModel(accessToken);
    // TODO: implement initState
    super.initState();
  }

  void _addTicketToList(TicketSubCategory animal) {
    if (!selectedSubCategory.contains(animal)) {
      selectedSubCategory.add(animal);
    }
  }

  void _removeTicketFromList(TicketSubCategory _animal) {
    if (selectedSubCategory.contains(_animal)) {
      if (_animal.quantity < 1) {
        selectedSubCategory.remove(_animal);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ZAKAppBar(),
      body: Stack(
        children: [
          FutureBuilder<List<TicketCategory>>(
              future: ticketVM.getCategories(widget.zoo.id),
              builder: (context, AsyncSnapshot<List<TicketCategory>> snapshotAsync) {
                if (snapshotAsync.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else {
                  List<TicketCategory> ticketCategorys = snapshotAsync.data.where((element) => element.mode=="online").toList();
                  return SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 24),
                            child: ZAKTitle(
                              title: widget.zoo.name,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 24),
                            child: Text('Select ticket type'),
                          ),

                          Column(
                            children: List.generate(
                              ticketCategorys.length,
                              (index) => ZAKExpandablBookingSection(
                                isExpanded: false,
                                title: ticketCategorys[index].name,
                                tickets: ticketCategorys[index].subcategory,
                                onIncremented: (double _totalAmount,
                                    TicketSubCategory animal) {
                                  //   setState(() {
                                  price.value += _totalAmount;
                                  //  });
                                  _addTicketToList(animal);
                                },
                                onDecremented: (double _totalAmount,
                                    TicketSubCategory animal) {
                                  // setState(() {
                                  price.value -= _totalAmount;
                                  // });
                                  _removeTicketFromList(animal);
                                },
                              ),
                            ),
                          ),

                          // Column(
                          //   children: List.generate(
                          //       snapshot.data.length,
                          //       (index) => Padding(
                          //             padding: const EdgeInsets.only(bottom: 24),
                          //             child: ZooOverviewCard(
                          //               title: snapshot.data[index].name,
                          //               buttonTitle: 'Continue Booking',
                          //               onPressed: () {
                          //                 Navigator.of(context).push(
                          //                     MaterialPageRoute(
                          //                         builder: (_) =>
                          //                             TicketQuantitySelectorScreen(
                          //                               zoo: widget.zoo,
                          //                               category:
                          //                                   snapshot.data[index],
                          //                               ticketType: snapshot
                          //                                   .data[index].name,
                          //                             )));
                          //               },
                          //             ),
                          //           )),
                          // )
                        ],
                      ),
                    ),
                  );
                }
              }),
          Column(
            children: [
              Spacer(),
              ValueListenableBuilder<double>(
                valueListenable: price,
                builder: (context, price, child) => Column(
                  children: <Widget>[
                    price == 0
                        ? Container()
                        : Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 30, horizontal: 16),
                            child: TotalAmountButton(
                              onPressed: () {
                                if (selectedSubCategory.isNotEmpty) {
                                  List<LineItem> lineItems = [];
                                  for (var items in selectedSubCategory) {
                                    lineItems.add(LineItem(
                                        category: 'Category',
                                        price: price.toString(),
                                        id: items.id,
                                        quantity: items.quantity,
                                        subCategoryName:
                                            items.name + "-" + items.type,
                                        subCategoryPrice:
                                            double.parse(items.price)
                                                .toInt()
                                                .toString(),
                                        type: items.type));
                                  }
                                  summary = TicketSummary(
                                      lineitems: lineItems,
                                      organizationId: widget.zoo.organizationId,
                                      totalAmount: price.toInt(),
                                      razorPayAPIkey: widget.zoo.razorPayAPIKey,
                                      zooName: widget.zoo.name);
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (_) =>
                                          TicketSummaryScreen(summary)));
                                }
                                // Navigator.of(context).push(MaterialPageRoute(
                                //     builder: (_) => AdoptionSummaryScreen(
                                //           totalAmount: totalAmount,
                                //           selectedAnimals: selectedAnimals,
                                //           zoo: widget.zoo,
                                //         )));
                              },
                              total: price,
                              //   numberOfAnimals: selectedAnimals.length,
                            ),
                          )
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
