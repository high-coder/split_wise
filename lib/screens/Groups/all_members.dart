import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:split/controllers/currentState.dart';

import '../../utils/our_text_styles.dart';

class AllMembers extends StatefulWidget {
  const AllMembers({Key? key}) : super(key: key);

  @override
  State<AllMembers> createState() => _AllMembersState();
}

class _AllMembersState extends State<AllMembers> {
  CurrentState instance = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("All Members"),
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.only(left: 20, right: 20),
          child: Column(
            children: [
              SizedBox(
                height: 30,
              ),
              Expanded(
                  child: ListView.builder(
                itemCount: instance.selectedGroup?.members.length,
                itemBuilder: (context, index) {
                  List something =
                      instance.selectedGroup?.members[index].split("-");
                  print(something);
                  return Container(
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: Colors.grey.withOpacity(0.4), width: 1),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 30,
                        ),
                        SizedBox(
                          width: 30,
                        ),
                        Container(
                          child: Text(
                            "${something[1]}",
                            style: MyTextStyle.appBarTextSupporting,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ))
            ],
          ),
        ),
      ),
    );
  }
}
