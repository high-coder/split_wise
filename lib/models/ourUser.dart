import 'package:hive/hive.dart';

part 'ourUser.g.dart';

@HiveType(typeId: 123, adapterName: "OurUserDetailOriginal")

class OurUser {
  @HiveField(0)
  String ?name;

  @HiveField(1)
  String ?uid;  // this is the unique identifier of the user

  @HiveField(2)
  String ?email;

  OurUser({this.uid,this.name,this.email});

  Map<String, dynamic> toJson() {
    return {
      "uid": uid,
      "email": email,
      "name": name,
    };
  }


  factory OurUser.fromJson(Map<String, dynamic> data) {
    return OurUser(
      uid: data['uid'],
      email: data['email'],
      name: data["name"]
    );
  }
}