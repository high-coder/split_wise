import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:split/controllers/currentState.dart';

import '../models/ourUser.dart';
import '../models/singleGroup.dart';

class OurDatabase {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> createUser(OurUser user) async {
    String retVal = "error";

    try {
      await _firestore.collection('users').doc(user.uid).set(user.toJson());
      retVal = "success";
    } catch (e) {
      print(e);
    }
    return retVal;
  }

  Future<OurUser> getUserInfo(String uid) async {
    OurUser retVal = OurUser();

    try {
      // this block is running fine
      DocumentSnapshot _docSnapshot =
          await _firestore.collection("users").doc(uid).get();
      print("Above the document snapshot data");
      print(_docSnapshot.data());
      print("below the document snapshot data");
      //retVal(_docSnapshot.data()['name']);

      Map<String, dynamic>? data = _docSnapshot.data() as Map<String, dynamic>?;
      retVal = OurUser.fromJson(_docSnapshot.data() as Map<String, dynamic>);

      print("Exiting the get user information function now");
    } catch (e) {
      print("in the catch of the get user info");
      print(e);
    }
    return retVal;
  }

  /// --------------- Function to create a group ----------------------------///
  Future<Map<String, dynamic>> createAGroup(
      String uid, String name, String budget) async {
    Map<String, dynamic> returnVal = {};
    String retVal = "error";
    try {
      CurrentState _instance = Get.find();

      final batch = _firestore.batch();
      late String randomGroupName;
      var intValue = Random().nextInt(10000000);
      randomGroupName = intValue.toString();
      var snap = _firestore.collection("users").doc(uid);
      batch.update(snap, {
        "groups": FieldValue.arrayUnion(["$randomGroupName-$name"])
      });

      var snap2 = _firestore.collection("groups").doc(randomGroupName);
      batch.set(snap2, {
        "created_by": uid,
        "created_at": DateTime.now(),
        "members": [
          "$uid-${_instance.currentUser.name}",
        ],
        "name": name,
        "budget": budget,
      });

      await batch.commit();
      returnVal = {
        "created_by": uid,
        "created_at": DateTime.now(),
        "budget": budget,
        "members": [
          uid,
        ],
        "name": name,
        "group_uid": randomGroupName,
        "success": true,
      };
      retVal = "success";
    } catch (e) {
      returnVal = {
        "success": false,
      };
      print(e);
    }

    return returnVal;
  }

  Future<String> addMemberToGroup(
      {required String memberUid, required String groupUid}) async {
    String retVal = "error";

    try {
      CurrentState _instance = Get.find();
      var doc2 = await _firestore.collection("groups").doc(groupUid).get();
      if (doc2.exists) {
        final batch = _firestore.batch();
        var snap1 = _firestore.collection("users").doc(memberUid);

        batch.update(snap1, {
          "groups": FieldValue.arrayUnion(["$groupUid-${doc2.data()!["name"]}"])
        });

        var snap2 = _firestore.collection("groups").doc(groupUid);
        batch.update(snap2, {
          "members": FieldValue.arrayUnion(
              ["$memberUid-${_instance.currentUser.name}"])
        });

        await batch.commit();
        retVal = "success";
      } else {
        retVal = "Group does not exist";
      }
    } catch (e) {
      print(e);
    }

    return retVal;
  }

  Future<String> addExpense(
      {required String description, required String amount}) async {
    String retVal = "error";

    try {
      final CurrentState instance = Get.find();
      final batch = _firestore.batch();

      var snap1 = _firestore
          .collection("groups")
          .doc(instance.selectedGroup?.groupUid!);
      batch.update(snap1, {
        "transactions": FieldValue.arrayUnion([
          {
            "description": description,
            "amount": amount,
            "dateOfTransaction": DateTime.now(),
          }
        ])
      });

      await batch.commit();
      retVal = "success";
    } catch (e) {
      print(e);
    }
    return retVal;
  }

  /// ------------------- BATCH IMPLEMENTED ---------------------------------///
  /// this function is responsible for creating a sucessful post to the server
  /// with also uploading the relevant file to the server
  /// ------------------- TEST COMPLETE ------------------------------------///

  /// -------------------- this function will be used to fetch all the groups in the application -------------------///
  Future<List<GroupModel>> fetchAllGroups() async {
    List<GroupModel> groups = [];

    CurrentState instance = Get.find();
    try {
      var snap = await _firestore
          .collection("users")
          .doc(instance.currentUser.uid)
          .get();
      print(snap.data());
      Map<String, dynamic> data = snap.data() ?? {};
      if (data["groups"] != null) {
        data["groups"].forEach((element) {
          String something = element;
          List data = something.split("-");
          groups.add(
            GroupModel(members: [], groupName: data[1], groupUid: data[0]),
          );
        });
      }
    } catch (e) {
      print(e);
    }

    return groups;
  }

  Future<GroupModel> fetchSingleGroup(String docToSearchFor) async {
    GroupModel group = GroupModel(members: []);
    var snap = await _firestore.collection("groups").doc(docToSearchFor).get();
    group = GroupModel.fromJson(snap.data()!, docToSearchFor);

    return group;
  }

  endGroup(double remaining) async {
    try {
      CurrentState _instance = Get.find();
      _firestore
          .collection("groups")
          .doc(_instance.selectedGroup?.groupUid)
          .update({
        "end":true,
        "remaining":remaining
      });
    } catch (e) {}
  }
}
