import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:win_win/screens/auth/auth.dart';
import 'package:win_win/services/comment_service.dart';
import 'package:win_win/services/user_service.dart';

import 'constant.dart';
import 'models/api_response.dart';
import 'models/comment.dart';

class Comments extends StatefulWidget {
  final productId;

  const Comments( this.productId);

  @override
  _CommentsState createState() => _CommentsState();
}

class _CommentsState extends State<Comments> {
TextEditingController _comentController =TextEditingController();
GlobalKey<FormState> _key=GlobalKey();
  bool _loading=true;
 List<dynamic> _commentList=[];
  Future<void> retrieveComments() async {
    ApiResponse response = await getComments(widget.productId);
    if (response.error == null) {
      setState(() {
        _commentList = response.data as List<dynamic>;
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
void _createComment() async {
  ApiResponse response = await createComment(widget.productId,_comentController.text);

  if (response.error == null) {
   retrieveComments();
  } else if (response.error == unauthorized) {
    logout().then((value) => {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (context) => AuthScreen()),
              (route) => false)
    });
  } else {
    flashbar('${response.error}').show(context);

  }
}



  Size size;

  @override
  void initState() {
 retrieveComments();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return RefreshIndicator(
      onRefresh: retrieveComments,
      child: Scaffold(
        body:_loading?Center(child: CircularProgressIndicator(),): Container(
          padding: EdgeInsets.only(top: 10),
          height: size.height,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/bg_1.jpeg'), fit: BoxFit.fill)),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(icon: Icon(Icons.arrow_back_ios_rounded,color: Colors.white,), onPressed: (){
              Navigator.of(context).pop();
                }),
                Container(
                  height: size.height * 0.81,
                  child: ListView.builder(

                    itemBuilder: (ctx, i) {
                      Comment comment=_commentList[i];
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                            child: Container(
                              //height: 40,
                              margin: EdgeInsets.only(right: 80),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start
                                ,children: [
                                  Text(
                                    comment.user_name,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'RobotoCondensed',
                                        fontWeight: FontWeight.w300,
                                        fontSize:18 ),
                                  ),
                                  Text(
                                    comment.comment,
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontFamily: 'RobotoCondensed',
                                        fontWeight: FontWeight.w200,

                                        fontSize: 16),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                    itemCount: _commentList.length,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Form(
                      key: _key,
                      child: Container(
                        width: 280,
                        padding: EdgeInsets.all(10),
                        height: size.height * 0.09,
                        child: TextFormField(
                          controller: _comentController,
                          validator: (str){
                            if(str==""){
                              return '';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            hintText: 'Add Comment',
                            hintStyle:
                                TextStyle(color: Colors.grey.withOpacity(0.4)),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.grey.withOpacity(0.2)),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            contentPadding: EdgeInsets.symmetric(horizontal: 8,vertical: 5),
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
                    ),
                    IconButton(
                      icon: Icon(Icons.send, size: 30,color: Colors.white54,),
                      onPressed: () {
                       if(_key.currentState.validate()){
                         setState(() {
                           _createComment();
                           _comentController.clear();
                         });
                       }
                      },
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
