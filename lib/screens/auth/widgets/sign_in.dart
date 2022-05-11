import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:win_win/constant.dart';
import 'package:win_win/main.dart';
import 'package:win_win/models/api_response.dart';
import 'package:win_win/models/user.dart';

import 'package:win_win/screens/auth/widgets/decoration_functions.dart';
import 'package:win_win/screens/auth/widgets/sign_in_up_bar.dart';
import 'package:win_win/services/user_service.dart';

import '../../../config/palette.dart';
import 'title.dart';

class SignIn extends StatefulWidget {
  SignIn({
    Key key,
    @required this.onRegisterClicked,
  }) : super(key: key);

  final VoidCallback onRegisterClicked;

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  TextEditingController _email = TextEditingController();

  TextEditingController _password = TextEditingController();

  GlobalKey<FormState> _key = GlobalKey();

  bool Unvisible = true;
  bool loading = false;

  void _loginUser() async {

    ApiResponse response = await login(_email.text, _password.text);
    if (response.error == null){
      _saveAndRedirectToHome(response.data as User);
    }
    else {
      setState(() {
        loading = false;
      });
      flashbar('${response.error}').show(context);
    }
  }

  void _saveAndRedirectToHome(User user) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString('token', user.token ?? '');
    await pref.setInt('userId', user.id ?? 0);
    await pref.setString('email', user.email??"");
    await pref.setString('name', user.name??"");
    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder:(ctx)=>HomePage()), (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        children: [
          const Expanded(
            flex: 3,
            child: Align(
              alignment: Alignment.centerLeft,
              child: LoginTitle(
                title: 'Welcome\nBack',
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Form(
              key: _key,
              child: ListView(
                children: [
                  Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: TextFormField(
                        controller: _email,
                        validator: (str) {
                          if (str == "") {
                            return 'Email is require';
                          }
                          if (!str.contains('@')) {
                            return 'Invalid Email';
                          }
                          return null;
                        },
                        decoration: signInInputDecoration(hintText: 'Email'),
                      )),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: TextFormField(
                        controller: _password,
                        validator: (str) {
                          if (str == "" || str.length < 8) {
                            return 'Password is short';
                          }
                          return null;
                        },
                        obscureText: Unvisible,
                        decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 18.0, horizontal: 10),
                            hintStyle: const TextStyle(fontSize: 18),
                            hintText: 'password',
                            suffixIcon: IconButton(
                              icon: Icon(Unvisible
                                  ? Icons.visibility
                                  : Icons.visibility_off),
                              onPressed: () {
                                setState(() {
                                  Unvisible = !Unvisible;
                                });
                              },
                            ),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide(color: Colors.grey)))),
                  ),
                  SignInBar(
                    label: 'Sign Up',
                    isLoading: loading,
                    onPressed: () {
                      if (_key.currentState.validate()) {
                        setState(() {
                          loading = true;
                          _loginUser();
                        });
                      }
                      },
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: InkWell(
                      splashColor: Colors.white,
                      onTap: () {
                        widget.onRegisterClicked?.call();
                      },
                      child: const Text(
                        'Create Account',
                        style: TextStyle(
                          fontSize: 16,
                          decoration: TextDecoration.underline,
                          color: Palette.lightBlue,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
