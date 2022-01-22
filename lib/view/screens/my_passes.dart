import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zak_mobile_app/models/pass.dart';
import 'package:zak_mobile_app/utility/colors.dart';
import 'package:zak_mobile_app/utility/utility.dart';
import 'package:zak_mobile_app/view/widgets/empty_activity.dart';
import 'package:zak_mobile_app/view/widgets/zak_circular_indicator.dart';
import 'package:zak_mobile_app/view_models/authentication_view_model.dart';
import 'package:zak_mobile_app/view_models/pass_view_model.dart';
import 'tickets_passes/pass_details.dart';

class MyPasses extends StatefulWidget {
  @override
  _MyPassesState createState() => _MyPassesState();
}

class _MyPassesState extends State<MyPasses> {
  List<Pass> passes = [];
  bool isLoading = true;

  void getPasses() async {
    final accessToken =
        Provider.of<AuthenticationViewModel>(context, listen: false).token;
    final donationVM = PassViewModel(accessToken);
    passes = await donationVM.getPasses();
    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getPasses();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(
            child: ZAKCircularIndicator(),
          )
        : passes.isEmpty
            ? EmptyActivity(
                imagePath: 'assets/images/SlenderLorisImage.png',
                secondaryText:
                    'Looks like you have not earned any free passes yet.',
                primaryText: 'Hmm!',
                alignment: ImageAlignment.Center,
              )
            : Padding(
                padding: const EdgeInsets.all(16),
                child: ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: passes.length,
                    itemBuilder: (_, index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  PassDetailScreen(passes[index])));
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: Text(
                                  (passes[index].numberOfMembers.toString() +
                                      ' Passes, ' +
                                      passes[index].numberOfVisits.toString() +
                                      (passes[index].numberOfVisits == 1
                                          ? ' visit'
                                          : ' visits') +
                                      ' per year'),
                                  style: TextStyle(
                                      color: ZAKDarkGreen, fontSize: 15),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: Text(
                                  passes[index].zooName,
                                  style:
                                      TextStyle(color: ZAKGrey, fontSize: 15),
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.6,
                                child: Text(
                                  passes[index].startDate == null
                                      ? ''
                                      : getFormattedDate(
                                          passes[index].startDate),
                                  style: TextStyle(
                                    color: ZAKGrey,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                              passes[index].remainingPasses == 0
                                  ? Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10),
                                      child: Text('Consumed',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              color: Colors.red)),
                                    )
                                  : Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10),
                                      child: Text('Active',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              color: Colors.green)),
                                    )
                            ],
                          ),
                        ),
                      );
                    }),
              );
  }
}
