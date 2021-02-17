import 'package:easy_shelf/views/MainApp.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import 'constant.dart';
import 'package:flutter/material.dart';
import 'package:easy_shelf/helpers/sharedPref.dart';

class Category extends StatelessWidget {
  final Catg catg;
  Category({this.catg});
  final SharedPref sharedPref = new SharedPref();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Stack(
          overflow: Overflow.visible,
          children: <Widget>[
            GestureDetector(
              onTap: () {
                if (catg.name == "Log Out"){
                  showDialog(
                    context: context,builder: (BuildContext context) => NetworkGiffyDialog(
                      image:  Image.network(
                        "https://raw.githubusercontent.com/Shashank02051997/FancyGifDialog-Android/master/GIF's/gif14.gif",
                        fit: BoxFit.cover,
                      ),
                  title: Text('Are you sure?',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 22.0,
                          fontWeight: FontWeight.w600)),
                    description:Text('If you log out some data might be lost',
                      textAlign: TextAlign.center,
                    ),
                    entryAnimation: EntryAnimation.BOTTOM_LEFT,
                    onOkButtonPressed: () {
                      sharedPref.remove("isLoggedIn");
                      sharedPref.remove("user");
                      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
                          builder: (context) => MainAppPage(page: 2)
                      ), (Route<dynamic> route) => false);
                    },
                  ) );
                }
              },
              child: Container(
                padding: EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: profile_info_categories_background,
                ),
                child: Icon(
                  catg.icon,
                  // size: 20.0,
                ),
              ),
            ),
            catg.number > 0
                ? Positioned(
              right: -5.0,
              child: Container(
                padding: EdgeInsets.all(5.0),
                decoration: BoxDecoration(
                  color: profile_info_background,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  catg.number.toString(),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10.0,
                  ),
                ),
              ),
            )
                : SizedBox(),
          ],
        ),
        SizedBox(
          height: 10.0,
        ),
        Text(
          catg.name,
          style: TextStyle(
            fontSize: 13.0,
          ),
        )
      ],
    );
  }
}