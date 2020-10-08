// Don't touch anything.

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:tong_myung_hotel/screen/reviews_screens/review_main.dart';
import 'package:tong_myung_hotel/screen/sign_screens/login_screen.dart';
import 'package:tong_myung_hotel/screen/sign_screens/sign_main.dart';
import 'package:tong_myung_hotel/screen/sign_screens/signup_screen.dart';
import 'package:tong_myung_hotel/state/currentUser.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:tong_myung_hotel/state/current_State.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return ChangeNotifierProvider(
      create: (context) => CurrentUser(),
      child: MaterialApp(
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: [
          const Locale('ko', 'KR'),
        ],

        //////////////////////  달력을 한글로 표현하기위해 필요한 코드이다.  //////////////////////

        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: GettingStartedScreen(),
        routes: {
          LoginScreen.routeName: (ctx) => LoginScreen(),
          SignupScreen.routeName: (ctx) => SignupScreen(),
          '/home' : (BuildContext context) => new GettingStartedScreen(),
          '/review' : (BuildContext context)=> new Review(),
        },
      ),
    );
  }
}
