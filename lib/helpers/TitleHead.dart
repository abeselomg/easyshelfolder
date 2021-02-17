import 'package:flutter/material.dart';

class TitleHead extends StatelessWidget {
  final String title;
  final String logo;
  final String notification;
  final String icon;
  final String nav;

  TitleHead({@required this.title, this.logo,this.notification,this.icon,this.nav});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(color: Theme.of(context).primaryColor)
          )
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
            SizedBox(
              width: 2,
            ),
          SizedBox(
            width: 2,
          ),
            Image.asset(logo,
            scale: 1.2,
            ),
            Padding(
              padding: EdgeInsets.only(right: 20),
              child: Row(
                children: <Widget>[
                  Image.asset("assets/search.png",),
                  SizedBox(width: 14,),
                  Image.asset("assets/notification.png",width: 28,)
                ],
              )
            ),
        ],
      ),
    );
  }
}