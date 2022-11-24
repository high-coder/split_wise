import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:neopop/widgets/buttons/neopop_tilted_button/neopop_tilted_button.dart';
import 'package:split/controllers/currentState.dart';
import 'package:split/utils/our_colours.dart';
import 'package:split/utils/our_text_styles.dart';
import 'package:split/utils/screen_loader.dart';

class AddExpense extends StatefulWidget {
  double remaining;
  AddExpense({Key? key,required this.remaining}) : super(key: key);

  @override
  State<AddExpense> createState() => _AddExpenseState();
}

class _AddExpenseState extends State<AddExpense> {

  var description = TextEditingController();
  var amount = TextEditingController();

  final CurrentState _instance = Get.find();
  @override
  Widget build(BuildContext context) {
    return ScreenLoader(
      child: Scaffold(
        body: SafeArea(
          child: Container(
            child: Column(
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
                        controller: description,
                        style: MyTextStyle.text2,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(
                            Icons.person_outline,
                            color: MyColors.blue_ribbon,
                          ),
                          labelText: 'Description',
                          labelStyle: MyTextStyle.text1,
                        ),
                        validator: (value) {
                          print(value);
                          print(value);
                          print("this is being called now $value");
                          if (value?.isNotEmpty ?? false) {
                          } else {
                            return "Please enter a description";
                          }
                        },
                      ),

                    )

                  ],
                ),

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
                        ], // Only numbers can be entered.
                        controller: amount,
                        style: MyTextStyle.text2,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(
                            Icons.person_outline,
                            color: MyColors.blue_ribbon,
                          ),
                          labelText: 'Amount',
                          labelStyle: MyTextStyle.text1,
                        ),
                        validator: (value) {
                          print(value);
                          print(value);
                          print("this is being called now $value");
                          if (value?.isNotEmpty ?? false) {
                          } else {
                            return "Please enter amount";
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
                  onTapUp: () async{
                    if(description.text.isNotEmpty && amount.text.isNotEmpty) {
                      print(widget.remaining);
                      //_instance.createGroup(name: name.text);
                      if(widget.remaining>= double.parse(amount.text)) {
                        await _instance.addExpense(description: description.text, amount: amount.text);
                      } else {
                        _instance.showMessage("Budget will be excedded with this transaction", "Error");
                      }
                    } else {
                      _instance.showMessage("Please enter all fields", "Missing Information");
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 80.0,
                      vertical: 15,
                    ),
                    //child: SvgPicture.asset('assets/svg/cta_text_view.svg'),
                    child: Text("Add"),
                  ),
                ),
                SizedBox(height: 30,),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
