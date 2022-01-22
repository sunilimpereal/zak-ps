import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zak_mobile_app/models/vehicleBooking.dart/available_vehicle_response.dart';
import 'package:zak_mobile_app/models/zoo.dart';
import 'package:zak_mobile_app/utility/colors.dart';
import 'package:zak_mobile_app/view/screens/tickets_passes/vehicle_booking.dart';
import 'package:zak_mobile_app/view/widgets/zak_title.dart';
import 'package:zak_mobile_app/view_models/authentication_view_model.dart';
import 'package:zak_mobile_app/view_models/vehicle_booking_view_model.dart';

class SelectVehicle extends StatelessWidget {
  static const routeName = 'selectVehicle';
  final Zoo zoo;
  SelectVehicle(this.zoo);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final authProvider = Provider.of<AuthenticationViewModel>(context);
    Provider.of<VehicleBookingViewModel>(context, listen: false).selectedZoo =
        zoo;

    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: ZAKTitle(
            title: 'Available Vehicles',
          )),
      body: FutureBuilder(
          future: VehicleBookingViewModel()
              .getAvailableVehicles(zoo.id, authProvider.token),
          builder: (context, AsyncSnapshot<List<Vehicle>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else {
              if (snapshot.data.length == 0) {
                return Center(child: Text('No vehicles available for booking'));
              } else {
                return Container(
                  child: GridView.count(
                    childAspectRatio: 3 / 2,
                    crossAxisCount: 2,
                    children: List.generate(snapshot.data.length,
                        (index) => VehicleListTile(snapshot.data[index])),
                  ),
                );
              }
            }
          }),
    );
  }
}

class VehicleListTile extends StatelessWidget {
  final Vehicle vehicle;
  VehicleListTile(this.vehicle);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () {
          Provider.of<VehicleBookingViewModel>(context, listen: false)
              .selectedVehicle = vehicle;
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => VehicleBookingScreen(vehicle)));
        },
        child: Container(
          decoration: BoxDecoration(
              color: ZAKLightGrey, borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    '${vehicle.name}',
                    style: TextStyle(
                        color: ZAKGrey,
                        fontSize: size.height * 0.03,
                        fontWeight: FontWeight.w600),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                  Text(
                    '${vehicle.seats} Seater',
                    style: TextStyle(
                        color: ZAKGreenSwatch,
                        fontSize: size.height * 0.02,
                        fontWeight: FontWeight.w400),
                  ),
                  Text(
                    'Rs ${vehicle.price} /-',
                    style: TextStyle(
                        color: ZAKGreenSwatch,
                        fontSize: size.height * 0.015,
                        fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
