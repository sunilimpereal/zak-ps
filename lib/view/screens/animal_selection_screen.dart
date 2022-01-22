import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:zak_mobile_app/models/adoption_group.dart';
import 'package:zak_mobile_app/models/animal.dart';
import 'package:zak_mobile_app/models/zoo.dart';
import 'package:zak_mobile_app/utility/utility.dart';
import 'package:zak_mobile_app/view/screens/adoption_summary_screen.dart';
import 'package:zak_mobile_app/view/widgets/total_amount_button.dart';
import 'package:zak_mobile_app/view/widgets/zak_circular_indicator.dart';
import 'package:zak_mobile_app/view/widgets/zak_dropdown_menu.dart';
import 'package:zak_mobile_app/view/widgets/zak_title.dart';
import 'package:zak_mobile_app/view_models/animal_view_model.dart';
import 'package:zak_mobile_app/view_models/authentication_view_model.dart';

class AnimalSelectionScreen extends StatefulWidget {
  final List<AdoptionGroup> groups;
  final String selectedGroupID;
  final Zoo zoo;

  AnimalSelectionScreen(
      {this.groups, @required this.selectedGroupID, this.zoo});

  @override
  _AnimalSelectionScreenState createState() => _AnimalSelectionScreenState();
}

class _AnimalSelectionScreenState extends State<AnimalSelectionScreen> {
  var isLoading = false;
  double totalAmount = 0;
  AnimalViewModel animalVM;
  final List<Animal> selectedAnimals = [];

  @override
  void initState() {
    super.initState();
    final accessToken =
        Provider.of<AuthenticationViewModel>(context, listen: false).token;
    animalVM = AnimalViewModel(accessToken);
  }

  void _addAnimalToList(Animal animal) {
    if (!selectedAnimals.contains(animal)) {
      selectedAnimals.add(animal);
    }
  }

  void _removeAnimalFromList(Animal _animal) {
    if (selectedAnimals.contains(_animal)) {
      if (_animal.numberOfYears < 1) {
        selectedAnimals.remove(_animal);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ZAKAppBar(),
      body: isLoading
          ? Center(
              child: ZAKCircularIndicator(),
            )
          : Stack(
              children: <Widget>[
                SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: ZAKTitle(
                          title: 'Select animals',
                        ),
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        padding: const EdgeInsets.all(0),
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: widget.groups.length,
                        itemBuilder: (_, index) {
                          return ZAKExpandableMenu(
                              isExpanded: widget.selectedGroupID ==
                                  widget.groups[index].adoptionGroupID,
                              title: widget.groups[index].priceRange,
                              groupID: widget.groups[index].adoptionGroupID,
                              onIncremented:
                                  (double _totalAmount, Animal animal) {
                                setState(() {
                                  totalAmount += _totalAmount;
                                });
                                _addAnimalToList(animal);
                              },
                              onDecremented:
                                  (double _totalAmount, Animal animal) {
                                setState(() {
                                  totalAmount -= _totalAmount;
                                });
                                _removeAnimalFromList(animal);
                              });
                        },
                      ),
                      SizedBox(height: 100)
                    ],
                  ),
                ),
                Column(
                  children: <Widget>[
                    Spacer(),
                    totalAmount == 0
                        ? Container()
                        : Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 30, horizontal: 16),
                            child: TotalAmountButton(
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (_) => AdoptionSummaryScreen(
                                          totalAmount: totalAmount,
                                          selectedAnimals: selectedAnimals,
                                          zoo: widget.zoo,
                                        )));
                              },
                              total: totalAmount,
                              numberOfAnimals: selectedAnimals.length,
                            ),
                          )
                  ],
                )
              ],
            ),
    );
  }
}
