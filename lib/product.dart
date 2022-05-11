import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart';
import'package:url_launcher/url_launcher.dart' as UrlLauncher;
import 'package:win_win/components/customButtonAnimation.dart';
import 'package:win_win/constants.dart';
import 'package:win_win/models/product.dart';
import 'package:win_win/product_comment.dart';
import 'package:win_win/product_form.dart';
import 'package:win_win/screens/auth/auth.dart';
import 'package:win_win/services/product_service.dart';
import 'package:win_win/services/user_service.dart';

import 'constant.dart';
import 'models/api_response.dart';
import 'package:http/http.dart' as http;

class ProductInfo extends StatefulWidget {
  final int productId;
 final int statuscode;
ProductInfo(this.productId,{this.statuscode});

  @override
  _ProductInfoState createState() => _ProductInfoState();

}

class _ProductInfoState extends State<ProductInfo> {
  bool _loading = true;
  Product _product;
  int userId=0;

  Future<void> retrieveProduct() async {
    userId = await getUserId();
    ApiResponse response = await getProduct(widget.productId);
    if(response.error == null){
      setState(() {
        _product = response.data as Product;
        _loading = _loading ? !_loading : _loading;
      });
    }
    else if (response.error == unauthorized){
      logout().then((value) => {
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>AuthScreen()), (route) => false)
      });
    }
    else {
      flashbar('${response.error}').show(context);
    }
  }
  void _handleDeletePost(int productId) async {
    ApiResponse response = await deletePost(productId);
    if (response.error == null){
      print('delete successfly');
    }
    else if(response.error == unauthorized){
      logout().then((value) => {
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>AuthScreen()), (route) => false)
      });
    }
    else {
      flashbar('${response.error}').show(context);

    }
  }
  Future<bool> _like(islike) async {

    String token = await getToken();
    final response = await http.post(Uri.parse('$baseURL/product/${_product.id}/isLiked'),
        headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
        },
        body: {
        'isLiked':_product.selfLiked==0?'1':"0"
        });
    print(response.body);
    return !islike;
  }

  Size size;
@override
  void initState() {
  setState(() {
    retrieveProduct();
  });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    size = MediaQuery.of(context).size;

    return Scaffold(
        body: _loading?Center(child: CircularProgressIndicator() ,):SingleChildScrollView(
            child: Container( height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
           child: Stack(children: [
        Container(
          height: MediaQuery.of(context).size.height*0.43 ,
         width: size.width,
          child: InteractiveViewer(child: Image.network('$imageURL/${_product.photo}',fit: BoxFit.cover ,)),
        ),
           SafeArea(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                SizedBox(height: 20),
                Expanded(
                  child: Container(
                   // padding: EdgeInsets.symmetric(horizontal: 40),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        IconButton(
                          icon: Icon(Icons.arrow_back_ios,
                              color: Colors.white, ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(20),
                  height: MediaQuery.of(context).size.height * 0.63 ,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(25),
                          topRight: Radius.circular(25))),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                          LikeButton(likeCount:_product.comment_count,
                            onTap: (f){  Navigator.of(context).push(MaterialPageRoute(builder: (ctx)=>Comments(_product.id)));},
                          likeBuilder: (b){return Icon(Icons.comment_rounded,size: 30,color: Colors.grey,);},
                          ),
                          LikeButton(isLiked: _product.selfLiked==0?false:true,onTap: _like,likeCount: _product.likesCount,),
                           TextButton.icon(onPressed: (){}, icon:Icon(Icons.visibility,color: Colors.grey,), label: Text(_product.number_of_views.toString(),style: TextStyle(color: Colors.grey),))
                        ],
                        ),
                      SizedBox(height: 15,)
                        ,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [Text(_product.name,
                            style: TextStyle(

                              fontSize: 25,
                              fontFamily: 'RobotoCondensed',
                            )),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                        decoration: BoxDecoration(
                         color: Colors.blueAccent,
                          borderRadius: BorderRadius.circular(15),

                          boxShadow: [BoxShadow(color: Colors.black26,offset: Offset(2,4),blurRadius: 10)]
                        ),
                        child: Text('${_product.price} \$',style: TextStyle(color: Colors.white,decoration:_product.price_with_offer!=_product.price?TextDecoration.lineThrough:TextDecoration.none)),
                      ),
                        _product.price_with_offer!=_product.price?Container(padding: EdgeInsets.all(4),child: Text(_product.price_with_offer.toString()),):Container()
                      ]),
                        SizedBox(height: 10,),
                        Divider(),
                        ListTile(title: Text("Available Quantity ",style: TextStyle(
                         color: Colors.grey,
                          fontSize: 20,
                          fontFamily: 'RobotoCondensed',
                        )),trailing: Text(_product.quantity.toString()),),

                        ListTile(title: Text("Expiration date",style: TextStyle(
                          color: Colors.grey,
                          fontSize: 20,
                          fontFamily: 'RobotoCondensed',
                        )),trailing: Text(_product.expirationDate),),

                        ListTile(title: Text("Category",style: TextStyle(
                          color: Colors.grey,
                          fontSize: 20,
                          fontFamily: 'RobotoCondensed',
                        )),trailing: Text(_product.category),),
                        ListTile(onTap: ()async{
                          await UrlLauncher.launch('tel:${_product.contactInfo}');
                        }

                        ,title: Text("Contact Info  ${_product.contactInfo}",style: TextStyle(
                          color: Colors.grey,
                          fontSize: 20,
                          fontFamily: 'RobotoCondensed',
                        )),),
                      ],
                    ),
                  ),
                ),
                  ]
              )
          ),
             Positioned(right: 20,top: 20,child: /* _product.user_id==userId?*/widget.statuscode==1?CustomButtonAnimation(icon: Icons.edit,borderColor: Colors.white,backbround: Colors.white,child: ProductForm(product:_product),):Container())
     ] ),
    )
        )
          ,  floatingActionButton:/*_product.user_id==userId?*/widget.statuscode==1?FloatingActionButton(
      backgroundColor: Colors.red,
      child: Icon(Icons.delete),
      onPressed: (){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          duration: Duration(seconds: 4),
          content: Text('Are you sure to delete ?'),
          padding: EdgeInsets.all(10),
          action: SnackBarAction(label: 'Ok', onPressed: (){
            _handleDeletePost(_product.id);
            Navigator.of(context).pop();
          }),
        ));
      },
    ):Container()
    );
  }
}
