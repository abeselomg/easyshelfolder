import 'package:easy_shelf/helpers/UserData.dart';
import 'package:easy_shelf/views/ChangePass.dart';
import 'constant.dart';
import 'package:flutter/material.dart';

class ProfileMenu extends StatelessWidget {
  final UserData user;
  ProfileMenu(this.user);
  @override
  Widget build(BuildContext context) {
    Size deviceSize = MediaQuery.of(context).size;
    return Container(
      height: deviceSize.height * 0.43,
      padding: EdgeInsets.all(10),
      child:ListView(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: <Widget>[
              //     GestureDetector(
              //       onTap: () {
              //         // Navigator.push(
              //         //     context,
              //         //     MaterialPageRoute(builder: (context) => AccountPage()));
              //       },
              //       child: Container(
              //         height: deviceSize.height * 0.14,
              //         width: deviceSize.width * 0.45,
              //         decoration: BoxDecoration(
              //           color: Colors.white,
              //           border: Border.all(color: Color.fromRGBO(44, 141,121,1),width: 1,style: BorderStyle.solid),
              //           borderRadius: BorderRadius.circular(
              //             10.0,
              //           ),
              //         ),
              //         child:  Padding(
              //           padding: const EdgeInsets.symmetric(horizontal: 10.0),
              //           child: ListView(
              //             scrollDirection: Axis.horizontal,
              //             children: <Widget>[
              //               Container(
              //                 padding: EdgeInsets.all(8.0),
              //                 decoration: BoxDecoration(
              //                   shape: BoxShape.circle,
              //                   color: profile_info_background,
              //                 ),
              //                 child: Icon(
              //                   Icons.account_balance_wallet,
              //                   color: Colors.white,
              //                 ),
              //               ),
              //               Container(
              //                 width: deviceSize.width * 0.27,
              //                 margin: EdgeInsets.only(left: 15.0),
              //                 child: Column(
              //                   mainAxisAlignment: MainAxisAlignment.center,
              //                   crossAxisAlignment: CrossAxisAlignment.start,
              //                   children: <Widget>[
              //                     Text(
              //                       'Bank Account',
              //                       style: TextStyle(
              //                         fontSize: 18.0,
              //                         color: Colors.black,
              //                         fontWeight: FontWeight.bold,
              //                       ),
              //                     ),
              //                     SizedBox(
              //                       height: 10,
              //                     ),
              //                     Text(
              //                       'Link Your Accounts',
              //                       style: TextStyle(
              //                         fontSize: 14.0,
              //                         color: profile_item_color,
              //                         fontWeight: FontWeight.bold,
              //                       ),
              //                     ),
              //                   ],
              //                 ),
              //               )
              //             ],
              //           ),
              //         ),
              //       ),
              //     ),
              //     GestureDetector(
              //       onTap: () {
              //       },
              //       child: Container(
              //         height: deviceSize.height * 0.14,
              //         width: deviceSize.width * 0.45,
              //         decoration: BoxDecoration(
              //           color: Colors.white,
              //           border: Border.all(color: Color.fromRGBO(44, 141,121,1),width: 1,style: BorderStyle.solid),
              //           borderRadius: BorderRadius.circular(
              //             10.0,
              //           ),
              //         ),
              //         child:  Padding(
              //           padding: const EdgeInsets.symmetric(horizontal: 10.0),
              //           child: ListView(
              //             scrollDirection: Axis.horizontal,
              //             children: <Widget>[
              //               Container(
              //                 padding: EdgeInsets.all(8.0),
              //                 decoration: BoxDecoration(
              //                   shape: BoxShape.circle,
              //                   color: profile_info_background,
              //                 ),
              //                 child: Icon(
              //                   Icons.credit_card_outlined,
              //                   color: Colors.white,
              //                 ),
              //               ),
              //               Container(
              //                 margin: EdgeInsets.only(left: 15.0),
              //                 width: deviceSize.width * 0.25,
              //                 child: Column(
              //                   mainAxisAlignment: MainAxisAlignment.center,
              //                   crossAxisAlignment: CrossAxisAlignment.start,
              //                   children: <Widget>[
              //                     Text(
              //                       'Easy Card',
              //                       style: TextStyle(
              //                         fontSize: 18.0,
              //                         color: Colors.black,
              //                         fontWeight: FontWeight.bold,
              //                       ),
              //                     ),
              //                     SizedBox(
              //                       height: 10,
              //                     ),
              //                     Text(
              //                       'Manage Your Cards',
              //                       overflow: TextOverflow.clip,
              //                       style: TextStyle(
              //                         fontSize: 14.0,
              //                         color: profile_item_color,
              //                         fontWeight: FontWeight.bold,
              //                       ),
              //                     ),
              //                   ],
              //                 ),
              //               )
              //             ],
              //           ),
              //         ),
              //       ),
              //     )
              //   ],
              // ),
              // SizedBox(
              //   height: 10,
              // ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      // Navigator.of(context).push(
                      //     MaterialPageRoute(builder: (context) =>ChangePassPage(user: this.user)));
                    },
                    child: Container(
                      height: deviceSize.height * 0.14,
                      width: deviceSize.width * 0.45,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Color.fromRGBO(44, 141,121,1),width: 1,style: BorderStyle.solid),
                        borderRadius: BorderRadius.circular(
                          10.0,
                        ),
                      ),
                      child:  Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: profile_info_background,
                              ),
                              child: Icon(
                                Icons.security,
                                color: Colors.white,
                              ),
                            ),
                            Container(
                              width: deviceSize.width * 0.27,
                              margin: EdgeInsets.only(left: 15.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    'Security',
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    'Change Data',
                                    style: TextStyle(
                                      fontSize: 14.0,
                                      color: profile_item_color,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                    },
                    child: Container(
                      height: deviceSize.height * 0.14,
                      width: deviceSize.width * 0.45,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Color.fromRGBO(44, 141,121,1),width: 1,style: BorderStyle.solid),
                        borderRadius: BorderRadius.circular(
                          10.0,
                        ),
                      ),
                      child:  Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: profile_info_background,
                              ),
                              child: Icon(
                                Icons.history,
                                color: Colors.white,
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 15.0),
                              width: deviceSize.width * 0.25,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    'History',
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    'Look Up Your History',
                                    overflow: TextOverflow.clip,
                                    style: TextStyle(
                                      fontSize: 14.0,
                                      color: profile_item_color,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}