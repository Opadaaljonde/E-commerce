import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:win_win/main.dart';
import 'package:win_win/screens/auth/auth.dart';
import 'package:win_win/services/user_service.dart';
class SplashScreen1 extends StatefulWidget {
  @override
  _SplashScreen1State createState() => _SplashScreen1State();
}

class _SplashScreen1State extends State<SplashScreen1> {
  String token;

  gettoken()async{
  token=await getToken();
}

@override
  void initState() {
   gettoken();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SplashScreen(
        seconds: 3,

      imageBackground: AssetImage('assets/splash.jpg' ),
        navigateAfterSeconds:token!=""?HomePage():AuthScreen() ,

      ),
    );
  }
}
