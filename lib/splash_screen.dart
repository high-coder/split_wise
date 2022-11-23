import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:split/controllers/currentState.dart';
import 'package:split/controllers/screen_utils_controller.dart';



class OurSplashScreen extends StatefulWidget {
  const OurSplashScreen({Key? key}) : super(key: key);

  @override
  _OurSplashScreenState createState() => _OurSplashScreenState();
}

class _OurSplashScreenState extends State<OurSplashScreen> {

  @override
  void initState() {
    initialCalls();
  }

  final CurrentState _instance = Get.put(CurrentState());
  final ScreenUtilsLoader _instance2 = Get.put(ScreenUtilsLoader());
  initialCalls() async {

    await _instance.onStartup();

    //await _instance.signOut();

    // Navigator.of(context).push(MaterialPageRoute(builder: (context) => OurChooseScreen()));
  }


  @override
  Widget build(BuildContext context) {

    return Container();
  }
}
