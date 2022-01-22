import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:zak_mobile_app/models/pass.dart';
import 'package:zak_mobile_app/utility/utility.dart';
import 'package:zak_mobile_app/view/widgets/zak_title.dart';

class PassDetailScreen extends StatelessWidget {
  Pass pass;
  PassDetailScreen(this.pass);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                ZAKTitle(
                  title: pass.zooName,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: Center(
                    child: QrImage(
                      data: pass.qrCode,
                      size: 150,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                      child: Text(
                          'Validity : ${getFormattedDate(pass.startDate)} - ${getFormattedDate(pass.endDate)}',
                          style: TextStyle(
                              color: Color(0XFF006400),
                              fontWeight: FontWeight.w600,
                              fontSize: 17))),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Divider(),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Center(
                    child: ZAKTitle(
                      title: 'Pass Summary',
                    ),
                  ),
                ),
                PassListTile(
                  title: 'Granted Passes',
                  number: pass.totalPasses.toString(),
                ),
                PassListTile(
                  title: 'Remaining passes',
                  number: pass.remainingPasses.toString(),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PassListTile extends StatelessWidget {
  final String title;
  final String number;
  const PassListTile({this.number, this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 17),
          ),
          Text(number.toString(), style: TextStyle(fontSize: 18))
        ],
      ),
    );
  }
}
