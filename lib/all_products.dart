import 'dart:convert';

import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:win_win/product.dart';
import 'package:win_win/screens/auth/auth.dart';
import 'package:win_win/search_product.dart';
import 'package:win_win/services/product_service.dart';
import 'package:win_win/services/user_service.dart';
import 'constant.dart';
import 'dart:io';
import 'models/api_response.dart';
import 'models/product.dart';
import 'package:http/http.dart' as http;

class AllProducts extends StatefulWidget {
  @override
  _AllProductsState createState() => _AllProductsState();
}

class _AllProductsState extends State<AllProducts> {
  List<dynamic> _productList = [];


  bool _loading = true;
  String typeSort='name';

  Future<void> retrieveProducts() async {
    ApiResponse response = await getAllProduct(typeSort);
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
  List<String> filter = [
    'Foods',
    'Drinks',
    'Detergents',
    'Cosmetics',
    'sanitary fitting',
    'Medicines'
  ];
  int choise;

  @override
  void initState() {
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    retrieveProducts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: retrieveProducts,
        child: Container(
          height: double.infinity,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.white, Colors.white.withOpacity(0.9)])),
          padding: EdgeInsets.all(5),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomButton(
                              Icons.search, () {
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (ctx)=>SearchProduct()
                                ));
                          }),


                              Container(
                                height: 50,
                                width: 50,
                                margin: EdgeInsets.only(right: 10),
                                clipBehavior: Clip.antiAlias,
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.3),
                                      offset: Offset(2, 5),
                                      blurRadius: 10,
                                    )
                                  ],
                                  borderRadius: BorderRadius.circular(15),

                                ),

                                child: Image.asset(
                                  'assets/logo.jpeg',
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                ),
                              ),


                        ],
                      ),
                      SizedBox(height: 25),
                      Text(
                        'All',
                        style: TextStyle(fontSize: 30, fontFamily: 'Aquire'),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Products',
                        style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Aquire'),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                     Row(
                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                       children: [
                       Container(
                         child: DropdownButton(
                             elevation: 10,
                             style: TextStyle(
                                 fontSize: 10,
                                 fontFamily: 'RobotoCondensed',
                                 fontWeight: FontWeight.w200,
                                 color: Colors.black),
                             value: typeSort,
                             onChanged: (val) {
                               setState(() {
                                 typeSort = val;

                               });
                             },
                             items: [
                               DropdownMenuItem(
                                 child: Text(
                                   'Name',
                                 ),
                                 value: 'name',
                               ),
                               DropdownMenuItem(
                                 child: Text('Price'),
                                 value: 'price',
                               ),
                               DropdownMenuItem(
                                 child: Text('Ex Date'),
                                 value: 'expirations',
                               ),
                             ]),
                       ),
                       CustomButton(Icons.sort, (){setState(() {
                         retrieveProducts();
                       });})
                     ],),

                      SizedBox(
                        height: 10,
                      ),
                      Container(
                          height: 70,
                          width: double.infinity,
                          child: ListView.builder(
                            itemCount: filter.length,
                            itemBuilder: (ctx, i) {
                              return InkWell(
                                onTap: () {},
                                child: Container(
                                  margin: EdgeInsets.symmetric(
                                      horizontal: 7, vertical: 10),
                                  padding: EdgeInsets.symmetric(horizontal: 20),
                                  decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.3),
                                        offset: Offset(2, 5),
                                        blurRadius: 10,
                                      )
                                    ],
                                    borderRadius: BorderRadius.circular(15),
                                    border: Border.all(
                                        color: Colors.grey.withOpacity(0.2)),
                                    color: Colors.white,
                                  ),
                                  child: Center(
                                      child: Text(
                                    filter[i],
                                    style: TextStyle(
                                        fontFamily: 'RobotoCondensed',
                                        fontSize: 20,
                                        fontWeight: FontWeight.w200,
                                        color: Colors.grey),
                                  )),
                                ),
                              );
                            },
                            scrollDirection: Axis.horizontal,
                            padding: EdgeInsets.all(5),
                          )),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        height: 450,
                        child: _loading
                            ? Center(child: CircularProgressIndicator())
                            : GridView.builder(
                                itemCount: _productList.length,

                                gridDelegate:
                                    SliverGridDelegateWithMaxCrossAxisExtent(
                                        maxCrossAxisExtent: 200,
                                        childAspectRatio: 3 / 2,
                                        mainAxisSpacing: 3,
                                        crossAxisSpacing: 3),
                                itemBuilder: (ctx, i) {
                                  Product product = _productList[i] as Product;
                                 print( product.name);
                                  return Stack(children: [
                                    InkWell(
                                      onTap: () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(builder: (ctx) {
                                          return ProductInfo(product.id);
                                        }));
                                      },

                                        child: Container(
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 5, vertical: 10),
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 20),
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                                image: NetworkImage(
                                                    '$imageURL/${product.photo}'),
                                                fit: BoxFit.cover),
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            border: Border.all(
                                                color:
                                                    Colors.grey.withOpacity(0.2)),
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),

                                    Positioned(
                                      right: 5,
                                      bottom: 20,
                                      child: Container(
                                          width: 100,
                                          height: 30,
                                          padding: EdgeInsets.only(left: 5),
                                          color: Colors.black45,
                                          child: Text(

                                            product.name,
                                            style: TextStyle(
                                                fontFamily: 'RobotoCondensed',
                                                fontSize: 20,
                                                fontWeight: FontWeight.w200,
                                                color: Colors.white),
                                          )),
                                    ),
                                  ]);
                                }),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget CustomButton(icon, function) {
    return InkWell(
      onTap: function,
      child: Container(
        height: 50,
        width: 50,
        margin: EdgeInsets.only(left: 10),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              offset: Offset(2, 5),
              blurRadius: 10,
            )
          ],
          borderRadius: BorderRadius.circular(15),
          color: Colors.white,
        ),
        child: Icon(icon),
      ),
    );
  }
}
