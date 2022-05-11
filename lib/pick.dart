import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';


class PickImg extends StatefulWidget {


  @override
  _PickImgState createState() => _PickImgState();
}

class _PickImgState extends State<PickImg> {
  File _image;
 final pick=ImagePicker();
  Future getimage()async {
    var imgpick = await pick.getImage(source: ImageSource.camera);
    if(imgpick!=null){
      setState(() {
        _image=File(imgpick.path);
      });

    }
    else{
      print('no image select');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              child: Text('pick'),
              onPressed: ()async{
              await getimage();
                },
            ),
            _image!=null?Image.file(_image):Container()
          ],
        ),
      ),
    );
  }
}
