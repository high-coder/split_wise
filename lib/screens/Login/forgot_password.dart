
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:split/controllers/currentState.dart';
import 'package:split/utils/our_colours.dart';
import 'package:split/utils/our_text_styles.dart';

import '../ReusableWidgets/button.dart';



class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final _formKeyLogin = GlobalKey<FormState>();
  var isLoading = false;
  TextEditingController email = TextEditingController();
  TextEditingController pass = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  CurrentState _instance = Get.find();
  _LoginUser() async {
    final isvalid = _formKeyLogin.currentState?.validate();
    final _auth = FirebaseAuth.instance;
    late String retVal = "";
    _formKeyLogin.currentState?.save();
    if (isvalid ?? false) {
      try {
        setState(() {
          isLoading = true;
        });
        var response = await _auth.sendPasswordResetEmail(email: email.text);
        retVal = "Email Sent successfully";
      } on FirebaseAuthException catch(e) {
        retVal = e.code;
        print(e.code);
        if(e.code == "user-not-found") {
          retVal = "user does not exist";
        } else {
          retVal = "Something went wrong";
        }
      }
    }
    Fluttertoast.showToast(
        msg: retVal,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.blue,
        textColor: Colors.white,
        fontSize: 16.0);

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {


    MediaQueryData mediaQueryData = MediaQuery.of(context);

    double width = mediaQueryData.size.width;
    double height = mediaQueryData.size.height;
    return Scaffold(
      key: _scaffoldKey,
      //resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              //mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Stack(
                  children: [

                    SizedBox(
                      width: width,
                      height: height / 3.3 > 270 ? 280 : height / 3.3,
                      child: SvgPicture.asset(
                        "assets/images/registration/loginTop.svg",
                        semanticsLabel: 'howdy Works',fit: BoxFit.fill,
                      ),
                    ),

                    Positioned(
                      bottom: height > 700 ? 90 : 60,
                      //right: width > 360 ? 20 : 10,
                      left: width > 360 ? 25 : 15,
                      child: Text('Reset \nPassword',
                          style: MyTextStyle.titleLS),
                    ),
                    // Container(
                    //   width: width,
                    //   height: height / 3.3 > 270 ? 280 : height / 3.3,
                    //   padding: EdgeInsets.only(
                    //     left: width > 360 ? 20 : 10,
                    //   ),
                    //   decoration:const BoxDecoration(
                    //       image: DecorationImage(
                    //           image: AssetImage("assets/images/registration/loginTop2.png"),
                    //           fit: BoxFit.fill)),
                    //   child: Stack(
                    //     children: [
                    //
                    //     ],
                    //   ),
                    // ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: height > 360 ? 10 : 5,
                    right: width > 360 ? 20 : 10,
                    left: width > 360 ? 20 : 10,
                  ),
                  child: Form(
                    key: _formKeyLogin,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 50,
                        ),
                        TextFormField(
                          controller: email,
                          decoration:const InputDecoration(
                            prefixIcon: Icon(
                              Icons.email_outlined,
                              color: MyColors.blue_ribbon,
                            ),
                            labelText: 'Email address',
                            labelStyle: MyTextStyle.text1,
                          ),
                          style: MyTextStyle.text2,
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
                        SizedBox(
                          height: height / 40,
                        ),

                        SizedBox(height: 100,),
                        !isLoading
                            ? GestureDetector(
                          onTap: () {
                            FocusScope.of(context)
                                .unfocus(); //closes keyboard
                            _LoginUser();
                          },
                          child: Button(
                            text: "Send Email",
                            color: 1,
                          ),
                        )
                            : const Center(child: CircularProgressIndicator()),

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
