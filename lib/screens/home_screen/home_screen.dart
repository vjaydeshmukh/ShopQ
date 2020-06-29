import 'package:ShopQ/constants.dart';
import 'package:ShopQ/screens/home_screen/home_screen_bloc.dart';
import 'package:ShopQ/screens/home_screen/home_screen_events.dart';
import 'package:ShopQ/screens/home_screen/shop_card.dart';
import 'package:ShopQ/screens/login_screen/login_handler.dart';
import 'package:floating_search_bar/floating_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';

import 'home_screen_states.dart';

class HomeScreen extends StatefulWidget {
  static final String id = 'home_screen';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  HomeScreenBloc _homeScreenBloc;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(0),
        child: AppBar(
          elevation: 0,
          brightness: Brightness.light,
        ),
      ),
      body: SafeArea(
        child: BlocProvider<HomeScreenBloc>(
          create: (BuildContext context) => HomeScreenBloc(),
          child: BlocBuilder<HomeScreenBloc, HomeScreenStates>(
            builder: (BuildContext context, HomeScreenStates state) {
              _homeScreenBloc = BlocProvider.of<HomeScreenBloc>(context);
              if (state is Loading) {
                _homeScreenBloc.add(FetchShopsList());
                return _loadingBuilder();
              }
              if (state is ShowQr)
                return _showQrBuilder(state.queue_brn, state.queue_products,
                    state.queue_time, state.shop_name, state.shop_address);
              if (state is ShowSearch)
                return _showSearchBuilder(state.shopsList);
              if (state is ChooseLocation)
                return _chooseLocationBuilder();
              else
                return Container();
            },
          ),
        ),
      ),
    );
  }

  Widget _loadingBuilder() => Center(
        child: CircularProgressIndicator(),
      );

  Widget _chooseLocationBuilder() {
    List<DropdownMenuItem> citiesDropdown = [];
    for (var element in Constants.cities) {
      citiesDropdown.add(
        DropdownMenuItem(
          child: Text(element).tr(context: context),
          value: element,
        ),
      );
    }
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            SearchableDropdown.single(
              items: citiesDropdown,
              onChanged: (value) {
                _homeScreenBloc.add(LocationChanged(value));
              },
              hint: tr('choose_your_location'),
              searchHint: tr('choose_your_location'),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
              child: GestureDetector(
                onTap: () {
                  _homeScreenBloc.add(SaveLocation());
                },
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey,
                          offset: Offset(0.0, 1.0),
                          blurRadius: 5.0,
                        ),
                      ]),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(MdiIcons.contentSave),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          'save',
                        ).tr(context: context),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _showSearchBuilder(List<ShopCard> shopsList) {
    return FloatingSearchBar(
      padding: EdgeInsets.all(10),
      drawer: Drawer(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              GestureDetector(
                onTap: (){
                  _homeScreenBloc.add(ChangeLocation());
                },
                child: Text(
                  'change_location',
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ).tr(context: context),
              ),
              GestureDetector(
                onTap: (){
                  LoginHandler().signOut();
                },
                child: Text(
                  'logout',
                  style: TextStyle(fontSize: 16, color: Colors.red),
                  textAlign: TextAlign.center,
                ).tr(context: context),
              ),
            ],
          ),
        ),
      ),
      onChanged: (String value) {
        _homeScreenBloc.add(SearchChanged(value));
      },
      decoration: InputDecoration.collapsed(hintText: tr('search_shops')),
      children: shopsList,
    );
  }

  Widget _showQrBuilder(String brn, String products, String time,
          String shopName, String shopAddress) =>
      Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            'qr_screen',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
          ).tr(context: context),
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black),
        ),
        drawer: Drawer(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  GestureDetector(
                    onTap: (){
                      _homeScreenBloc.add(ChangeLocation());
                    },
                    child: Text(
                      'change_location',
                      style: TextStyle(fontSize: 16),
                      textAlign: TextAlign.center,
                    ).tr(context: context),
                  ),
                  GestureDetector(
                    onTap: (){
                      LoginHandler().signOut();
                    },
                    child: Text(
                      'logout',
                      style: TextStyle(fontSize: 16, color: Colors.red),
                      textAlign: TextAlign.center,
                    ).tr(context: context),
                  ),
                ],
              ),
            ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Expanded(
                child: Center(
                  child: LayoutBuilder(
                    builder: (context, constraint) => QrImage(
                      data: '$brn,$products,$time,${LoginHandler.phoneNumber}',
                      version: QrVersions.auto,
                      size: constraint.biggest.width,
                    ),
                  ),
                ),
              ),
              Text(
                shopName,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                shopAddress,
                style: TextStyle(color: Colors.black54, fontSize: 16),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                time,
                style: TextStyle(color: Colors.black54, fontSize: 16),
                textAlign: TextAlign.center,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                child: GestureDetector(
                  onTap: () {
                    _homeScreenBloc.add(RemoveFromQueue(brn, time));
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.redAccent.shade200,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey,
                            offset: Offset(0.0, 1.0),
                            blurRadius: 5.0,
                          ),
                        ]),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            MdiIcons.qrcodeRemove,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            'remove_from_queue',
                            style: TextStyle(color: Colors.white),
                          ).tr(context: context),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
}
