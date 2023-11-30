import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:project_event/Core/Color/color.dart';
import 'package:project_event/Database/functions/fn_budgetmodel.dart';
import 'package:project_event/Database/functions/fn_evenmodel.dart';
import 'package:project_event/Database/functions/fn_guestmodel.dart';
import 'package:project_event/Database/functions/fn_incomemodel.dart';
import 'package:project_event/Database/functions/fn_lock.dart';
import 'package:project_event/Database/functions/fn_paymodel.dart';
import 'package:project_event/Database/functions/fn_profilemodel.dart';
import 'package:project_event/Database/functions/fn_taskmodel.dart';
import 'package:project_event/Database/functions/fn_vendormodel.dart';
import 'package:project_event/screen/intro/intro.dart';
import 'package:sizer/sizer.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeEventDb();
  await initializeTaskDb();
  await initialize_guest_database();
  await initializeBudgetDatabase();
  await initializeVendorDatabase();
  await initializePaymentDatabase();
  await initializeIncomeDatabase();
  await initializeProfileDB();
  await initializelock();
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Set preferred orientations
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return SafeArea(
      child: Sizer(
        builder: (context, orientation, deviceType) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'event',
          theme: ThemeData(
            appBarTheme: const AppBarTheme(),
            primaryColor: Colors.grey[300],
            scaffoldBackgroundColor:
                Colors.white, //const Color.fromRGBO(255, 200, 200, 1),
            textTheme: const TextTheme(
              bodyMedium: TextStyle(
                fontFamily: 'ReadexPro',
              ),
            ),
          ),
          home: AnimatedSplashScreen(
            splash: 'assets/UI/Event Logo/event logo top.png',
            splashIconSize: 50.h,
            nextScreen: const OnBoardingPage(),
            backgroundColor: appbarcolor,
            duration: 3000,
            splashTransition: SplashTransition.sizeTransition,
          ),
        ),
      ),
    );
  }
}
