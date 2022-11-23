import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:neopop/utils/constants.dart';
import 'package:neopop/widgets/buttons/neopop_button/neopop_button.dart';
import 'package:split/controllers/currentState.dart';
import 'package:split/screens/Groups/create_group.dart';
import 'package:split/screens/Groups/join_group.dart';
import 'package:split/screens/Groups/single_group.dart';

import 'drawer/drawer.dart';

class OurHomeScreen extends StatefulWidget {
  const OurHomeScreen({Key? key}) : super(key: key);

  @override
  State<OurHomeScreen> createState() => _OurHomeScreenState();
}

class _OurHomeScreenState extends State<OurHomeScreen> {


  final CurrentState _instance = Get.find();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _instance.fetchAllGroups();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text("SplitIt"),
      ),
      drawer: SideDrawer(),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.only(left:20,right: 20),
          child: Column(

            children: [
              SizedBox(height: 30,),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: NeoPopButton(
                      color: Colors.green,

                      buttonPosition: Position.fullBottom,
                      depth: kButtonDepth,
                      onTapUp: () {
                        Get.to(() => JoinGroup());
                      },
                      child: const Center(
                        child:  Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 15.0),
                          child: Text("Join a group"),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 30,),
                  Expanded(
                    child: NeoPopButton(
                      color: Colors.green,
                      //bottomShadowColor: kShadowColorDarkGreen,
                      //rightShadowColor: kShadowColorGreen,
                      buttonPosition: Position.fullBottom,
                      depth: kButtonDepth,
                      onTapUp: () {
                        Get.to(()=> CreateGroup());
                      },
                      border: Border.all(
                        color: Colors.black54, width: 1,
                      ),
                      child: const Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric( horizontal: 8.0, vertical: 15.0),
                          child: Text(
                            "Create a group",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30,),
              GetBuilder<CurrentState>(
                builder: (context) {
                  // show the loader here too
                  if(_instance.groups.isNotEmpty) {
                    return Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: _instance.groups.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              // navigate the user to the group page

                              Get.to(() => SingleGroup(loading: true,groupId: _instance.groups[index].groupUid,));
                              //SingleGroup();
                            },
                            child: Container(
                              //padding:EdgeInsets.only(left: 20,right: 20),
                              margin: EdgeInsets.only(bottom: 20),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex:1,
                                    child: Container(
                                      width: 100,
                                      height: 100,
                                      color: Colors.red,),
                                  ),
                                  Expanded(
                                    flex:1,
                                    child: Center(child: Text(_instance.groups[index].groupName!),),
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  } else{
                    return Text("You are currently in no group");
                  }
                },
              ),

            ],
          ),
        ),
      ),
    );
  }
}
