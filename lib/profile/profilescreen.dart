import 'package:easy_shelf/helpers/TitleHead.dart';
import 'package:easy_shelf/helpers/UserData.dart';
import 'profile_categories.dart';
import 'profile_detail.dart';
import 'profile_menu.dart';
import 'package:flutter/material.dart';

class Profile extends StatelessWidget {
  final UserData user;
  final String activeBalance;
  final String pendingBalance;
  Profile({@required this.user,this.activeBalance,this.pendingBalance});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        iconTheme: IconThemeData(color: Color(0xFF1EB998)),
        backgroundColor: Colors.white,
        actions: [
          PopupMenuButton<dynamic>(
            onSelected: (dynamic result) {
              print(result);
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<dynamic>>[
              const PopupMenuItem<dynamic>(
                value: "a",
                child: Text('Send Money'),
              ),
              const PopupMenuItem<dynamic>(
                value: "b",
                child: Text('Withdraw'),
              ),
              const PopupMenuItem<dynamic>(
                value: "c",
                child: Text('Logout'),
              ),
            ],
          )
        ],
      ),
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
                    //  TitleHead(
                    //    title: null,
                    //    logo: 'assets/logo_small.png',
                    //    notification: "2",
                    //  ),
                    // SizedBox(
                    //   height: 20.0,
                    // ),
                    ProfileDetail(
                      user: user,
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    //  ProfileCategories(),
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Material(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            // side: BorderSide(color: Colors.red)
                          ),
                          elevation: 2,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(20.0),
                              ),
                            ),

                            padding: EdgeInsets.all(15),
                            height: MediaQuery.of(context).size.height * 0.35,
                            //  decoration: BoxDecoration(),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Active balance",
                                      style: TextStyle(
                                          fontFamily: 'AirbnbCerealBold',
                                          fontSize: 18,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.black),
                                    ),
                                    IconButton(
                                      icon: Icon(
                                        Icons.add_box_outlined,
                                        size: 30,
                                      ),
                                      onPressed: () {},
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 30,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Container(
                                      width: 70.0,
                                      height: 70.0,
                                      decoration: new BoxDecoration(
                                        color: Color(0xFF1EB998),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Center(
                                        child: Icon(
                                          Icons.account_balance_wallet,
                                          color: Colors.white,
                                          size: 40,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 15,
                                    ),
                                    Text(
                                      // balance != null ? balance.toStringAsFixed(2)+" Br" : '0.00'+" Br",
                                      "1100.00 Br",
                                      style: TextStyle(
                                          fontFamily: 'AirbnbCerealBold',
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black),
                                    ),
                                    SizedBox(
                                      width: 1,
                                    ),
                                    SizedBox(
                                      width: 1,
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                // ClipRRect(
                                //   borderRadius: BorderRadius.circular(20),
                                //   child: RaisedButton(
                                //       child: Text(
                                //         "Deposit",
                                //         style: TextStyle(color: Colors.white),
                                //       ),
                                //       onPressed: () {},
                                //       color: Color(0xFF1EB998),
                                //       shape: RoundedRectangleBorder(
                                //         borderRadius:
                                //             BorderRadius.circular(18.0),
                                //         // side: BorderSide(color: Colors.red)
                                //       )
                                //       // shape: ShapeBorder(),

                                //       ),
                                // ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),

                    ProfileMenu(
                      user,
                    ),
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
