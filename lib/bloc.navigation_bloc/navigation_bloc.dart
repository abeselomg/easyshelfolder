import 'package:bloc/bloc.dart';
import 'package:easy_shelf/views/AutherPage.dart';
import 'package:easy_shelf/views/BookList.dart';
import 'package:easy_shelf/views/LatestList.dart';
import 'package:easy_shelf/views/MagazineList.dart';
import 'package:easy_shelf/views/MainApp.dart';
import 'package:easy_shelf/views/NewsPapersList.dart';

enum NavigationEvents {
  HomePageClickedEvent,
  LatestPageClickedEvent,
  AuthorPageClickedEvent,
  MagazineListClickEvent,
  BooksListClickEvent,
  NewspapersListClickEvent,
}

abstract class NavigationStates {}

class NavigationBloc extends Bloc<NavigationEvents, NavigationStates> {
  NavigationBloc(NavigationStates initialState) : super(initialState);

  NavigationStates get initialState  => MainAppPage(page: 0);

  @override
  Stream<NavigationStates> mapEventToState(NavigationEvents event) async* {
    switch (event) {
      case NavigationEvents.HomePageClickedEvent:
        yield MainAppPage(page: 0);
        break;
      case NavigationEvents.LatestPageClickedEvent:
        yield LatestList();
        break;
      case NavigationEvents.AuthorPageClickedEvent:
        yield AuthorProfile();
        break;
      case NavigationEvents.MagazineListClickEvent:
        yield MagazineList();
        break;
      case NavigationEvents.BooksListClickEvent:
        yield BookList();
        break;
      case NavigationEvents.NewspapersListClickEvent:
        yield NewsPaperList();
        break;
    }
  }
}
