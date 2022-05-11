// ----- STRINGS ------
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';

import 'models/product.dart';

const baseURL = 'http://192.168.43.249:8000/api';
const imageURL='http://192.168.43.249:8000';
//--------Auth URL------------
const loginURL = baseURL + '/login';
const registerURL = baseURL + '/register';
const logoutURL = baseURL + '/logout';
const userURL = baseURL + '/user';
//--------Product URL----------
const AllproductURL = baseURL + '/view';
const MyProductURL=baseURL+'/show_my_products';
const OneproductURL=baseURL + '/show_single_product';
const CreateProductURL=baseURL + '/create';
const UpdateProductURL=baseURL+'/update';
const DeleteProductURL=baseURL+'/delete';
//--------Comment URL----------
const commentsURL = baseURL + '/show_comments';
const CreateComment=baseURL+'comment/store';

// ----- Errors -----
const serverError = 'Server error';
const unauthorized = 'Unauthorized';
const somethingWentWrong = 'Something went wrong, try again!';


Flushbar flashbar(text)=>Flushbar(

messageText: Text(text,style: TextStyle(fontFamily:'RobotoCondensed' ,fontSize:20 ,color: Colors.white),),
margin: EdgeInsets.symmetric(horizontal: 8),

backgroundColor: Colors.red.withOpacity(0.8),
borderRadius: 20,
dismissDirection:FlushbarDismissDirection.HORIZONTAL ,
duration: Duration(milliseconds: 1700),
flushbarPosition: FlushbarPosition.TOP,
);
TextStyle textstyel({size, color, weight}){
  return TextStyle(

      fontFamily: 'RobotoCondensed',
      fontSize: size,
      fontWeight: weight,
      color: color);
}
Widget CustomButton(icon, function) {
  return InkWell(
    onTap: function,
    child: Container(
      height: 50,
      width: 50,
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
Widget MyProductItem(Product product){

  return Container(
    margin: EdgeInsets.only(right: 20),
    width: 220,
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Color(0xFFF082938)
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Expanded(
          child: Container(
            width: 220,
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                image: DecorationImage(
                    image: NetworkImage('$imageURL/${product.photo}'),
                    fit: BoxFit.cover
                )
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[

                SizedBox(height: 150),
                Text(product.name,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 25,

                        fontFamily: 'RobotoCondensed'
                    )),
                SizedBox(height: 25),
              ],
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.all(10),
          height: 49,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text("quantity : ${product.quantity.toString()}  price :${product.price.toString()}", style: TextStyle(
                  color: Colors.white,
                  fontSize: 12
              )),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  MyProductItemIcon(Icons.favorite, product.likesCount.toString()),
                  SizedBox(width: 7),
                  MyProductItemIcon(Icons.visibility, product.number_of_views.toString()),

                ],
              )
            ],
          ),
        )
      ],
    ),
  );

}

Widget MyProductItemIcon(IconData iconData, String text){
  return Row(
    children: <Widget>[
      Icon(iconData, color: Colors.white),
      SizedBox(width: 2),
      Text(text, style: TextStyle(color: Colors.white))
    ],
  );
}

