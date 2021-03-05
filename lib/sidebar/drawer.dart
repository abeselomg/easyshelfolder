import 'package:flutter/material.dart';
// import 'package:newone/screens/Category.dart';
// import 'package:newone/screens/Login.dart';
// import 'package:newone/screens/SignUp.dart';
// import 'package:newone/main.dart';

class DrawerNavigation extends StatefulWidget {
  @override
  _DrawerNavigationState createState() => _DrawerNavigationState();
}

class _DrawerNavigationState extends State<DrawerNavigation> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Drawer(
        child: ListView(
          children: <Widget>[
            // UserAccountsDrawerHeader(
            //     currentAccountPicture: CircleAvatar(
            //       backgroundColor: Colors.amberAccent,
            //     ),
            //     accountName: Text("Abeselom"),
            //     accountEmail: Text("abeselom@email.com"),
            //     decoration: BoxDecoration(color: Colors.grey)),
                Container(
                  decoration: BoxDecoration(color: Colors.grey),
                  height: MediaQuery.of(context).size.height*0.25,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset("assets/images/shelf.png",fit: BoxFit.fitHeight,),
                  ),
                ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text("Home"),
              onTap: () => {
                // Navigator.of(context)
                //     .push(MaterialPageRoute(builder: (context) => MyHomePage()))
              },
            ),
            ListTile(
              leading: Icon(Icons.category),
              title: Text("Category"),
              onTap: () => {
                // Navigator.of(context).push(
                //     MaterialPageRoute(builder: (context) => CategoryPage()))
              },
            ),
            ListTile(
              leading: Icon(Icons.favorite_sharp),
              title: Text("Wishlist"),
              onTap: () => {
                // Navigator.of(context)
                //     .push(MaterialPageRoute(builder: (context) => LoginPage()))
              },
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text("Profile"),
              onTap: () => {
                // Navigator.of(context)
                //     .push(MaterialPageRoute(builder: (context) => SignUpPage()))
              },
            )
          ],
        ),
      ),
    );
  }
}
