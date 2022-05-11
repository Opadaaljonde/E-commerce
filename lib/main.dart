


import 'dart:io';
import 'package:win_win/bank_card_model.dart';
import 'package:win_win/constants.dart';
import 'package:win_win/my_products.dart';
import 'package:win_win/one_product.dart';

import 'package:win_win/pick.dart';
import 'package:win_win/product.dart';
import 'package:win_win/product_form.dart';
import 'package:win_win/screens/auth/auth.dart';
import 'package:win_win/search_product.dart';
import 'package:win_win/services/user_service.dart';
import 'package:win_win/splash_screen.dart';
import 'package:win_win/widgets/add_card.dart';
import 'package:win_win/widgets/bank_card.dart';
import 'package:win_win/widgets/button.dart';
import 'package:win_win/widgets/drawar.dart';
import 'package:win_win/widgets/profile_section.dart';
import 'package:flutter/material.dart';
import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:flutter/services.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';

import 'package:slide_popup_dialog/slide_popup_dialog.dart';
import 'all_products.dart';
import 'dart:async';
import 'package:win_win/product_comment.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'Bank App',
      debugShowCheckedModeBanner: false,

      home:SplashScreen1() ,
    );
  }
}

class HomePage extends StatefulWidget {


  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
 int _selcetitem=0;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      body:_selcetitem==1?MyProduct():AllProducts(),
      bottomNavigationBar: BottomNavyBar(
          showElevation: false,
          selectedIndex: _selcetitem,
          items: [
            BottomNavyBarItem(
                title: Text(
                  'Home',
                  style: TextStyle(fontFamily: 'Aquire'),
                ),
                icon: Icon(Icons.home),
                activeColor: Colors.red,
                inactiveColor: Colors.blue),
            BottomNavyBarItem(
                title: Text(
                  'MyProducts',
                  style: TextStyle(fontFamily: 'Aquire'),
                ),
                icon: Icon(Icons.account_circle_outlined),
                activeColor: Colors.amber,
                inactiveColor: Colors.blue),
            BottomNavyBarItem(
                title: Text(
                  'add',
                  style: TextStyle(fontFamily: 'Aquire'),
                ),
                icon: Icon(Icons.add)),
          ],
          onItemSelected: (i) async {
            setState(() {
              _selcetitem = i;
            });
            if(_selcetitem==2){
              Navigator.of(context).push( MaterialPageRoute(builder: (ctx){return ProductForm();}));
            }
          }),

        drawer: Drawer1(),
              );

  }
}
