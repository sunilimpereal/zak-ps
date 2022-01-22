import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zak_mobile_app/networking/remote_config.dart';
import 'package:zak_mobile_app/utility/colors.dart';
import 'package:zak_mobile_app/view/screens/book_tickets_screen.dart';
import 'package:zak_mobile_app/view/screens/donation_details_screen.dart';
import 'package:zak_mobile_app/view/screens/forgot_password_screen.dart';
import 'package:zak_mobile_app/view/screens/getting_started_screen.dart';
import 'package:zak_mobile_app/view/screens/home_screen.dart';
import 'package:zak_mobile_app/view/screens/my_activities_screen.dart';
import 'package:zak_mobile_app/view/screens/my_tickets_and_passes_screen.dart';
import 'package:zak_mobile_app/view/screens/set_password_screen.dart';
import 'package:zak_mobile_app/view/screens/verify_user_screen.dart';
import 'package:zak_mobile_app/view/screens/zoos_screen.dart';
import 'package:zak_mobile_app/view_models/authentication_view_model.dart';
import 'package:zak_mobile_app/view_models/vehicle_booking_view_model.dart';

String userId = "";
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  runApp(MyApp());
}

final navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthenticationViewModel>(
            create: (_) => AuthenticationViewModel()),
        ChangeNotifierProvider<VehicleBookingViewModel>(
            create: (_) => VehicleBookingViewModel()),
      ],
      child: MaterialApp(
        navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,
        title: 'ZAK',
        theme: ThemeData(
          fontFamily: 'Montserrat',
          primaryColor: ZAKGreen,
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: AppBarTheme(
              elevation: 0,
              color: Colors.white,
              iconTheme: IconThemeData(
                color: ZAKGreen,
              )),
          textTheme: TextTheme(
              button:
                  TextStyle(fontWeight: FontWeight.w600, color: Colors.white)),
          accentTextTheme: TextTheme(
              headline2: TextStyle(
                fontFamily: 'Original_Surfer',
                fontSize: 24,
                color: ZAKDarkGreen,
              ),
              headline3: TextStyle(
                fontFamily: 'Original_Surfer',
                fontSize: 20,
                color: ZAKDarkGreen,
              )),
          primarySwatch: ZAKGreenSwatch,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: MyHomePage(),
        routes: {
          VerifyUserScreen.routeName: (_) => VerifyUserScreen(),
          ForgotPasswordScreen.routeName: (_) => ForgotPasswordScreen(),
          SetPasswordScreen.routeName: (_) => SetPasswordScreen(),
          HomeScreen.routeName: (_) => HomeScreen(),
          GettingStartedScreen.routeName: (_) => GettingStartedScreen(),
          BookTicketsScreen.routeName: (_) => BookTicketsScreen(),
          ZoosScreen.routeName: (_) => ZoosScreen(),
          DonationDetailsScreen.routeName: (_) => DonationDetailsScreen(),
          MyActivitiesScreen.routeName: (_) => MyActivitiesScreen(),
          MyTicketsAndPassesScreen.routeName: (_) => MyTicketsAndPassesScreen(),
        },
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    fetchValuesFromRemoteConfig();
  }

  @override
  Widget build(BuildContext context) {
    final authenticationVM = Provider.of<AuthenticationViewModel>(context);
    return FutureBuilder(
        future: authenticationVM.isUserSignedIn(),
        builder: (_, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container();
          }
          userId = authenticationVM.userID;
          return authenticationVM.token == null
              ? GettingStartedScreen()
              : HomeScreen();
        });
  }
}
