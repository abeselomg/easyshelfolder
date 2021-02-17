import 'dart:async';
import 'dart:convert';
import 'package:easy_shelf/helpers/UserData.dart';
import 'package:easy_shelf/helpers/sharedPref.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart' as bl;
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../bloc.navigation_bloc/navigation_bloc.dart';
import 'package:easy_shelf/helpers/ThemeManager.dart';
import 'menu_item.dart';

class SideBar extends StatefulWidget {
  final ThemeNotifier theme;

  SideBar(this.theme);
  @override
  _SideBarState createState() => _SideBarState();
}
final List<Entry> data = <Entry>[
  Entry(
    'Publications',Icons.padding,
    <Entry>[
      Entry('Newspaper',null,),
      Entry('Magazine',null),
      Entry('Books',null),
    ],
  ),
];
class _SideBarState extends State<SideBar> with SingleTickerProviderStateMixin<SideBar> {
  SharedPref sharedPref = SharedPref();
  UserData userData;
  bool logged;
  bool isSwitched = false;
  AnimationController _animationController;
  StreamController<bool> isSidebarOpenedStreamController;
  var isSidebarOpenedStream;
  StreamSink<bool> isSidebarOpenedSink;
  final _animationDuration = const Duration(milliseconds: 500);
  checkIfAuthenticated() async {  // could be a long running task, like a fetch from keychain
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLogged = prefs.getBool('isLoggedIn') ?? false;
    return isLogged;
  }
  @override
  void initState() {
    sharedPref.read("user").then((value) {
      var valueRead;
      if(value != null)
        valueRead = jsonDecode(value);
      setState(() {
        if(value != null)
          userData = UserData.fromJson(valueRead);
      });
    });
    sharedPref.readStr("key").then((value)  {
      if(value != null){
        if (value == 'light') {
          isSwitched = false;
        } else {
          isSwitched = true;
        }
      }
    });
    checkIfAuthenticated().then((success) {
      setState(() {
        logged = success;
      });
    });
    super.initState();
    _animationController = AnimationController(vsync: this, duration: _animationDuration);
    isSidebarOpenedStreamController = PublishSubject<bool>();
    isSidebarOpenedStream = isSidebarOpenedStreamController.stream;
    isSidebarOpenedSink = isSidebarOpenedStreamController.sink;
  }

  @override
  void dispose() {
    _animationController.dispose();
    isSidebarOpenedStreamController.close();
    isSidebarOpenedSink.close();
    super.dispose();
  }

