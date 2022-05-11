import 'package:flutter/material.dart';
import 'package:win_win/constant.dart';
import 'package:win_win/product.dart';
import 'package:win_win/screens/auth/auth.dart';
import 'package:win_win/services/product_service.dart';
import 'package:win_win/services/user_service.dart';

import 'models/api_response.dart';
import 'models/product.dart';

class SearchProduct extends StatefulWidget {
  @override
  _SearchProductState createState() => _SearchProductState();
}

class _SearchProductState extends State<SearchProduct> {
  TextEditingController textSearch = TextEditingController();
  String typeSearch = "name";
  bool _loading = false;
  List<dynamic> _searchList = [];
  pickdate() {
    showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2025))
        .then((value) {
      if (value == null) return;
      setState(() {
        var strm;
        var strd;
        strm =value.month<10?'0${value.month}':value.month;
        strd =value.day<10?'0${value.day}':value.day;
        textSearch.text= "${value.year}-$strm-$strd";
      });
    });
  }

  searchProducts() async {
    ApiResponse response = await searchProduct(textSearch.text, typeSearch);

    if (response.error == null) {
      setState(() {
        _searchList = response.data as List<dynamic>;
        _loading = _loading ? !_loading : _loading;
        if (_searchList.isEmpty) {
          flashbar('Not Found').show(context);
        }
      });
    } else if (response.error == unauthorized) {
      logout().then((value) => {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => AuthScreen()),
                (route) => false)
          });
    } else {
      flashbar('${response.error}').show(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 70),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    width: 230,
                    height: 50,
                    child: TextFormField(
                      controller: textSearch,
                      decoration: InputDecoration(
                        hintText: 'Search Products',
                        hintStyle: TextStyle(color: Colors.grey.withOpacity(0.3)),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.grey.withOpacity(0.2)),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        contentPadding: EdgeInsets.all(4),
                        prefixIcon: IconButton(
                          icon: Icon(
                            Icons.search,
                            color: Colors.black26,
                          ),
                          onPressed: () {
                            setState(() {
                              searchProducts();
                              _loading = false;
                            });
                          },
                        ),
                        fillColor: Colors.grey.withOpacity(0.2),
                        filled: true,
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.grey.withOpacity(0.2)),
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    child: DropdownButton(
                        elevation: 10,
                        style: TextStyle(
                            fontSize: 10,
                            fontFamily: 'RobotoCondensed',
                            fontWeight: FontWeight.w200,
                            color: Colors.black),
                        value: typeSearch,
                        onChanged: (val) {
                          setState(() {
                            typeSearch = val;
                            if(val=='expirations'){
                              pickdate();
                            }
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
                            child: Text('Category'),
                            value: 'classification',
                          ),
                          DropdownMenuItem(
                            child: Text('Ex Date'),
                            value: 'expirations',
                          ),
                        ]),
                  )
                ],
              ),
              SizedBox(
                height: 30,
              ),
              _loading
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : Container(
                      child: _searchList.isEmpty
                          ? Center(
                              child: Text('Not Found'),
                            )
                          : Container(
                              height: 300,
                              padding: EdgeInsets.only(left: 20),
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                physics: BouncingScrollPhysics(),
                                itemCount: _searchList.length,
                                itemBuilder: (context, index) {
                                  Product product = _searchList[index];
                                  return InkWell(
                                      onTap: () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(builder: (ctx) {
                                          return ProductInfo(product.id);
                                        }));
                                      },
                                      child: MyProductItem(product));
                                },
                              ),
                            )),
            ],
          ),
        ),
      ),
    );
  }
}
