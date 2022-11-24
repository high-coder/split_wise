import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:split/controllers/currentState.dart';
import 'package:split/screens/Groups/add_expense.dart';
import 'package:split/screens/Groups/all_members.dart';
import 'package:split/utils/our_text_styles.dart';
import 'package:split/utils/screen_loader.dart';

class SingleGroup extends StatefulWidget {
  bool loading;
  String? groupId;

  SingleGroup({Key? key, this.loading = false, this.groupId}) : super(key: key);

  @override
  State<SingleGroup> createState() => _SingleGroupState();
}

class _SingleGroupState extends State<SingleGroup> {
  final CurrentState _instance = Get.find();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    doThis();
  }

  doThis() async {
    if (widget.loading) {
      await _instance.fetchSingleGroup(widget.groupId!);

      widget.loading = false;
      setState(() {});
    }
  }

  double remaining = 0;

  @override
  Widget build(BuildContext context) {
    if (widget.loading) {
      return Container();
    } else {
      return ScreenLoader(
        child: Scaffold(
          appBar: AppBar(
            title: Text(_instance.selectedGroup?.groupName ?? ""),
            actions: [
              IconButton(
                  onPressed: () {
                    Share.share(
                        "${_instance.selectedGroup?.groupUid}\npaste this Unique code in the join channel section to join the group");
                  },
                  icon: Icon(Icons.share))
            ],
          ),
          floatingActionButton: _instance.currentUser.uid ==
                      _instance.selectedGroup?.groupCreator &&
                  _instance.selectedGroup?.end == false
              ? GestureDetector(
                  onTap: () {
                    double total = 0;
                    _instance.selectedGroup?.transactions
                        ?.forEach((element) {
                      total += double.parse(element.amount);
                    });

                    remaining = double.parse(
                        _instance.selectedGroup?.budget! ?? "0") -
                        total;
                    Get.to(() => AddExpense(remaining: remaining,));
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    width: 100,
                    height: 50,
                    child: Center(child: Text("Add Expense")),
                  ),
                )
              : Container(),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Container(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 30,
                      ),
                      Builder(
                        builder: (context) {
                          if (_instance.selectedGroup?.members.isNotEmpty ??
                              false) {
                            return GestureDetector(
                                onTap: () {
                                  Get.to(() => AllMembers());
                                },
                                child: Text("View Members "));
                          } else {
                            return const Center(
                                child: Text("No members in the group"));
                          }
                        },
                      ),
                      Row(
                        children: [
                          Text(
                            "Budget: ${_instance.selectedGroup?.budget}",
                            style: MyTextStyle.headingPostPage,
                          )
                        ],
                      ),
                      GetBuilder<CurrentState>(
                        builder: (context) {
                          if (_instance.selectedGroup?.transactions?.isNotEmpty ??
                              false) {
                            return ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount:
                                  _instance.selectedGroup?.transactions?.length,
                              itemBuilder: (context, index) {
                                var data =
                                    _instance.selectedGroup?.transactions?[index];
                                return Container(
                                  margin: EdgeInsets.only(bottom: 10, top: 10),
                                  decoration: BoxDecoration(
                                      border: Border.symmetric(
                                          horizontal: BorderSide(
                                              width: 1,
                                              color:
                                                  Colors.grey.withOpacity(0.4)))),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                              flex: 2,
                                              child: Text(
                                                "${data?.dateTransaction.day}/${data?.dateTransaction.month}",
                                                style: MyTextStyle.usageAgeDate,
                                              )),
                                          Expanded(
                                              flex: 2,
                                              child: Icon(Icons.monetization_on)),
                                          Expanded(
                                              flex: 6,
                                              child: Center(
                                                  child: Text(
                                                "Amount : ${data?.amount}",
                                                style: MyTextStyle.referEarnText,
                                              ))),
                                        ],
                                      ),
                                      Text(
                                        "Description : ${data?.description}",
                                        style: MyTextStyle.referEarnText,
                                      )
                                    ],
                                  ),
                                );
                              },
                            );
                          } else {
                            return Center(
                                child: Text("NO transactions in the group"));
                          }
                        },
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      GetBuilder<CurrentState>(
                        builder: (context) {
                          double total = 0;
                          _instance.selectedGroup?.transactions
                              ?.forEach((element) {
                            total += double.parse(element.amount);
                          });

                          remaining = double.parse(
                                  _instance.selectedGroup?.budget! ?? "0") -
                              total;
                          return Column(
                            children: [
                              Container(
                                margin: EdgeInsets.only(bottom: 10, top: 10),
                                decoration: BoxDecoration(
                                    border: Border.symmetric(
                                        horizontal: BorderSide(
                                            width: 2, color: Colors.red))),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                            flex: 2,
                                            child: Text(
                                              "Total Spent",
                                              style: MyTextStyle.usageAgeDate,
                                            )),
                                        Expanded(
                                            flex: 2,
                                            child: Icon(Icons.monetization_on)),
                                        Expanded(
                                            flex: 6,
                                            child: Center(
                                                child: Text(
                                              "Amount : ${total}",
                                              style: MyTextStyle.referEarnText,
                                            ))),
                                      ],
                                    ),
                                    // Text("Description : ${data?.description}",style: MyTextStyle.referEarnText,)
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(bottom: 10, top: 10),
                                decoration: BoxDecoration(
                                    border: Border.symmetric(
                                        horizontal: BorderSide(
                                            width: 2, color: Colors.green))),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                            flex: 2,
                                            child: Text(
                                              "Total Remaining",
                                              style: MyTextStyle.usageAgeDate,
                                            )),
                                        Expanded(
                                            flex: 2,
                                            child: Icon(Icons.monetization_on)),
                                        Expanded(
                                            flex: 6,
                                            child: Center(
                                                child: Text(
                                              "Amount : ${remaining}",
                                              style: MyTextStyle.referEarnText,
                                            ))),
                                      ],
                                    ),
                                    // Text("Description : ${data?.description}",style: MyTextStyle.referEarnText,)
                                  ],
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                      SizedBox(height: 50),
                      _instance.currentUser.uid ==
                                  _instance.selectedGroup?.groupCreator &&
                              _instance.selectedGroup?.end == false
                          ? GestureDetector(
                              onTap: () async{
                                await _instance.endGroup(remaining);
                                _instance.selectedGroup?.remaining = remaining;
                                setState(() {

                                });
                              },
                              child: Text("End group"))
                          : Container(),
                      _instance.selectedGroup?.end == true
                          ? Builder(
                        builder:(context) {
                          int length =_instance.selectedGroup?.members.length ?? 1;
                          double remainingT = _instance.selectedGroup?.remaining ?? 0.0;
                          return Container(
                            child: Text(
                                "The group has ended with ${remaining/length} divided equally among all users"),
                          );
                        }
                      )
                          : Container(),
                    ],
                  )),
            ),
          ),
        ),
      );
    }
  }
}
