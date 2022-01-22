import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zak_mobile_app/models/animal.dart';
import 'package:zak_mobile_app/utility/colors.dart';
import 'package:zak_mobile_app/extensions/text.dart';
import 'package:zak_mobile_app/view/widgets/item_counter.dart';
import 'package:zak_mobile_app/view/widgets/zak_circular_indicator.dart';
import 'package:zak_mobile_app/view_models/animal_view_model.dart';
import 'package:zak_mobile_app/view_models/authentication_view_model.dart';

class ZAKExpandableMenu extends StatefulWidget {
  final bool isExpanded;
  final String title;
  final String subTitle;
  final List<Animal> animals;
  final String groupID;
  final Widget widget;
  final Function onIncremented;
  final Function onDecremented;

  ZAKExpandableMenu(
      {this.isExpanded = false,
      this.title = '',
      this.subTitle = '',
      this.animals,
      this.widget,
      this.groupID,
      this.onIncremented,
      this.onDecremented});
  @override
  _ZAKExpandableMenuState createState() => _ZAKExpandableMenuState();
}

class _ZAKExpandableMenuState extends State<ZAKExpandableMenu> {
  bool _isExpanded = false;
  AnimalViewModel animalVM;
  int totalNumberOfAnimals = 0;
  double totalAmount = 0;
  List<Animal> animals = [];
  bool isLoading = true;
  List<Animal> selectedAnimals = [];

  void _getAnimalsOfGroup(String groupID) async {
    final accessToken =
        Provider.of<AuthenticationViewModel>(context, listen: false).token;
    animalVM = AnimalViewModel(accessToken);
    animals = await animalVM.getAdoptionGroups(groupID);
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.isExpanded;
    _getAnimalsOfGroup(widget.groupID);
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
                          width: MediaQuery.of(context).size.width * 0.7,
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
                        _text('Animal, Amount/year'),
                        _text('Duration (years)')
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
                          itemCount: animals.length,
                          itemBuilder: (_, animalIndex) {
                            return Padding(
                              padding: const EdgeInsets.all(16),
                              child: ItemCounter(
                                subtitle: 'INR ' +
                                    animals[animalIndex].amount.toString(),
                                title: animals[animalIndex].name,
                                count: animals[animalIndex].numberOfYears,
                                onDecremented: (int count) {
                                  if (count == 0) {
                                    if (selectedAnimals
                                        .contains(animals[animalIndex])) {
                                      selectedAnimals
                                          .remove(animals[animalIndex]);
                                    }
                                  }
                                  final difference =
                                      animals[animalIndex].numberOfYears -
                                          count;
                                  animals[animalIndex].numberOfYears = count;
                                  totalNumberOfAnimals -= 1;
                                  final amount =
                                      difference * animals[animalIndex].amount;
                                  subtractFromTotalAmount(amount);
                                  widget.onDecremented(
                                      amount, animals[animalIndex]);
                                },
                                onInremented: (int count) {
                                  if (count == 1) {
                                    if (!selectedAnimals
                                        .contains(animals[animalIndex])) {
                                      selectedAnimals.add(animals[animalIndex]);
                                    }
                                  }
                                  final difference = count -
                                      animals[animalIndex].numberOfYears;
                                  animals[animalIndex].numberOfYears = count;
                                  totalNumberOfAnimals += 1;
                                  final amount =
                                      difference * animals[animalIndex].amount;
                                  addToTotalAmount(amount);
                                  widget.onIncremented(
                                      amount, animals[animalIndex]);
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
