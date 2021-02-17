import 'package:easy_shelf/bloc.navigation_bloc/navigation_bloc.dart';
import 'package:easy_shelf/helpers/TitleHead.dart';
import 'package:easy_shelf/views/Authentication.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'Signup.dart';
import 'package:flutter_bloc/flutter_bloc.dart' as bl;

class FirstPage extends StatefulWidget {
  @override
  _FirstPage createState() => _FirstPage();
}

class _FirstPage extends State<FirstPage> {

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
      onWillPop: () => SystemNavigator.pop(),
      child: Scaffold(
        body: SafeArea(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            height: MediaQuery.of(context).size.height,
            child:  Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  TitleHead(
                    title: null,
                    logo: 'assets/logo_small.png',
                    notification: "2",
                  ),
                  Container(
                    child: Column(
                      children: <Widget>[
                        InkWell(
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) => LoginPage(0)));
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.symmetric(vertical: 13),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(5)),
                                boxShadow: <BoxShadow>[
                                  BoxShadow(
                                      color: Colors.black12.withAlpha(100),
                                      offset: Offset(2, 4),
                                      blurRadius: 8,
                                      spreadRadius: 2)
                                ],
                                color: Color.fromRGBO(44, 149, 121, 1.0)),
                            child: Text(
                              'Login By Email',
                              style: TextStyle(fontSize: 20, color: Colors.white),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) => LoginPage(1)));
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.symmetric(vertical: 13),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(5)),
                                boxShadow: <BoxShadow>[
                                  BoxShadow(
                                      color: Colors.black12.withAlpha(100),
                                      offset: Offset(2, 4),
                                      blurRadius: 8,
                                      spreadRadius: 2)
                                ],
                                color: Color.fromRGBO(44, 149, 121, 1.0)),
                            child: Text(
                              'Login By Phone',
                              style: TextStyle(fontSize: 20, color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 20),
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'Don\'t have an account ?',
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) => SignUpPage()));
                          },
                          child: Text(
                            'Register',
                            style: TextStyle(
                                color: Color.fromRGBO(44, 149, 121, 1.0),
                                fontSize: 13,
                                fontWeight: FontWeight.w600),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}