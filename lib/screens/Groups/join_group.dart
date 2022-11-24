import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:neopop/widgets/buttons/neopop_tilted_button/neopop_tilted_button.dart';
import 'package:split/utils/screen_loader.dart';

import '../../controllers/currentState.dart';
import '../../utils/our_colours.dart';
import '../../utils/our_text_styles.dart';

class JoinGroup extends StatefulWidget {
  const JoinGroup({Key? key}) : super(key: key);

  @override
  State<JoinGroup> createState() => _JoinGroupState();
}

class _JoinGroupState extends State<JoinGroup> {
  CurrentState _instance = Get.find();
  var name = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ScreenLoader(
      child: Scaffold(
        body: SafeArea(
          child: Container(
            child: Column(
              children: [
                const SizedBox(
                  height: 30,
                ),
                Row(
                  children: [
                    Expanded(flex: 2, child: Container()),
                    Expanded(
                      flex: 10,
                      child: TextFormField(
                        keyboardType: TextInputType. number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        controller: name,
                        style: MyTextStyle.text2,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(
                            Icons.person_outline,
                            color: MyColors.blue_ribbon,
                          ),
                          labelText: 'Group id',
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
                const SizedBox(
                  height: 30,
                ),
                const Spacer(
                  flex: 1,
                ),
                NeoPopTiltedButton(
                  color: Colors.green,
                  onTapUp: () {
                    if (name.text.isNotEmpty) {
                      _instance.joinGroup(name.text);
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 80.0,
                      vertical: 15,
                    ),
                    //child: SvgPicture.asset('assets/svg/cta_text_view.svg'),
                    child: Text("Join Group"),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
