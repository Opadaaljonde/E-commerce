import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:win_win/constant.dart';
import 'package:win_win/models/product.dart';
import 'package:win_win/product.dart';
import 'package:win_win/screens/auth/auth.dart';
import 'package:win_win/services/product_service.dart';
import 'package:win_win/services/user_service.dart';

import 'models/api_response.dart';

class MyProduct extends StatefulWidget {
  @override
  _MyProductState createState() => _MyProductState();
}

class _MyProductState extends State<MyProduct> {
  List<dynamic> _productList = [];

  bool _loading = true;

  Future<void> retrieveProducts() async {
    ApiResponse response = await getMyProduct();

    if (response.error == null) {
      setState(() {
        _productList = response.data as List<dynamic>;
        _loading = _loading ? !_loading : _loading;
      });
    } else if (response.error == unauthorized) {
      logout().then((value) => {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) =>AuthScreen(),
            ),
                (route) => false)
      });
    } else {
      flashbar('${response.error}').show(context);
    }
  }
  @override
  void initState() {
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
   retrieveProducts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: retrieveProducts,
      child: Scaffold(
        body: Container(
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
              children: [
          Container(
          margin: EdgeInsets.only(top:25,left: 25),
          child: CustomButton(Icons.search, () {

          }),

        ),
        SizedBox(height: 20,),
        Container(
        margin: EdgeInsets.only(left: 25,top: 20),
        child:Text('My Product',style: TextStyle(color: Colors.black,fontFamily: 'Aquire',fontSize: 30,fontWeight: FontWeight.bold),)

        ,),
          SizedBox(height: 30,),
           Container(
           height: 350,
           padding: EdgeInsets.only(left: 20),
           child: ListView.builder(
           scrollDirection: Axis.horizontal,
           physics: BouncingScrollPhysics(),
           itemCount: _productList.length,
           itemBuilder: (context, index){
       Product product = _productList[index];
        return InkWell(
            onTap: (){
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (ctx) {
                    return ProductInfo(product.id,statuscode: 1,);
                  }));
            },
            child: MyProductItem(product));
        },
        ),
        )

        ],
        ),
        ),
      ),
    );
  }
}
