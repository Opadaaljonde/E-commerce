import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';
import 'package:win_win/screens/auth/auth.dart';
import 'package:win_win/services/product_service.dart';
import 'package:win_win/services/user_service.dart';

import 'constant.dart';
import 'models/api_response.dart';
import 'models/product.dart';
import 'package:http/http.dart ' as http;

class ProductForm extends StatefulWidget {
  final Product product ;

  ProductForm({this.product});

  @override
  _ProductFormState createState() => _ProductFormState();
}

class _ProductFormState extends State<ProductForm> {
  //---text field controller
  GlobalKey<FormState> _key = GlobalKey();
  TextEditingController _name = TextEditingController();
  TextEditingController _contactInfo = TextEditingController();
  TextEditingController _quantity = TextEditingController();
  TextEditingController _price = TextEditingController();
  TextEditingController _dis1 = TextEditingController();
  TextEditingController _dis2 = TextEditingController();
  TextEditingController _dis3 = TextEditingController();
  TextEditingController _days1 = TextEditingController();
  TextEditingController _days2 = TextEditingController();
  TextEditingController _days3 = TextEditingController();
  String _selectdate;
  String _selctcategory;
  String newcategory;
  File _image;
  Color borderphoto = Colors.grey;
  Color expirationcolor = Colors.blueAccent;

  final pick = ImagePicker();

//---pick image--
  Future getimage(Src) async {
    var imgpick = await pick.getImage(source: Src);
    if (imgpick != null) {
      setState(() {
        _image = File(imgpick.path);
      });
    } else {
      print('no image select');
    }
  }

