import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:easy_shelf/bloc.navigation_bloc/navigation_bloc.dart';
import 'package:easy_shelf/views/AutherPage.dart';
import 'package:easy_shelf/views/Explore.dart';
import 'package:easy_shelf/views/ProfilePage.dart';
import 'package:easy_shelf/views/first.dart';
import 'package:easy_shelf/views/home.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainAppPage extends StatefulWidget with NavigationStates {
  final int page;

  MainAppPage({@required this.page});
  @override
  _MainAppPageState createState() => _MainAppPageState(page: this.page);
}

class _MainAppPageState extends State<MainAppPage> {
  final int page;
  _MainAppPageState({@required this.page});
  int logged;
  final MyHomePage homePage = MyHomePage();
  final ExplorePage explorePage = ExplorePage();
  final ProfilePage profilePage = ProfilePage();
  final FirstPage firstPage = FirstPage();

  Widget _showPage;
  GlobalKey _bottomNavigationKey = GlobalKey();

  checkIfAuthenticated() async {
    // could be a long running task, like a fetch from keychain
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLogged = prefs.getBool('isLoggedIn') ?? false;
    return isLogged;
  }

  Widget _selectPage(int page) {
    switch (page) {
      case 0:
        return homePage;
        break;
      case 1:
        return explorePage;
        break;
      case 2:
        return profilePage;
        break;
      default:
        return homePage;
    }
  }

  @override
  void initState() {
    switch (page) {
      case 0:
        _showPage = MyHomePage();
        break;
      case 1:
        _showPage = AuthorProfile();
        break;
      case 2:
        _showPage = ProfilePage();
        break;
      default:
        _showPage = MyHomePage();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: _showPage != null ? _showPage : CircularProgressIndicator(),
        ),
      ),
      bottomNavigationBar: CurvedNavigationBar(
        key: _bottomNavigationKey,
        index: page,
        height: 50.0,
        items: <Widget>[
          Icon(
            Icons.home,
            size: 30,
            color: Colors.white,
          ),
          Icon(
            Icons.explore,
            size: 30,
            color: Colors.white,
          ),
          Icon(
            Icons.account_circle,
            size: 30,
            color: Colors.white,
          ),
        ],
        color: Color(0xFF1EB998),
        buttonBackgroundColor: Color(0xFF1EB998),
        backgroundColor: Color(0xFF1EB998),
        animationCurve: Curves.decelerate,
        animationDuration: Duration(milliseconds: 600),
        onTap: (tappedIndex) {
          setState(() {
            _showPage = _selectPage(tappedIndex);
          });
        },
      ),
    );
  }
}
