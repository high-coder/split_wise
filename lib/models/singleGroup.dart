import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:split/models/ourUser.dart';

class GroupModel {
  String? groupName;

  String? groupUid;
  String? groupCreator;
  List<dynamic> members;

  List<Transaction>? transactions;
  DateTime? createdAt;
  String ?budget;
  bool end;
  double remaining;
  GroupModel(

      {this.budget,this.createdAt,
      this.groupUid,
      this.transactions,
        this.remaining=0.0,
        this.end = false,
      this.groupCreator,
      this.groupName,
      required this.members});

  factory GroupModel.fromJson(Map<String, dynamic> data, String groupId) {
    List<Transaction> trans = [];
    if(data["transactions"]!=null) {
      data["transactions"].forEach((element) {
        trans.add(Transaction.fromJson(element));
      });
    }

    return GroupModel(
        groupCreator: data["created_by"],
        groupName: data["name"],
        groupUid: groupId,
        transactions: trans,
        createdAt: data["created_at"].toDate(),
        members: data["members"],
      budget:data["budget"],
      end: data["end"] ?? false,
      remaining: data["remaining"] ?? 0.0,
    );
  }
}

class Transaction {
  String description;

  String amount;
  DateTime dateTransaction;

  Transaction(
      {required this.description,
      required this.amount,
      required this.dateTransaction});

  factory Transaction.fromJson(Map<String, dynamic> data) {
    return Transaction(
        description: data["description"],
        amount: data["amount"],
        dateTransaction: data["dateOfTransaction"].toDate());
  }
}
