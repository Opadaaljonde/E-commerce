import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final String label;
  final Widget icon;
  final bool isPassword;

  CustomTextField({Key key, this.label, this.icon, this.isPassword = false})
      : super(key: key);

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool visib = true;

  @override
  Widget build(BuildContext context) {
    return TextField(
      style: TextStyle(color: Color(0xFFF234253), fontWeight: FontWeight.bold),
      obscureText: visib,
      decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey, width: 1.0)),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey, width: 1.0)),
          labelText: widget.label,
          labelStyle:
              TextStyle(color: Color(0xFFF234253), fontWeight: FontWeight.bold),
          suffixIcon: widget.isPassword
              ? IconButton(
                  icon: Icon(visib ? Icons.visibility : Icons.visibility_off),
                  onPressed: () {
                    setState(() {
                      visib = !visib;
                    });
                  })
              : widget.icon),
    );
  }
}
