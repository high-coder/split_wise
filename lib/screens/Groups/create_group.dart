import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:neopop/neopop.dart';
import 'package:split/controllers/currentState.dart';
import 'package:split/utils/our_text_styles.dart';
import 'package:split/utils/screen_loader.dart';

import '../../utils/our_colours.dart';

class CreateGroup extends StatefulWidget {
  const CreateGroup({Key? key}) : super(key: key);

  @override
  State<CreateGroup> createState() => _CreateGroupState();
}

class _CreateGroupState extends State<CreateGroup> {
  TextEditingController name = TextEditingController();
  TextEditingController budget = TextEditingController();


  final CurrentState _instance = Get.find();
  @override
  Widget build(BuildContext context) {
    Size size =  MediaQuery.of(context).size;
    return ScreenLoader(child: Scaffold(
      body: SafeArea(
        child: Container(
            child:Column(
              children: [
                const SizedBox(height: 30,),
                Row(
                  children: [
                    Expanded(
                        flex: 2,
                        child: Container()),
                    Expanded(
                      flex: 10,
                      child:TextFormField(
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
                      ),

                    )

                  ],
                ),
                const SizedBox(height: 30,),

                Row(
                  children: [
                    Expanded(
                        flex: 2,
                        child: Container()),
                    Expanded(
                      flex: 10,
                      child:TextFormField(
                        keyboardType: TextInputType. number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        controller: budget,
                        style: MyTextStyle.text2,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(
                            Icons.person_outline,
                            color: MyColors.blue_ribbon,
                          ),
                          labelText: 'Budget',
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
                      ),

                    )

                  ],
                ),
                const SizedBox(height: 30,),

                const Spacer(flex: 1,),
                NeoPopTiltedButton(
                  color: Colors.green,
                  onTapUp: () {
                    if(name.text.isNotEmpty && budget.text.isNotEmpty) {
                      _instance.createGroup(name: name.text,budget:budget.text);
                    } else {
                      _instance.showMessage("Enter all data", "Error");
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 80.0,
                      vertical: 15,
                    ),
                    //child: SvgPicture.asset('assets/svg/cta_text_view.svg'),
                    child: Text("Create Group"),
                  ),
                ),
                SizedBox(height: 30,),

              ],
            )
        ),
      ),
    ));
  }
}
