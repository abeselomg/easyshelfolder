import 'dart:io';
import 'package:easy_shelf/helpers/ThemeManager.dart';
import 'package:easy_shelf/helpers/UserData.dart';
import 'package:easy_shelf/profile/profileform.dart';
import 'package:easy_shelf/profile/profilescreen.dart';
import 'package:easy_shelf/sidebar/sidebar_layout.dart';
import 'package:custom_splash/custom_splash.dart';
import 'package:easy_shelf/views/Authentication.dart';
import 'package:easy_shelf/views/AutherPage.dart';
import 'package:easy_shelf/views/ProfilePage.dart';
import 'package:easy_shelf/views/home.dart';
import 'package:easy_shelf/views/login_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = new MyHttpOverrides();
  Map<int, Widget> op = {1: MyApp()};
  // SharedPref sharedPref = SharedPref();

  Function duringSplash = () {
    return 1;
  };
  runApp(MaterialApp(
    home: CustomSplash(
      imagePath: 'assets/images/shelf.png',
      home: MyApp(),
      customFunction: duringSplash,
      duration: 2500,
      logoSize: 200,
      backGroundColor: Colors.white,
      animationEffect: 'fade-in',
      type: CustomSplashType.BackgroundProcess,
      outputAndHome: op,
    ),
  ));
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyApp createState() => _MyApp();
}

class _MyApp extends State<MyApp> {
  void initState() {
    // Firebase.initializeApp();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'EasyShelfEt',
      initialRoute: "/",
      routes: {
        '/': (context) => MyAppPage(
              page: 0,
            ),
      },
      // navigatorKey: navigatorKey,
    );
  }
}

const MaterialColor white = const MaterialColor(
  0xFFFFFFFF,
  const <int, Color>{
    50: const Color(0xFFFFFFFF),
    100: const Color(0xFFFFFFFF),
    200: const Color(0xFFFFFFFF),
    300: const Color(0xFFFFFFFF),
    400: const Color(0xFFFFFFFF),
    500: const Color(0xFFFFFFFF),
    600: const Color(0xFFFFFFFF),
    700: const Color(0xFFFFFFFF),
    800: const Color(0xFFFFFFFF),
    900: const Color(0xFFFFFFFF),
  },
);

class MyAppPage extends StatefulWidget {
  final int page;

  MyAppPage({@required this.page});
  @override
  _MyHomePageState createState() => _MyHomePageState(page: this.page);
}

class _MyHomePageState extends State<MyAppPage> {
  final int page;
  _MyHomePageState({@required this.page});

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    PersistentTabController _controller;

    _controller = PersistentTabController(initialIndex: 0);

    List<Widget> _buildScreens() {
      return [
        MyHomePage(), AuthorProfile(),
        // AuthorProfile(),
        //  Profile(
        //       // activeBalance: value['active_balance'],
        //       // pendingBalance: value['pending_balance'],
        //       // balance: value['active_balance'],
        //       balance: '1565',
        //       user: UserData(
        //           1,
        //           "+251923805630",
        //           "abeselom@email.com",
        //           "251923805630",
        //           "+251",
        //           "Ethiopia",
        //           "this.password",
        //           null,
        //           null))
        LoginPageOtp()
        //  LoginPage(1)
        // ProfileFormPage()
      ];
    }

    List<PersistentBottomNavBarItem> _navBarsItems() {
      return [
        PersistentBottomNavBarItem(
          icon: Icon(CupertinoIcons.home),
          title: ("Home"),
          activeColor: Color(0xFF1EB998),
          inactiveColor: CupertinoColors.systemGrey,
        ),
        PersistentBottomNavBarItem(
          icon: Icon(CupertinoIcons.person),
          title: ("Settings"),
          activeColor: Color(0xFF1EB998),
          inactiveColor: CupertinoColors.systemGrey,
        ),
        PersistentBottomNavBarItem(
          icon: Icon(CupertinoIcons.person),
          title: ("Profile"),
          activeColor: Color(0xFF1EB998),
          inactiveColor: CupertinoColors.systemGrey,
        ),
      ];
    }

    return PersistentTabView(
      context,
      controller: _controller,
      screens: _buildScreens(),
      items: _navBarsItems(),
      confineInSafeArea: true,
      backgroundColor: Colors.white,
      handleAndroidBackButtonPress: true,
      resizeToAvoidBottomInset:
          true, // This needs to be true if you want to move up the screen when keyboard appears.
      stateManagement: true,
      hideNavigationBarWhenKeyboardShows:
          true, // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument.
      decoration: NavBarDecoration(
        borderRadius: BorderRadius.circular(10.0),
        colorBehindNavBar: Colors.white,
      ),
      // popAllScreensOnTapOfSelectedTab: true,
      popActionScreens: PopActionScreensType.all,
      itemAnimationProperties: ItemAnimationProperties(
        // Navigation Bar's items animation properties.
        duration: Duration(milliseconds: 200),
        curve: Curves.ease,
      ),

      screenTransitionAnimation: ScreenTransitionAnimation(
        // Screen transition animation on change of selected tab.
        animateTabTransition: true,
        curve: Curves.ease,
        duration: Duration(milliseconds: 200),
      ),
      navBarStyle:
          NavBarStyle.style3, // Choose the nav bar style with this property.
    
       onWillPop: () async {
          await showDialog(
            context: context,
            useSafeArea: true,
            builder: (context) => Container(
              height: 50.0,
              width: 50.0,
              color: Colors.white,
              child: RaisedButton(
                child: Text("Close"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          );
          return false;
        },
    );

    // ChangeNotifierProvider<ThemeNotifier>(
    //     create: (_) => new ThemeNotifier(),
    //     child: Consumer<ThemeNotifier>(
    //       builder: (context, theme, _) =>
    //       MaterialApp(
    //         theme: theme.getTheme(),
    //         home:

    //         SideBarLayout(theme),
    //       )
    //   )
    // );
  }
}
