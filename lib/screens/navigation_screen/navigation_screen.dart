import 'dart:ui';
import 'package:ShopQ/screens/home_screen/home_screen.dart';
import 'package:ShopQ/screens/places_screen/places_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';

import 'navigation_screen_bloc.dart';
import 'navigation_screen_events.dart';
import 'navigation_screen_states.dart';

class NavigationScreen extends StatefulWidget {
  static final String id = 'navigation_screen';

  @override
  _NavigationScreenState createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  NavigationScreenBloc _navigationScreenBloc;

  @override
  void dispose() {
    _navigationScreenBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<NavigationScreenBloc>(
      create: (BuildContext context) => NavigationScreenBloc(),
      child: BlocBuilder<NavigationScreenBloc, NavigationScreenStates>(
        builder: (BuildContext context, NavigationScreenStates states) {
          _navigationScreenBloc =
              BlocProvider.of<NavigationScreenBloc>(context);
          var showPage;
          switch (_navigationScreenBloc.currentPageIndex) {
            case 0:
              showPage = HomeScreen();
              break;
              case 1:
                showPage = PlacesScreen();
                break;
          }
          return Scaffold(
            body: showPage,
            bottomNavigationBar: BottomNavigationBar(
              backgroundColor: Colors.white,
              currentIndex: _navigationScreenBloc.currentPageIndex,
              items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  title: Text('home').tr(context: context),
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.place),
                  title: Text('places').tr(context: context),
                ),
              ],
              onTap: (index) {
                _navigationScreenBloc.add(PageTapped(index: index));
              },
            ),
          );
        },
      ),
    );
  }
}
