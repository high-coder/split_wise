import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:split/screens/Login/login_screen.dart';

import '../../../controllers/currentState.dart';
import '../../../utils/our_text_styles.dart';


class SideDrawer extends StatefulWidget {
  @override
  _SideDrawerState createState() => _SideDrawerState();
}

class _SideDrawerState extends State<SideDrawer> {
  int currentSelectedIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(currentSelectedIndex);
  }
  CurrentState _instance = Get.find();

  @override
  Widget build(BuildContext context) {


    MediaQueryData mediaQueryData = MediaQuery.of(context);

    // currentSelectedIndex = 0;
    //print(_instance.currentUser);
    //print(_instance.currentUser.uid);
    double width = mediaQueryData.size.width;
    double height = mediaQueryData.size.height;
    return Container(
      width: height > 720 ? width / 1.2 : width / 1.1,
      child: Drawer(
        //semanticLabel: "sf",
        backgroundColor: Colors.white,
        child: ListView(
          children: [
            Container(
              height: height > 720 ? height / 3.4 : height / 2.5,
              child: DrawerHeader(
                decoration: const BoxDecoration(
                  //color: MyColors.appThemeRed,
                  image: DecorationImage(
                    image:
                    AssetImage("assets/images/registration/loginTop (2).png"),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.only(
                      left: width > 360 ? 10 : 5,
                      bottom: height > 360 ? 20 : 10),
                  child: Column(
                    //mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: height > 360 ? 30 : 15,
                        // backgroundImage:  _instance.currentUser!= null ? _instance.currentUser.profileImg!= null ?  NetworkImage(_instance.currentUser.profileImg,) : AssetImage("assets/images/sidebar/profile.jpg") :AssetImage("assets/images/sidebar/profile.jpg"),
                      ),
                      const SizedBox(
                        height: 2,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            flex: 1,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _instance.currentUser.name ?? "Enter name",
                                  style: MyTextStyle.titleLSs,
                                  //style: MyTextStyle.sidebartext1,
                                ),
                                // SizedBox(height: height/199,),
                                Text(
                                  _instance.currentUser.email ?? "Enter Email",
                                  style: MyTextStyle.referEarnTextW,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          // GestureDetector(
                          //   onTap: () {},
                          //   child: Container(
                          //     height: height / 17,
                          //     width: width / 5,
                          //     child: Material(
                          //       color: MyColors.appThemeBlueText,
                          //       shape: RoundedRectangleBorder(
                          //         side: BorderSide(
                          //             color: Colors.blueAccent, width: 1),
                          //         borderRadius: BorderRadius.circular(6.0),
                          //       ),
                          //       elevation: 5.0,
                          //       child: Center(
                          //         child: Text(
                          //           "Profile",
                          //          style: MyTextStyle.referEarnTextW,
                          //         ),
                          //       ),
                          //     ),
                          //   ),
                          // ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),



            CustomListTile(title: "Logout",onTap: () async {
              await _instance.signOut();
              Get.offAll(OurLoginPage());
            }
            ),



            //TileContainer(),
          ],
        ),
      ),
    );
  }
}


class CustomListTile extends StatefulWidget {
  CustomListTile(
      {required this.title,
        //    required this.icon,
        this.isSelected = false,
        required this.onTap});

  final String title;
  //final IconData icon;
  bool focus = true;
  final bool isSelected;
  final Function onTap;

  @override
  _CustomListTileState createState() => _CustomListTileState();
}

class _CustomListTileState extends State<CustomListTile> {
  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);

    double width = mediaQueryData.size.width;
    double height = mediaQueryData.size.height;
    return InkWell(

      onTap: () {
        widget.onTap();
      },
      child: Container(
          height: 60.0,
          padding: EdgeInsets.only(
              top: height > 720 ? 0 : 0,
              left: width > 720 ? 20 : 5,
              right: width > 720 ? 10 : 5,
              bottom: height > 720 ? 0 : 0),
          // margin: EdgeInsets.all(20.0),
          margin: const EdgeInsets.only(
            left: 1,
            right: 1,
          ),
          decoration: BoxDecoration(
            //color: Colors.black.withOpacity(0.4),
              border: Border.all(color: Colors.black.withOpacity(0.3),width: 1)

          ),
          child: Center(
            child: Text(
              widget.title,
              style: MyTextStyle.referEarnText,
            ),
          )
      ),
    );
  }
}
