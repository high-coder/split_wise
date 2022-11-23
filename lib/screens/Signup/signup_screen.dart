import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_svg/svg.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:split/controllers/currentState.dart';
import 'package:split/screens/Login/login_screen.dart';
import 'package:split/screens/ReusableWidgets/button.dart';
import 'package:split/utils/our_colours.dart';
import 'package:split/utils/our_text_styles.dart';



class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  var isCustomerSelected = true;
  var loading = false;
  final _formKey = GlobalKey<FormState>();
  var pass = TextEditingController();
  var email = TextEditingController();
  var name = TextEditingController();

  CurrentState _instance = Get.find();
  void _formSubmit(BuildContext ctx) async {

    print('enter');
    print('${email.text.trim()}    ${pass.text.trim()}');

    bool? isValid = _formKey.currentState?.validate();
    final _auth = FirebaseAuth.instance;

    _formKey.currentState?.save();
    FocusScope.of(ctx).unfocus(); //closes keyboard
    print('${email.text.trim()}    ${pass.text.trim()}');
    try {
      if (isValid ?? false) {
        setState(() {
          loading = true;
        });
        String retVal = await _instance.createNewUser(
          email: email.text.trim(),
          password: pass.text.trim(),
          name: name.text,
        );
        if (retVal == "success") {
          // the whole process was successful ready to roll
          loading = false;

        } else {
          setState(() {
            loading = false;
          });
          Fluttertoast.showToast(
              msg: retVal,
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.blue,
              textColor: Colors.white,
              fontSize: 16.0);
        }


      }
    } catch (error) {
      print(error);
      var mes = "Invalid Credentials";
      setState(() {
        loading = false;
      });



    }
  }

  final GlobalKey<ScaffoldState> _scaffoldKey2 = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {

    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      key: _scaffoldKey2,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 0, bottom: 0),
            child: Column(
              children: [
                //header
                Stack(
                  children: [
                    Container(
                      width: width,
                      height: height / 3.3 > 270 ? 280 : height / 3.3,
                      child: SvgPicture.asset(
                        "assets/images/registration/loginTop.svg",
                        semanticsLabel: 'howdy Works',
                        fit: BoxFit.fill,
                      ),
                    ),

                    Positioned(
                      bottom: height > 700 ? 90 : 60,
                      //right: width > 360 ? 20 : 10,
                      left: width > 360 ? 25 : 15,
                      child:
                      Text('Create \n Account', style: MyTextStyle.titleLS),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: height > 360 ? 10 : 5,
                    right: width > 360 ? 20 : 10,
                    left: width > 360 ? 20 : 10,
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                          controller: name,
                          style: MyTextStyle.text2,
                          decoration: const InputDecoration(
                            prefixIcon: Icon(
                              Icons.person_outline,
                              color: MyColors.blue_ribbon,
                            ),
                            labelText: 'Name',
                            labelStyle: MyTextStyle.text1,
                          ),
                          validator: (value) {
                            print(value);
                            print(value);
                            print("this is being called now $value");
                            if (value?.isNotEmpty ?? false) {
                            } else {
                              return "Please enter a name";
                            }
                          },
                          onChanged: (text) {
                            // do something with text
                          },
                        ),
                        TextFormField(
                          controller: email,
                          style: MyTextStyle.text2,
                          decoration: const InputDecoration(
                            prefixIcon: Icon(
                              Icons.email_outlined,
                              color: MyColors.blue_ribbon,
                            ),
                            labelText: 'Email address',
                            labelStyle: MyTextStyle.text1,
                          ),
                          validator: (value) {
                            print(value);
                            if (value?.isNotEmpty ?? false) {
                              if (EmailValidator.validate(email.text)) {
                              } else {
                                return "Enter a valid email";
                              }
                            } else {
                              return "Please enter a email";
                            }
                          },
                          onChanged: (text) {
                            // do something with text
                          },
                        ),
                        TextFormField(
                          controller: pass,
                          decoration: const InputDecoration(
                            prefixIcon: Icon(
                              Icons.lock_outline,
                              color: MyColors.blue_ribbon,
                            ),
                            labelText: 'Password',
                            labelStyle: MyTextStyle.text1,
                          ),
                          style: MyTextStyle.text2,
                          validator: (value) {
                            print(value);
                            if (value != null) {
                              if (value.length < 8) {
                                return "Please enter a 8 digit password";
                              }
                            } else {
                              return "Please enter a password";
                            }
                          },
                          obscureText: true,
                          onChanged: (text) {
                            // do something with text
                          },
                        ),
                        SizedBox(
                          height: height / 70,
                        ),
                        !loading
                            ? GestureDetector(
                          onTap: () {
                            //closes keyboard
                            _formSubmit(context);

                            // here make a call to the function that is going to sign up the user in
                            // the application
                          },
                          child: Button(
                            text: "Sign Up",
                            color: 1,
                          ),
                        )
                            : Center(child: const CircularProgressIndicator()),
                        SizedBox(
                          height: height /
                              30, // Use the same height after 'Or text'
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Expanded(
                              child: Divider(
                                color: MyColors.divider_color,
                                thickness: 2.0,
                                endIndent: 11.0,
                              ),
                            ),
                            Text(
                              'OR',
                              style: MyTextStyle.heading2,
                            ),
                            Expanded(
                              child: Divider(
                                color: MyColors.divider_color,
                                thickness: 2.0,
                                indent: 14.0,
                              ),
                            ),
                          ],
                        ),
                        //Spacer(flex:2),

                        GestureDetector(
                          onTap: () => Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) => const OurLoginPage())),
                          child: Button(
                            text: "Log in",
                            color: 2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

//  if (_formKey.currentState.validate()) {
//                 // text in form is valid
//               }