  void onIconPressed() {
    final animationStatus = _animationController.status;
    final isAnimationCompleted = animationStatus == AnimationStatus.completed;

    if (isAnimationCompleted) {
      isSidebarOpenedSink.add(false);
      _animationController.reverse();
    } else {
      isSidebarOpenedSink.add(true);
      _animationController.forward();
    }
  }
  Widget _buildTiles(Entry root) {
    if (root.children.isEmpty) {
      return ListTile(
        onTap: () {
          onIconPressed();
          switch(root.title){
            case "Magazine":
              bl.BlocProvider.of<NavigationBloc>(context).add(NavigationEvents.MagazineListClickEvent);
              break;
            case "Books":
              bl.BlocProvider.of<NavigationBloc>(context).add(NavigationEvents.BooksListClickEvent);
              break;
            case "Newspaper":
              bl.BlocProvider.of<NavigationBloc>(context).add(NavigationEvents.NewspapersListClickEvent);
              break;
          }
        },
        title: Row(
          children: <Widget>[
            SizedBox(
              width: 50,
            ),
            Text(
              root.title,
              style: TextStyle(fontWeight: FontWeight.w300, fontSize: 18, color: Colors.white),
            )
          ],
        ),
      );
    }
    return ExpansionTile(
      key: PageStorageKey<Entry>(root),
      title: Row(
        children: <Widget>[
          Icon(
            root.icon,
            color: Colors.white,
            size: 20,
          ),
          SizedBox(
            width: 20,
          ),
          Text(
            root.title,
            style: TextStyle(fontWeight: FontWeight.w300, fontSize: 18, color: Colors.white),
          )
        ],
      ),
      children: root.children.map<Widget>(_buildTiles).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return StreamBuilder<bool>(
      initialData: false,
      stream: isSidebarOpenedStream,
      builder: (context, isSideBarOpenedAsync) {
        return SafeArea(
          child: Stack(
            children: <Widget>[
              AnimatedPositioned(
                duration: _animationDuration,
                top: 0,
                bottom: 0,
                left: isSideBarOpenedAsync.data ? 0 : - screenWidth * 0.63,
                right: isSideBarOpenedAsync.data ? 0 : screenWidth - 40,
                child: Row(
                  children: <Widget>[
                    SizedBox(
                      width: screenWidth * 0.65,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        color: Theme.of(context).primaryColor,
                        child: Column(
                          children: <Widget>[
                            SizedBox(
                              height: 20,
                            ),
                            logged != null ?
                            logged ?
                            ListTile(
                              title: Text(
                                "Prateek",
                                style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.w800),
                              ),
                              subtitle: Text(
                                "test@email.com",
                                style: TextStyle(
                                  color: Color(0xFF1BB5FD),
                                  fontSize: 14,
                                ),
                              ),
                              leading: CircleAvatar(
                                child: Icon(
                                  Icons.perm_identity,
                                  color: Colors.white,
                                ),
                                radius: 40,
                              ),
                            ) : ListTile(
                              title: Text(
                                "Guest",
                                style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.w800),
                              ),
                              subtitle: Text(
                                "Profile",
                                style: TextStyle(
                                  color: Color(0xFF1BB5FD),
                                  fontSize: 14,
                                ),
                              ),
                              leading: CircleAvatar(
                                child: Icon(
                                  Icons.perm_identity,
                                  color: Colors.white,
                                ),
                                radius: 40,
                              ),
                            )
                                : Center(child: CircularProgressIndicator(),),
                            Divider(
                              height: 24,
                              thickness: 0.5,
                              color: Colors.white,
                              indent: 32,
                              endIndent: 32,
                            ),
                            Expanded(
                              child: ListView(
                                children: <Widget>[
                                  MenuItem(
                                    icon: Icons.home,
                                    title: "Home",
                                    onTap: () {
                                      onIconPressed();
                                      bl.BlocProvider.of<NavigationBloc>(context).add(NavigationEvents.HomePageClickedEvent);
                                    },
                                  ),
                                  MenuItem(
                                    icon: Icons.book_outlined,
                                    title: "My shelf",
                                    onTap: () {
                                      onIconPressed();
                                      // bl.BlocProvider.of<NavigationBloc>(context).add(NavigationEvents.AuthorPageClickedEvent);
                                    },
                                  ),
                                  for(var da in data)
                                    ExpansionTile(
                                      key: PageStorageKey<Entry>(da),
                                      title: Row(
                                        children: <Widget>[
                                          Icon(
                                            da.icon,
                                            color: Colors.white,
                                            size: 20,
                                          ),
                                          SizedBox(
                                            width: 20,
                                          ),
                                          Text(
                                            da.title,
                                            style: TextStyle(fontWeight: FontWeight.w300, fontSize: 18, color: Colors.white),
                                          )
                                        ],
                                      ),
                                      children: da.children.map<Widget>(_buildTiles).toList(),
                                    ),
                                  MenuItem(
                                    icon: Icons.card_giftcard,
                                    title: "Wishlist",
                                  ),
                                  Divider(
                                    height: 64,
                                    thickness: 0.5,
                                    color: Colors.white,
                                    indent: 32,
                                    endIndent: 32,
                                  ),
                                  MenuItem(
                                    icon: Icons.settings,
                                    title: "Settings",
                                  ),
                                  MenuItem(
                                    icon: Icons.contact_phone,
                                    title: "Contact us",
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Row(
                                      children: <Widget>[
                                        Switch(
                                          value: isSwitched,
                                          onChanged: (value) {
                                            setState(() {
                                              isSwitched = value;
                                              if(value)
                                                widget.theme.setDarkMode();
                                              else
                                                widget.theme.setLightMode();
                                            });
                                          },
                                          activeTrackColor: Colors.lightGreenAccent,
                                          activeColor: Colors.green,
                                        ),
                                        SizedBox(
                                          width: 20,
                                        ),
                                        Text(
                                          "Dark mode",
                                          style: TextStyle(fontWeight: FontWeight.w300, fontSize: 18, color: Colors.white),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment(0,-1.0),
                      child: GestureDetector(
                        onTap: () {
                          onIconPressed();
                        },
                        child: ClipPath(
                          clipper: CustomMenuClipper(),
                          child: Container(
                            width: 28,
                            height: 87,
                            color: Theme.of(context).primaryColor,
                            alignment: Alignment.centerLeft,
                            child: AnimatedIcon(
                              progress: _animationController.view,
                              icon: AnimatedIcons.menu_close,
                              color: Colors.black,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class CustomMenuClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Paint paint = Paint();
    paint.color = Colors.white;

    final width = size.width;
    final height = size.height;

    Path path = Path();
    path.moveTo(0, 0);
    path.quadraticBezierTo(0, 8, 10, 16);
    path.quadraticBezierTo(width - 1, height / 2 - 20, width, height / 2);
    path.quadraticBezierTo(width + 1, height / 2 + 20, 10, height - 16);
    path.quadraticBezierTo(0, height - 8, 0, height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}


class Entry {
  final String title;
  final List<Entry>  children;
  final IconData icon; // Since this is an expansion list ...children can be another list of entries
  Entry(this.title, this.icon,[this.children = const <Entry>[]]);
}