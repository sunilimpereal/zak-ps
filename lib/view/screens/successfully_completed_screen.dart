import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:zak_mobile_app/models/zoo.dart';

import 'package:zak_mobile_app/utility/colors.dart';
import 'package:zak_mobile_app/utility/utility.dart';
import 'package:zak_mobile_app/view/screens/home_screen.dart';
import 'package:zak_mobile_app/view/widgets/zak_button.dart';
import 'package:zak_mobile_app/view/widgets/zak_title.dart';
import 'package:zak_mobile_app/extensions/text.dart';

class SuccessfullyCompletedPayment extends StatelessWidget {
  final bool didCompleteDonating;
  final List<String> animalNames;
  final Zoo zoo;

  SuccessfullyCompletedPayment(
      {@required this.didCompleteDonating, this.animalNames, this.zoo});

  @override
  Widget build(BuildContext context) {
    final repaintBoundaryKey = GlobalKey();
    final _scaffoldKey = GlobalKey<ScaffoldState>();

    void showCannotShareImageSnackBar() {
      showSnackbar(_scaffoldKey, 'Unable to share the image currently.', () {});
    }

    Future<Uint8List> convertToImage() async {
      try {
        RenderRepaintBoundary boundary =
            repaintBoundaryKey.currentContext.findRenderObject();
        final image = await boundary.toImage(pixelRatio: 3.0);
        final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
        var imageBytes = byteData.buffer.asUint8List();
        return imageBytes;
      } catch (exception) {
        return null;
      }
    }

    Future<void> shareImage(Uint8List imageBytes) async {
      try {
        await Share.file(
            'Zoos of Karnataka', 'image.png', imageBytes, 'image/png');
      } catch (e) {
        showCannotShareImageSnackBar();
      }
    }

    String getAnimalsNames() {
      final joinedAnimalsNames = animalNames.join(', ');
      final lastCommaIndex = joinedAnimalsNames.lastIndexOf(',');
      if (lastCommaIndex > 0) {
        return joinedAnimalsNames.replaceRange(
            lastCommaIndex, lastCommaIndex + 1, ', and');
      }
      return joinedAnimalsNames;
    }

    final zooNameAndCityText = zoo.name +
        (zoo.city == null ? '' : zoo.city.isEmpty ? '' : ', ' + zoo.city) +
        '.';

    final zooNames = didCompleteDonating ? '' : getAnimalsNames();

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => HomeScreen()),
                  (route) => false);
            }),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: ZAKTitle(
                    title: didCompleteDonating
                        ? 'Donation Successful'
                        : 'Adoption Successful'),
              ),
              Text(
                'Zoo Authority of Karnataka is thankful for your contribution made towards the noble cause and for your involvement in the conservation efforts!',
                style: TextStyle(
                  color: ZAKGrey,
                  fontSize: 15,
                  letterSpacing: -0.23,
                  fontWeight: FontWeight.w500,
                  height: 1.6,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 24),
                child: RepaintBoundary(
                  key: repaintBoundaryKey,
                  child: Container(
                    padding: const EdgeInsets.only(left: 16),
                    width: double.infinity,
                    color: ZAKGreen,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Stack(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(top: 16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Image.asset('assets/images/WhiteZAKLogo.png'),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8),
                                    child: 'Zoo Authority of Karnataka'
                                        .withStyle(
                                            style: TextStyle(
                                                fontSize: Theme.of(context)
                                                    .textTheme
                                                    .caption
                                                    .fontSize,
                                                fontWeight: FontWeight.w500),
                                            color: ZAKDarkGreen),
                                  ),
                                  Padding(
                                      padding: const EdgeInsets.only(
                                          right: 75, top: 24),
                                      child: RichText(
                                        text: TextSpan(
                                          text: didCompleteDonating
                                              ? 'I just donated to '
                                              : 'I just adopted ',
                                          style: TextStyle(
                                            fontFamily: 'Montserrat',
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500,
                                            height: 1.6,
                                            color: Colors.white,
                                          ),
                                          children: <TextSpan>[
                                            TextSpan(
                                                text: didCompleteDonating
                                                    ? zooNameAndCityText
                                                    : animalNames.length > 1
                                                        ? zooNames.replaceRange(
                                                            zooNames.indexOf(
                                                                ', and'),
                                                            zooNames.length,
                                                            ', ')
                                                        : '',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            TextSpan(
                                                text: didCompleteDonating
                                                    ? ''
                                                    : animalNames.length > 1
                                                        ? 'and '
                                                        : ''),
                                            TextSpan(
                                                text: didCompleteDonating
                                                    ? ''
                                                    : animalNames.length > 1
                                                        ? zooNames
                                                            .substring(
                                                                zooNames.indexOf(
                                                                    ', and'),
                                                                zooNames.length)
                                                            .replaceFirst(
                                                                ', and', '')
                                                        : '',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            TextSpan(
                                                text: didCompleteDonating
                                                    ? ''
                                                    : ' from '),
                                            TextSpan(
                                                text: didCompleteDonating
                                                    ? ''
                                                    : zooNameAndCityText,
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ],
                                        ),
                                      )),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      top: 24,
                                    ),
                                    child: 'You too can!'.withStyle(
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500),
                                        color: Colors.white),
                                  ),
                                  Padding(
                                      padding: const EdgeInsets.only(
                                          right: 24, bottom: 16),
                                      child: RichText(
                                          text: TextSpan(
                                        style: TextStyle(
                                            fontFamily: 'Montserrat',
                                            fontSize: Theme.of(context)
                                                .textTheme
                                                .caption
                                                .fontSize,
                                            height: 1.6),
                                        children: <TextSpan>[
                                          TextSpan(
                                            text: 'Download the ',
                                          ),
                                          TextSpan(
                                              text: '\'Zoos of Karnataka\'',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold)),
                                          TextSpan(
                                            text:
                                                ' app now to adopt animals and to donate to the zoo.',
                                          ),
                                        ],
                                      ))),
                                  Row(
                                    children: <Widget>[
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 4),
                                        child: Image.asset(
                                            'assets/images/GooglePlayBadge.png'),
                                      ),
                                      Image.asset(
                                          'assets/images/AppStoreBadge.png')
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        bottom: 16, top: 24),
                                    child: '#AnimalLove'.withStyle(
                                        style: TextStyle(
                                            fontSize: 30,
                                            fontWeight: FontWeight.bold),
                                        color: Colors.white),
                                  )
                                ],
                              ),
                            ),
                            Align(
                                alignment: Alignment.topRight,
                                child: Image.asset(
                                    'assets/images/AnimalsAndPattern.png')),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 77, right: 77, top: 61),
                child: Text(
                  'Share it with your friends and spread the message!',
                  style: TextStyle(
                    color: ZAKGrey,
                    fontSize: 15,
                    letterSpacing: -0.23,
                    fontWeight: FontWeight.w500,
                    height: 1.6,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 24, bottom: 40),
                child: ZAKButton(
                  title: 'Share',
                  onPressed: () async {
                    final imageBytes = await convertToImage();
                    if (imageBytes != null) {
                      // ignore: unawaited_futures
                      shareImage(imageBytes);
                    } else {
                      showCannotShareImageSnackBar();
                    }
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