  //--pick date---
  pickdate() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime.now(),
            lastDate: DateTime(2025))
        .then((value) {
      if (value == null) return;
      setState(() {
        _selectdate = "${value.year}-${value.month}-${value.day}";
      });
    });
  }

  bool _loading = false;

  void _createProduct() async {
    ApiResponse response = await createProduct(
        name: _name.text,
        price: _price.text,
        quantity: _quantity.text,
        phone_number: _contactInfo.text,
        classification: _selctcategory,
        expirationDate: _selectdate,
        photo: getStringImage(_image),
        discout1:_dis1.text,
        discout2:_dis2.text,
        discout3:_dis3.text,
        days1:_days1.text,
        days2:_days2.text,
        days3:_days3.text
    );

    if (response.error == null) {
      Navigator.of(context).pop();
    } else if (response.error == unauthorized) {
      logout().then((value) => {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                    builder: (context) => AuthScreen()),
                (route) => false)
          });
    } else {
      flashbar('${response.error}').show(context);
      setState(() {
        _loading = !_loading;
      });
    }
  }

  // edit product
  void _editProduct(int productId) async {
    ApiResponse response = await updateProduct(productId,
        name: _name.text,
        price: _price.text,
        quantity: _quantity.text,
        phone_number: _contactInfo.text,
        classification: _selctcategory,

        photo:_image!=null?getStringImage(_image):''
    );
    if (response.error == null) {

      Navigator.of(context).pop();
    } else if (response.error == unauthorized) {
      logout().then((value) => {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                    builder: (context) =>AuthScreen()),
                (route) => false)
          });
    } else {
      flashbar('${response.error}').show(context);
      setState(() {
        _loading = !_loading;
      });
    }
  }

  @override
  void initState() {

    if (widget.product != null) {
      _name.text = widget.product.name ?? "";
      _price.text = widget.product.price.toString() ?? "";
      _contactInfo.text = widget.product.contactInfo.toString()?? "";
      _quantity.text = widget.product.quantity.toString()?? "";
      _selctcategory = widget.product.category ?? 'Food';

    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
centerTitle: true,
        leading: IconButton(icon: Icon(Icons.arrow_back_ios_outlined,color: Colors.black,),onPressed: (){
          Navigator.of(context).pop();
        },),
        backgroundColor: ThemeData.light().canvasColor,
        title: Text(widget.product == null ? 'Create Product' : "Edit Product",
            style: TextStyle(
                fontFamily: 'RobotoCondensed',
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Colors.black)),
      ),
      body: _loading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              padding: EdgeInsets.all(15),
              child: SingleChildScrollView(
                child: Form(
                  key: _key,
                  child: Column(
                    children: [
                      //---name---
                      TextFormField(
                        controller: _name,
                        validator: (name) {
                          if (name == "") {
                            return 'Name product is require';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                            labelText: 'Name',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            )),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      // ---quantity---
                      TextFormField(
                        controller: _quantity,
                        keyboardType: TextInputType.number,
                        validator: (quantity) {
                          if (quantity == "") {
                            return 'Quantity of product is require';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            labelText: 'Quantity',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            )),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      //---price---
                      TextFormField(
                        controller: _price,
                        keyboardType: TextInputType.number,
                        validator: (price) {
                          if (price == "") {
                            return 'price product is require';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            labelText: 'Price',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            )),
                      ),
                      SizedBox(height: 10,),
                    widget.product==null?  Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: 150,
                                child: TextFormField(
                                  controller: _dis1,
                                  keyboardType: TextInputType.number,
                                  validator: (dis1) {
                                    if (dis1 == "") {
                                      return 'First Discount  is require';
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                      labelText: 'First Discount',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      )),
                                ),
                              ),
                              Container(
                                width: 150,
                                child: TextFormField(
                                  controller: _days1,
                                  keyboardType: TextInputType.number,
                                  validator: (day1) {
                                    if (day1== "") {
                                      return 'Day1 is require';
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                      labelText: 'Days 1',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      )),
                                ),
                              ),
                            ],),
                          SizedBox(height: 10,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: 150,
                                child: TextFormField(
                                  controller: _dis2,
                                  keyboardType: TextInputType.number,
                                  validator: (dis2) {
                                    if (dis2 == "") {
                                      return 'Second Discount is require';
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                      labelText: 'Second Discount',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      )),
                                ),
                              ),
                              Container(
                                width: 150,
                                child: TextFormField(
                                  controller: _days2,
                                  keyboardType: TextInputType.number,
                                  validator: (days2) {
                                    if (days2 == "") {
                                      return 'Days 2 is require';
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                      labelText: 'Days 2',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      )),
                                ),
                              ),
                            ],),
                          SizedBox(height: 10,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: 150,
                                child: TextFormField(
                                  controller: _dis3,
                                  keyboardType: TextInputType.number,
                                  validator: (dis3) {
                                    if (dis3 == "") {
                                      return 'Third Discount is require';
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                      labelText: 'Third Discount',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      )),
                                ),
                              ),
                              Container(
                                width: 150,
                                child: TextFormField(
                                  controller: _days3,
                                  keyboardType: TextInputType.number,
                                  validator: (days3) {
                                    if (days3 == "") {
                                      return 'Days 3 is require';
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                      labelText: 'Days 3',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      )),
                                ),
                              ),
                            ],),
                        ],
                      ):Container()
                      ,

                      SizedBox(
                        height: 10,
                      ),
                      //----contact info---
                      TextFormField(
                        controller: _contactInfo,
                        keyboardType: TextInputType.number,
                        validator: (contact) {
                          if (contact == "") {
                            return 'Contact Info is require';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            labelText: 'Contact info',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            )),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      //---select date
                      widget.product == null
                          ? Align(
                              alignment: Alignment.centerLeft,
                              child: TextButton.icon(
                                  onPressed: pickdate,
                                  icon: Icon(
                                    Icons.date_range,
                                    color: expirationcolor,
                                  ),
                                  label: Text(
                                    _selectdate == null
                                        ? 'Expiration date'
                                        : _selectdate,
                                    style: TextStyle(color: expirationcolor),
                                  )))
                          : Container(
                              height: 1.0,
                            ),
                      //-----category
                      ExpansionTile(
                        title: Text(_selctcategory == null
                            ? 'Category'
                            : _selctcategory),
                        children: [
                          categoryitem('Food'),
                          Divider(),
                          categoryitem('Drinks'),
                          Divider(),
                          categoryitem('Detergents'),
                          Divider(),
                          categoryitem('Cosmetics'),
                          Divider(),
                          categoryitem('sanitary fitting'),
                          Divider(),
                          categoryitem('Medicines'),
                          Divider(),
                        ],
                      ),
                      //----select photo---
                      Container(
                          width: 320,
                          height: 200,
                          child: InkWell(
                              onTap: () {
                                AlertDialog r = AlertDialog(
                                  title: Text('Select Photo'),
                                  contentPadding: EdgeInsets.all(20),
                                  titlePadding: EdgeInsets.all(20),
                                  shape: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20)),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Divider(
                                        thickness: 2,
                                        color: Colors.blue,
                                      ),
                                      ListTile(
                                        leading: Icon(Icons.image),
                                        title: Text('Gallery'),
                                        onTap: () {
                                          getimage(ImageSource.gallery);
                                          Navigator.of(context).pop();
                                        },
                                        subtitle:
                                            Text('select image from gallery'),
                                      ),
                                      Divider(),
                                      ListTile(
                                        title: Text('Camera'),
                                        leading: Icon(Icons.camera_alt),
                                        subtitle: Text('take photo by camera'),
                                        onTap: () {
                                          getimage(ImageSource.camera);
                                          Navigator.of(context).pop();
                                        },
                                      )
                                    ],
                                  ),
                                );
                                showDialog(
                                    context: context,
                                    builder: (ctx) {
                                      return r;
                                    });
                              },
                              child: _image == null
                                  ? Container(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.photo,
                                            color: Colors.grey,
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text("Select Photo"),
                                        ],
                                      ),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          border:
                                              Border.all(color: borderphoto)),
                                    )
                                  : ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.file(
                                        _image,
                                        fit: BoxFit.fill,
                                      ),
                                    ))),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                          width: 200,
                          padding:
                              EdgeInsets.symmetric(horizontal: 30, vertical: 8),
                          child: FlatButton(
                            color: Colors.blueAccent,
                            onPressed: () async{
                              if (_key.currentState.validate()) {
                                if(widget.product==null && _image == null){

                                    flashbar('Photo  is require').show(context);
                                    setState(() {
                                      borderphoto = Colors.red;
                                    });

                                }



                              else if (widget.product==null && _selectdate == null ) {
                                  flashbar('expiration date  is require')
                                      .show(context);
                                  setState(() {
                                    expirationcolor = Colors.red;
                                  });


                                }
                              else if(_selctcategory==null){
                               flashbar('Category is required').show(context);
                                }
                              else {
                                  setState(() {
                                    _loading = !_loading;
                                    expirationcolor = Colors.blueAccent;
                                  });
                                  if (widget.product == null) {
                                    _createProduct();
                                                 } else {

                                    _editProduct(widget.product.id);
                                  }
                                }
                              }
                            },
                            child: Text(
                              widget.product == null ? 'Create' : "Save",
                              style: TextStyle(
                                  fontFamily: 'RobotoCondensed',
                                  fontSize: 20,
                                  color: Colors.white),
                            ),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                          ))
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  categoryitem(text) {
    return ListTile(
      title: Text(text),
      onTap: () {
        setState(() {
          _selctcategory = text;
        });
      },
    );
  }
}
