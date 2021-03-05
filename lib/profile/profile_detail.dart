import 'constant.dart';
import 'general.dart';
import 'profile_image.dart';
import 'package:flutter/material.dart';
import 'package:easy_shelf/helpers/UserData.dart';

class ProfileDetail extends StatelessWidget {
  final UserData user;
  ProfileDetail({@required this.user});
  @override
  Widget build(BuildContext context) {
    Size deviceSize = MediaQuery.of(context).size;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Material(
        borderRadius: BorderRadius.all(
          Radius.circular(20.0),
        ),
        elevation: 10.0,
        child: user != null ?
        GestureDetector(
          onTap: () {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) =>GeneralPage()));
          },
          child: Container(
            height: deviceSize.height * 0.17,
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            decoration: BoxDecoration(
              color: Color(0xFF1EB998),
              borderRadius: BorderRadius.all(
                Radius.circular(20.0),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    ProfileImage(
                      height: 70.0,
                      width: 70.0,
                      picUrl: user != null ? user.profile: "undefined" ,
                    ),
                    SizedBox(
                      width: 20.0,
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(
                          width: 200,
                          child: Text(
                            user != null ? user.username != null ? user.username : "undefined": "undefined" ,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 5.0,
                        ),
                        Text(
                          user.mobile != null ? (user.country_code??"") + user.mobile: "undefined" ,
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 13.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 15.0,
                ),
              ],
            ),
          ),
        )
            :
        Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}