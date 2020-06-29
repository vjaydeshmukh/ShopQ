import 'package:ShopQ/screens/login_screen/login_handler.dart';
import 'package:ShopQ/screens/shop_home_screen/shop_home_screen_bloc.dart';
import 'package:ShopQ/screens/shop_home_screen/shop_home_screen_events.dart';
import 'package:ShopQ/screens/shop_home_screen/shop_home_screen_states.dart';
import 'package:ShopQ/screens/shop_home_screen/shop_order_card.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ShopHomeScreen extends StatefulWidget {
  @override
  _ShopHomeScreenState createState() => _ShopHomeScreenState();
}

class _ShopHomeScreenState extends State<ShopHomeScreen> {
  ShopHomeScreenBloc _shopHomeScreenBloc;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: Drawer(
        child: Container(
          padding: EdgeInsets.only(top: 50),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              GestureDetector(
                onTap: () {
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
      appBar: AppBar(
        brightness: Brightness.light,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          'order',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ).tr(context: context),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
        child: BlocProvider<ShopHomeScreenBloc>(
          create: (BuildContext context) => ShopHomeScreenBloc(),
          child: BlocBuilder<ShopHomeScreenBloc, ShopHomeScreenStates>(
            builder: (BuildContext context, ShopHomeScreenStates state) {
              _shopHomeScreenBloc =
                  BlocProvider.of<ShopHomeScreenBloc>(context);
              if (state is ShowOrders) _showOrdersBuilder(state.shopOrders);
              if (state is Loading) {
                _shopHomeScreenBloc.add(FetchShopOrders());
                return _loadingBuilder();
              } else
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

  Widget _showOrdersBuilder(List<ShopOrderCard> shopOrders) =>
    Container(
      child: Column(
        children: shopOrders,
      ),
    );
}
