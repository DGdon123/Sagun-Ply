import 'dart:convert';

import 'package:ecommerce/api.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'dealer.dart';

class FifthScreen extends StatefulWidget {
  const FifthScreen({Key? key}) : super(key: key);
  @override
  State<FifthScreen> createState() => _FifthScreenState();
}

class _FifthScreenState extends State<FifthScreen> {
  var size, height, width;
  bool _isButtonDisabled = true;
  bool _rememberMe = false;
  bool _isObscure = true;
  bool _clicked = false;
  final storage = FlutterSecureStorage();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  Color originalButtonColor = Color(0xFFD71B23);
  Color? _buttonColor;
  String _email = '';
  String _password = '';

  @override
  void initState() {
    super.initState();
    _buttonColor = originalButtonColor;
    _loadSavedLoginDetails();
  }

  void _onRememberMeChanged(bool? newValue) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _rememberMe = newValue ?? false;
      if (_rememberMe) {
        prefs.setString('email', emailController.text);
        prefs.setString('password', passwordController.text);
      } else {
        prefs.remove('email');
        prefs.remove('password');
      }
    });
  }

  Future<void> login() async {
    var data = {
      'email': emailController.text,
      'password': passwordController.text,
    };

    var res = await CallApi().postData(data, 'login');
    var body = json.decode(res.body);

    if (body['success']) {
      String token = body['data']['token'];
      storeToken(token);
      retrieveToken();
      setState(() {
        _clicked = true;
        _buttonColor = Color(0xFFD71B23);
      });
      await Future.delayed(Duration(seconds: 2));
      setState(() {
        _clicked = false;
        _buttonColor = originalButtonColor;
      });
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => FourthScreen()),
        (Route<dynamic> route) => false,
      );
    } else {
      final logInErrorBar = SnackBar(
        content: Text(
          "Invalid Email or Password",
          style: TextStyle(
            color: Color(0xFFFFFFFF),
            fontSize: 17,
            fontWeight: FontWeight.w700,
            fontFamily: 'Nunito',
          ),
          textAlign: TextAlign.center,
        ),
        duration: const Duration(milliseconds: 1400),
        backgroundColor: Color(0xFFD71B23),
      );
      ScaffoldMessenger.of(context).showSnackBar(logInErrorBar);
      setState(() {
        _clicked = true;
        _buttonColor = Color(0xFFD71B23);
      });
      await Future.delayed(Duration(seconds: 2));
      setState(() {
        _clicked = false;
        _buttonColor = originalButtonColor;
      });
    }
  }

  void _loadSavedLoginDetails() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? email = prefs.getString('email');
    final String? password = prefs.getString('password');

    if (email != null && password != null) {
      emailController.text = email;
      passwordController.text = password;
      setState(() {
        _rememberMe = true;
      });
    }
  }

  storeToken(String token) async {
    await storage.write(key: 'token', value: token);
  }

  retrieveToken() async {
    String? token = await storage.read(key: 'token');
    print(token);
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    return Scaffold(
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
        body: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
          return Column(children: [
            Expanded(
                child: SingleChildScrollView(
                    child: Container(
                        child: Column(
              children: [
                Align(
                  alignment: Alignment.bottomCenter,
                  heightFactor: height * 0.0035,
                  child: Image.asset(
                    "images/logo.png",
                    width: 140,
                    height: 97,
                    fit: BoxFit.fill,
                  ),
                ),
                Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 23),
                      child: Text(
                        "Proceed with your",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          height: height * 0.0025,
                          letterSpacing: 0.1,
                          fontFamily: "Roboto",
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF222222),
                          fontSize: width * 0.06,
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Container(
                      child: Text(
                        "Login",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          height: height * 0.0015,
                          letterSpacing: 0.1,
                          fontFamily: "NotoSans",
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF222222),
                          fontSize: width * 0.065,
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  margin: const EdgeInsets.only(top: 25),
                  child: Column(
                    children: [
                      Container(
                        width: width * 0.8,
                        child: TextFormField(
                          controller: emailController,
                          maxLines: 1,
                          cursorColor: Colors.black,
                          keyboardType: TextInputType.visiblePassword,
                          decoration: InputDecoration(
                            suffixIcon: Icon(
                              Icons.mail_rounded,
                              color: Color(0xFF222222),
                            ),
                            focusedBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(0xFFA6AEB0),
                                  width: 2,
                                  style: BorderStyle.solid),
                            ),
                            labelText: 'Email',
                            hintText: 'Enter Your Email',
                            hintStyle: TextStyle(
                              height: height * 0.0023,
                              fontFamily: "Mulish",
                              fontWeight: FontWeight.w600,
                              color: Color(0xFFA6AEB0),
                              fontSize: width * 0.043,
                            ),
                            labelStyle: TextStyle(
                              fontFamily: "Mulish",
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF222222),
                              fontSize: width * 0.047,
                            ),
                            suffixIconColor: Color.fromARGB(255, 255, 0, 0),
                          ),
                          style: TextStyle(
                            fontSize: width * 0.045,
                            fontFamily: "Mulish",
                            fontWeight: FontWeight.w600,
                            color: Color(0xFFA6AEB0),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Email field cannot be empty';
                            }
                            return '';
                          },
                        ),
                      ),
                      Container(
                        width: width * 0.8,
                        margin: const EdgeInsets.only(bottom: 28.5, top: 18),
                        child: TextFormField(
                          controller: passwordController,
                          obscureText: _isObscure,
                          maxLines: 1,
                          cursorColor: Colors.black,
                          keyboardType: TextInputType.visiblePassword,
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                                icon: Icon(
                                  _isObscure
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Color(0xFF271C24),
                                ),
                                onPressed: () {
                                  setState(() {
                                    _isObscure = !_isObscure;
                                  });
                                }),
                            focusedBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(0xFFA6AEB0),
                                  width: 2,
                                  style: BorderStyle.solid),
                            ),
                            labelText: 'Password',
                            hintText: 'Enter Your Password',
                            hintStyle: TextStyle(
                              height: height * 0.0023,
                              fontFamily: "Mulish",
                              fontWeight: FontWeight.w600,
                              color: Color(0xFFA6AEB0),
                              fontSize: width * 0.043,
                            ),
                            labelStyle: TextStyle(
                              fontFamily: "Mulish",
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF222222),
                              fontSize: width * 0.047,
                            ),
                            suffixIconColor: Color.fromARGB(255, 255, 0, 0),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Password field cannot be empty';
                            }
                            return '';
                          },
                          style: TextStyle(
                            fontSize: width * 0.045,
                            fontFamily: "Mulish",
                            fontWeight: FontWeight.w600,
                            color: Color(0xFFA6AEB0),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: width * 0.87,
                  height: height * 0.04,
                  alignment: Alignment.topLeft,
                  margin: const EdgeInsets.only(bottom: 25),
                  child: Row(
                    children: [
                      Checkbox(
                        checkColor: Color(0xFFFFFFFF),
                        activeColor: Color(0xFFD71B23),
                        value: _rememberMe,
                        onChanged: _onRememberMeChanged,
                      ),
                      Text(
                        'Remember me',
                        style: TextStyle(
                          fontFamily: "Mulish",
                          fontWeight: FontWeight.w600,
                          color: Color.fromARGB(255, 144, 143, 143),
                          fontSize: width * 0.042,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: height * 0.072,
                  width: width * 0.8,
                  margin: const EdgeInsets.only(top: 10),
                  child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: _clicked
                            ? MaterialStateProperty.all<Color>(
                                Color(0xFFD71B23),
                              )
                            : MaterialStateProperty.all<Color>(_buttonColor!),
                      ),
                      child: Text(
                        "Login",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          height: height * 0.001,
                          fontFamily: "ZenKakuGothicAntique",
                          fontWeight: FontWeight.w600,
                          color: Color(0xFFFFFFFF),
                          fontSize: width * 0.055,
                        ),
                      ),
                      onPressed: _clicked
                          ? null
                          : () async {
                              setState(() => _clicked = true);
                              if (emailController.text.isEmpty &&
                                  passwordController.text.isEmpty) {
                                final emptyFieldErrorBar = SnackBar(
                                  content: Text(
                                    "Email and Password fields cannot be empty",
                                    style: TextStyle(
                                      color: Color(0xFFFFFFFF),
                                      fontSize: 17,
                                      fontWeight: FontWeight.w700,
                                      fontFamily: 'Nunito',
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  duration: const Duration(milliseconds: 1400),
                                  backgroundColor: Color(0xFFD71B23),
                                );
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(emptyFieldErrorBar);
                                setState(() => _clicked = true);
                                await Future.delayed(Duration(seconds: 2));
                                setState(() => _clicked = false);
                              } else if (emailController.text.isEmpty) {
                                final emptyFieldErrorBar = SnackBar(
                                  content: Text(
                                    "Email field cannot be empty",
                                    style: TextStyle(
                                      color: Color(0xFFFFFFFF),
                                      fontSize: 17,
                                      fontWeight: FontWeight.w700,
                                      fontFamily: 'Nunito',
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  duration: const Duration(milliseconds: 1400),
                                  backgroundColor: Color(0xFFD71B23),
                                );
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(emptyFieldErrorBar);
                                setState(() => _clicked = true);
                                await Future.delayed(Duration(seconds: 2));
                                setState(() => _clicked = false);
                              } else if (passwordController.text.isEmpty) {
                                final emptyFieldErrorBar = SnackBar(
                                  content: Text(
                                    "Password field cannot be empty",
                                    style: TextStyle(
                                      color: Color(0xFFFFFFFF),
                                      fontSize: 17,
                                      fontWeight: FontWeight.w700,
                                      fontFamily: 'Nunito',
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  duration: const Duration(milliseconds: 1400),
                                  backgroundColor: Color(0xFFD71B23),
                                );
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(emptyFieldErrorBar);
                                setState(() => _clicked = true);
                                await Future.delayed(Duration(seconds: 2));
                                setState(() => _clicked = false);
                              } else {
                                login();
                              }
                              setState(() => _clicked = false);
                            }),
                ),
              ],
            ))))
          ]);
        }));
  }
}
