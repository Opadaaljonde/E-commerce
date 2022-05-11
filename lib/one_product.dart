import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart';
import 'package:win_win/view_product.dart';
class OneProduct extends StatefulWidget {


  @override
  _OneProductState createState() => _OneProductState();
}

class _OneProductState extends State<OneProduct> {
  Size size;
Future<bool>_like(islike)async{
  return !islike;
}
  double verPos = 0.0;
  void onVerticalDrad(DragUpdateDetails details) {
    setState(() {
      verPos += details.primaryDelta;
      verPos = verPos.clamp(0, double.infinity).toDouble();
    });
  }

  void onVerticalDradEnds(DragEndDetails details) {
    setState(() {
      if (details.primaryVelocity > 500 || verPos > size.height / 2) {
        verPos = size.height - 40;
      }
      if (details.primaryVelocity < -500 || verPos < size.height / 2) {
        verPos = 0;
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(

      body: Stack(children: [
        Positioned(top:290,
          child: Container(
            padding: EdgeInsets.all(10),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  LikeButton(

                      onTap:_like

                  ),

                ],
              ),
            ),
          ),
        ),

        AnimatedPositioned(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
          top: MediaQuery.of(context).padding.top - verPos,
          left: (size.width * .01 - verPos)
              .clamp(0, double.infinity)
              .toDouble(),
          right: (size.width * .01 - verPos)
              .clamp(0, double.infinity)
              .toDouble(),
          bottom: size.height * .5 - verPos,
          child: AnimatedSwitcher(
            switchInCurve: Curves.easeOut,
            switchOutCurve: Curves.easeIn,
            duration: const Duration(milliseconds: 150),
            child: GestureDetector(
              onVerticalDragUpdate: onVerticalDrad,
              onVerticalDragEnd: onVerticalDradEnds,
              child: ViewProduct(
                verticalPos: verPos,
              ),
            ),
          ),
        ),

      ],
      ),
    );
  }
}
