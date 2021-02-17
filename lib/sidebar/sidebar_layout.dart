import 'package:easy_shelf/views/MainApp.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart' as bl;
import '../bloc.navigation_bloc/navigation_bloc.dart';
import 'sidebar.dart';
import 'package:easy_shelf/helpers/ThemeManager.dart';

enum NavigationEvents {
  HomePageClickedEvent,
}

class SideBarLayout extends StatelessWidget {
  final ThemeNotifier theme;

  SideBarLayout(this.theme);
  NavigationStates get initialState  => MainAppPage(page: 0,);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: bl.BlocProvider<NavigationBloc>(
        create: (context) => NavigationBloc(initialState),
        child: Stack(
          children: <Widget>[
            bl.BlocBuilder<NavigationBloc, NavigationStates>(
              builder: (context, navigationState) {
                return navigationState as Widget;
              },
            ),
            SideBar(this.theme)
          ],
        ),
      ),
    );
  }
}
