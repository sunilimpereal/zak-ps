import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:zak_mobile_app/models/ticketrequest.dart';
import 'package:zak_mobile_app/utility/utility.dart';
import 'package:zak_mobile_app/view/widgets/zak_title.dart';

class TicketDetailsScreen extends StatelessWidget {
  TicketRequestModel ticket;
  static const routeName = 'TicketDetails';
  TicketDetailsScreen(this.ticket);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        getFormattedDate(
                            DateTime.parse(ticket.userDetails.dateOfVisit)),
                      ),
                      ZAKTitle(
                        title: ticket.organizationName,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Center(
                          child: ticket.isScanned
                              ? Container(
                                  color: Colors.black,
                                  // child: QrImage(
                                  //   data: ticket.qrCode,
                                  //   version: QrVersions.auto,
                                  //   size: 180.0,
                                  // ),
                                )
                              : Container(
                                  child: QrImage(
                                    data: ticket.qrCode,
                                    version: QrVersions.auto,
                                    size: 180.0,
                                  ),
                                ),
                        ),
                      ),
                      Center(
                          child: ticket.isScanned
                              ? Text('Consumed',
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 20))
                              : Text('Yet to visit',
                                  style: TextStyle(
                                      color: Colors.green,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 20))),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Divider(),
                      ),
                      Column(
                        children: [
                          ZAKTitle(title: 'Ticket Summary'),
                          Padding(
                            padding: const EdgeInsets.only(top: 15),
                            child: Column(
                              children: List.generate(
                                ticket.lineItems.length,
                                (index) => Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(ticket.lineItems[index].quantity
                                            .toString() +
                                        ' x ' +
                                        ticket
                                            .lineItems[index].subCategoryName),
                                    Text(
                                        'Rs ${ticket.lineItems[index].subCategoryPrice}')
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Divider(),
                          Padding(
                            padding: const EdgeInsets.only(top: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Total Fare',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                                Text(
                                  'Rs ${ticket.price}',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
