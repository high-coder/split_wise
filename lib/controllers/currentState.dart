import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:split/controllers/screen_utils_controller.dart';
import 'package:split/models/ourUser.dart';
import 'package:split/models/singleGroup.dart';
import 'package:split/screens/HomeScreen/home_screen.dart';
import 'package:split/screens/Login/login_screen.dart';
import 'package:split/screens/Signup/signup_screen.dart';
import 'package:split/services/our_database.dart';
import 'package:split/utils/our_text_styles.dart';

import '../screens/Groups/single_group.dart';

class CurrentState extends GetxController {
  final _auth = FirebaseAuth.instance;

  // this will contain all the information about the user
  OurUser currentUser = OurUser();
  late Box userBox;

  onStartup() async {
    String where = "signup";
    userBox = await Hive.openBox("userDetails");
    //await signOut();

    OurUser? currentUser2;
    currentUser2 = await userBox.get("data");

    if(currentUser2!=null) {
      currentUser = currentUser2!;

    }
    // Navigate to the first screen of the application
    if (currentUser2 == null) {
      Get.offAll(SignupScreen());
    } else if (currentUser2.uid != null) {
      Get.offAll(OurHomeScreen());
    }
  }

  Future<String> loginUser(String email, String password) async {
    String retVal = "error";
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      if (result.user != null) {
        retVal = "success";

        currentUser = await OurDatabase().getUserInfo(result.user?.uid ?? "");
        if (currentUser.uid == "thisisthat") {}

        userBox.put("data", currentUser);
        Get.offAll(const OurHomeScreen());
        // currentUser.email = result.user?.email;
        // currentUser.uid = result.user?.displayName;
      }
    } on FirebaseAuthException catch (e) {
      retVal = e.message ?? "something went wrong";
      print(e.toString());
    }
    return retVal;
  }

  Future<String> createNewUser(
      {required String name,
      required String email,
      required String password}) async {
    String retVal = "error";
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      if (result.user != null) {
        User? user = result.user;
        currentUser.email = user?.email;
        currentUser.name = name;
        currentUser.uid = user?.uid;

        retVal = await OurDatabase().createUser(currentUser);

        if (retVal == "success") {
          userBox.put("data", currentUser);
        }
        Get.offAll(() => const OurLoginPage());
      }

      // await DatabaseManager().getUsersList(user.uid);

    } on FirebaseAuthException catch (e) {
      retVal = e.message ?? "something went wrong";
    }

    return retVal;
  }

  createGroup({required String name,required String budget}) async {
    ScreenUtilsLoader instance = Get.find();
    instance.disableScreen.value = true;
    Map<String, dynamic> retVal =
        await OurDatabase().createAGroup(currentUser.uid!, name,budget);
    instance.disableScreen.value = false;
    if (retVal["success"] == true) {
      print("Inside the group page");
      print(retVal);
      selectedGroup = GroupModel(
          groupName: retVal["name"],
          groupUid: retVal["group_uid"],
          transactions: [],
          groupCreator: currentUser.uid,
          members: [],
          budget: retVal["budget"],
          createdAt: retVal["created_at"]);
      Get.to(() => SingleGroup());
      fetchAllGroups();
      // navigate the user to the groups page
    } else {
      // show user the error message
    }
  }

  GroupModel? selectedGroup;

  /// this function will be used to add expense
  addExpense({required String description, required String amount}) async {
    print("Inside here mate");
    ScreenUtilsLoader instance = Get.find();
    instance.disableScreen.value = true;
    String retVal = await OurDatabase()
        .addExpense(description: description, amount: amount);
    instance.disableScreen.value = false;
    if (retVal == "success") {
      Get.back(); //also add this transaction to the list of transaction
      if(selectedGroup?.transactions==null) {
        selectedGroup?.transactions = [];
      }
      selectedGroup?.transactions?.add(Transaction(
          description: description,
          amount: amount,
          dateTransaction: DateTime.now()));
      update();
    }
  }



  showMessage(String messageText,String title) {
    Get.showSnackbar(GetSnackBar(messageText: Text(messageText,style: MyTextStyle.referEarnTextW,),title: title,));
  }
  List<GroupModel> groups = [];
  fetchAllGroups() async{
    groups = await OurDatabase().fetchAllGroups();
    update();
  }

  fetchSingleGroup(String selectedGroupId) async{
    selectedGroup = await OurDatabase().fetchSingleGroup(selectedGroupId);
  }

  joinGroup(String name) async{
    ScreenUtilsLoader l = Get.find();
    l.disableScreen.value = true;
    String retVal = await OurDatabase().addMemberToGroup(memberUid: currentUser.uid!,groupUid: name);
    if(retVal != "success") {
      showMessage("$retVal", "Error");
      l.disableScreen.value = false;

      return ;
    }
    await fetchAllGroups();
    l.disableScreen.value = false;
    Get.to(() => OurHomeScreen());
  }
  // this is the function to sign out of the application
  Future signOut() async {
    try {
      await _auth.signOut();
      await userBox.delete("data");
      currentUser = OurUser();
      return;
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  endGroup(double remaining) async{
    ScreenUtilsLoader l = Get.find();
    l.disableScreen.value =true;
    await OurDatabase().endGroup(remaining);
    l.disableScreen.value =false;
    selectedGroup?.end = true;
    //update();
  }
}
