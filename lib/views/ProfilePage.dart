import 'dart:convert';
import 'package:easy_shelf/helpers/UserData.dart';
import 'package:easy_shelf/helpers/sharedPref.dart';
import 'package:easy_shelf/profile/profilescreen.dart';
import 'package:easy_shelf/views/Authentication.dart';
import 'package:easy_shelf/views/first.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


// Define a custom Form widget.
class ProfilePage extends StatefulWidget {
  @override
  _ProfilePage createState() => _ProfilePage();
}

class _ProfilePage extends State<ProfilePage> {
  SharedPref sharedPref = SharedPref();
  UserData userData;
  bool logged;
  loadSharedPrefs() async {
    try {
      UserData user = UserData.fromJson(await sharedPref.read("user"));
      Scaffold.of(context).showSnackBar(SnackBar(
          content: new Text("Loaded!"),
          duration: const Duration(milliseconds: 500)));
      setState(() {
        userData = user;
      });
    } catch (Excepetion) {
      Scaffold.of(context).showSnackBar(SnackBar(
          content: new Text("Nothing found!"),
          duration: const Duration(milliseconds: 500)));
    }
  }

  checkIfAuthenticated() async {  // could be a long running task, like a fetch from keychain
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLogged = prefs.getBool('isLoggedIn') ?? false;
    return isLogged;
  }

  @override
  void initState(){
    sharedPref.read("user").then((value) {
      var valueRead;
      if(value != null)
        valueRead = jsonDecode(value);
      setState(() {
        if(value != null)
          userData = UserData.fromJson(valueRead);
      });
    });
    checkIfAuthenticated().then((success) {
      setState(() {
        logged = success;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if(logged != null){



      if(logged){
        return Scaffold(
            body: Container(
              color: Theme.of(context).primaryColor,
              child: Center(
                child: Profile(user:UserData(1,
          "+251923805630",
          "abeselom@email.com",
          "251923805630",
          "+251",
          "Ethiopia",
          "this.password",
          null,
          null)),
              ),
            )
        );
      }else{
        return LoginPage(1);
      }




    }else{
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
  }
}