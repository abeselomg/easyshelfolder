import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_shelf/helpers/UserData.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

// Define a custom Form widget.
class ServicesPage extends StatefulWidget {
  @override
  _ServicesPage createState() => _ServicesPage();
}

class _ServicesPage extends State<ServicesPage> {

  @override
  void initState(){
    super.initState();
    
  }

  @override
  Widget build(BuildContext context) {
  // print(coffeeUser);
    Size deviceSize = MediaQuery.of(context).size;
    return Container(
                    padding: EdgeInsets.all(10),
                    child: Material(
                      borderRadius: BorderRadius.all(
                        Radius.circular(20.0),
                      ),
                      elevation: 10.0,
                      child: Container(
                        height: deviceSize.height * 0.15,
                        padding: EdgeInsets.symmetric(horizontal: 20.0),
                        decoration: BoxDecoration(
                          color: Color(0xFF1EB998),
                          borderRadius: BorderRadius.all(
                            Radius.circular(20.0),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                  Container(
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.red,
                                    image: DecorationImage(
                                      image: CachedNetworkImageProvider("https://cdn.business2community.com/wp-content/uploads/2017/08/blank-profile-picture-973460_640.png"),
                                      fit: BoxFit.contain,
                                    ),
                                    border: Border.all(
                                      color: Color(0xFF1EB998),
                                      width: 3.0,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 30.0,
                                ),
                                Column(
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      "Test Author" ,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5.0,
                                    ),
                                    Text(
                                      "+251915151555" ,
                                      style: TextStyle(
                                        color: Colors.white70,
                                        fontSize: 13.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  width: 20.0,
                                ),
                            
                              ],
                            ),
                            SizedBox(
                              height: 20.0,
                            ),
                        
                          ],
                        ),
                      )
                      ),
                    
    );
  }
}