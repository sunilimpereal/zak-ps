import 'package:flutter/material.dart';
import 'package:zak_mobile_app/models/vehicleBooking.dart/day_available_response.dart';
import 'package:zak_mobile_app/utility/colors.dart';
import 'package:zak_mobile_app/utility/utility.dart';

class VehicleAvailablityListTile extends StatefulWidget {
  final Function onSelect;
  final bool restricted;
  final AvailableVehicleModel vehicle;
  VehicleAvailablityListTile({this.onSelect, this.restricted, this.vehicle});

  @override
  _VehicleAvailablityListTileState createState() =>
      _VehicleAvailablityListTileState();
}

class _VehicleAvailablityListTileState
    extends State<VehicleAvailablityListTile> {
  int quantity = 0;
  // _onDecrement() {
  //   setState(() {
  //     if (quantity > 0) {
  //       quantity--;
  //       widget.onChanged(quantity);
  //     }
  //   });
  // }

  // _onIncrement() {
  //   setState(() {
  //     if (quantity < widget.vehicle.quantity && !widget.restricted) {
  //       quantity++;
  //       widget.onChanged(quantity);
  //     }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
          color: ZAKLightGrey,
          border: Border.all(width: 0.2),
          borderRadius: BorderRadius.circular(10)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            widget.vehicle.startTime,
            style: TextStyle(fontWeight: FontWeight.w600, color: ZAKDarkGreen),
          ),
          Container(
            width: 100,
            child: Container(
              height: 34,
              decoration: BoxDecoration(
                  border: Border.all(color: ZAKGrey),
                  borderRadius: BorderRadius.circular(17)),
              child: GestureDetector(
                onTap: widget.vehicle.quantity < 1 ? null : widget.onSelect,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(17),
                    color: Colors.white,
                  ),
                  child: Center(
                      child: Text(
                    widget.vehicle.quantity < 1 ? 'Booked' : 'Select',
                    style: TextStyle(
                        color: widget.vehicle.quantity < 1
                            ? Colors.red
                            : ZAKGreenSwatch,
                        fontWeight: FontWeight.w600),
                  )),
                ),
              ),
              //     Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: <Widget>[
              //     Padding(
              //       padding: const EdgeInsets.only(left: 8.0),
              //       child: InkWell(
              //         onTap: _onDecrement,
              //         child: Icon(
              //           Icons.remove,
              //           color: ZAKGreen,
              //         ),
              //       ),
              //     ),
              //     Padding(
              //       padding: const EdgeInsets.symmetric(horizontal: 8),
              //       child: Container(
              //         // width: 20,
              //         child: Center(
              //           child: Text(
              //             quantity.toString(),
              //             style: subtitleTextStyle(FontWeight.w500),
              //           ),
              //         ),
              //       ),
              //     ),
              //     Padding(
              //       padding: const EdgeInsets.only(right: 8.0),
              //       child: InkWell(
              //         onTap: _onIncrement,
              //         child: Icon(
              //           Icons.add,
              //           color: ZAKGreen,
              //         ),
              //       ),
              //     ),
              //   ],
              // ),
            ),
          ),
          // Text('Booked', style: TextStyle(color: Colors.red))
        ],
      ),
    );
  }
}
