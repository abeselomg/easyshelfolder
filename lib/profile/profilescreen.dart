import 'package:easy_shelf/helpers/TitleHead.dart';
import 'package:easy_shelf/helpers/UserData.dart';
import 'profile_categories.dart';
import 'profile_detail.dart';
import 'profile_menu.dart';
import 'package:flutter/material.dart';

class Profile extends StatelessWidget {
  final UserData user;
  Profile({@required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     body: SafeArea(
       child: Container(
         color: Colors.white,
         child: Column(
           //mainAxisSize: MainAxisSize.max,
           crossAxisAlignment: CrossAxisAlignment.start,
           children: <Widget>[
             Expanded(
               child: ListView(
                 shrinkWrap: true,
                 children: <Widget>[
                   TitleHead(
                     title: null,
                     logo: 'assets/logo_small.png',
                     notification: "2",
                   ),
                   SizedBox(
                     height: 10.0,
                   ),
                   ProfileDetail(user: user,),
                   SizedBox(
                     height: 30.0,
                   ),
                   ProfileCategories(),
                   SizedBox(
                     height: 30.0,
                   ),
                   ProfileMenu(user,),
                 ],
               ),
             )
           ],
         ),
       ),
     ),
    );
  }
}