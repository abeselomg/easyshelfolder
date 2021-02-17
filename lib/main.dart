import 'dart:io';
import 'package:easy_shelf/helpers/ThemeManager.dart';
import 'package:easy_shelf/sidebar/sidebar_layout.dart';
import 'package:custom_splash/custom_splash.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
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
  runApp(
      MaterialApp(
        home: CustomSplash(
          imagePath: 'assets/logo.png',
          home: MyApp(),
          customFunction: duringSplash,
          duration: 2500,
          logoSize: 200,
          backGroundColor: Colors.white,
          animationEffect: 'fade-in',
          type: CustomSplashType.BackgroundProcess,
          outputAndHome: op,
        ),
      )
  );
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyApp createState() => _MyApp();
}

class _MyApp extends State<MyApp> {
  void initState(){
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
        '/' : (context) => MyAppPage(page: 0,),
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
  _MyHomePageState createState() => _MyHomePageState(page : this.page);
}

class _MyHomePageState extends State<MyAppPage> {
  final int page;
  _MyHomePageState({@required this.page});

  @override
  void initState(){
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ThemeNotifier>(
        create: (_) => new ThemeNotifier(),
        child: Consumer<ThemeNotifier>(
          builder: (context, theme, _) => MaterialApp(
            theme: theme.getTheme(),
            home: SideBarLayout(theme),
          )
      )
    );
  }
}