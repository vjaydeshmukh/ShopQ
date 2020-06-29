import 'package:ShopQ/main.dart';
import 'package:ShopQ/screens/home_screen/home_screen_events.dart';
import 'package:ShopQ/screens/home_screen/home_screen_states.dart';
import 'package:ShopQ/screens/home_screen/shop.dart';
import 'package:ShopQ/screens/home_screen/shop_card.dart';
import 'package:ShopQ/screens/login_screen/login_handler.dart';
import 'package:ShopQ/screens/navigation_screen/navigation_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';

Firestore _firestore = Firestore.instance;

class HomeScreenBloc extends Bloc<HomeScreenEvents, HomeScreenStates> {
  String location;
  List<ShopCard> allShopsList;

  @override
  HomeScreenStates get initialState =>
      LoginHandler.location == '' ? ChooseLocation() : Loading();

  @override
  Stream<HomeScreenStates> mapEventToState(HomeScreenEvents event) async* {
    if (event is LocationChanged) {
      location = event.location;
    }
    if (event is SearchChanged) {
      var searchQuery = event.shopSearch;
      print(event.shopSearch);
      var shopsList = allShopsList
          .where((ShopCard element) => element.shop.shopName
              .toLowerCase()
              .contains(searchQuery.toLowerCase()))
          .toList();
      yield ShowSearch(shopsList);
    }
    if (event is SaveLocation) {
      LoginHandler.location = location;
      yield Loading();
      await _firestore
          .collection('users')
          .document(LoginHandler.phoneNumber)
          .updateData({
        'location': location,
      });
    }
    if (event is RemoveFromQueue) {
      showDialog(
        context: navigatorKey.currentState.overlay.context,
        builder: (context) => AlertDialog(
          title: Text(
            'remove',
            style: TextStyle(fontWeight: FontWeight.bold),
          ).tr(context: context),
          content: Text(
            'remove_warning',
          ).tr(context: context),
          actions: <Widget>[
            FlatButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                'cancel',
                style: TextStyle(fontWeight: FontWeight.bold),
              ).tr(context: context),
            ),
            FlatButton(
              onPressed: () async {
                showDialog(
                  context: navigatorKey.currentState.overlay.context,
                  builder: (context) => AlertDialog(
                    title: Text(
                      'loading',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ).tr(context: context),
                    content: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[CircularProgressIndicator()],
                    ),
                  ),
                );
                var brn = event.brn;
                var time = event.time;
                var result = await _firestore
                    .collection('shops')
                    .document(LoginHandler.location)
                    .collection('food_shops')
                    .document(brn)
                    .get();
                var data = result.data;
                var queue = data['queue'];
                queue[time].removeWhere((element) =>
                    element['phone_number'] == LoginHandler.phoneNumber);
                await _firestore
                    .collection('shops')
                    .document(LoginHandler.location)
                    .collection('food_shops')
                    .document(brn)
                    .updateData({'queue': queue});
                await _firestore
                    .collection('users')
                    .document(LoginHandler.phoneNumber)
                    .updateData({
                  'queue_brn': '',
                  'queue_time': '',
                  'queue_products': ''
                });
                navigatorKey.currentState.pushNamedAndRemoveUntil(NavigationScreen.id, (route) => false);
              },
              child: Text(
                'remove',
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
              ).tr(context: context),
            ),
          ],
        ),
      );
    }
    if (event is FetchShopsList) {
      var result = await _firestore
          .collection('users')
          .document(LoginHandler.phoneNumber)
          .get();
      var data = result.data;
      if (data['queue_brn'] == '') {
        List<ShopCard> shopsList = await getShopsList();
        shopsList.sort((a1, a2) {
          return a1.shop.shopName
              .toLowerCase()
              .compareTo(a2.shop.shopName.toLowerCase());
        });
        allShopsList = shopsList;
        yield ShowSearch(shopsList);
      } else {
        var shop_result = await _firestore
            .collection('shops')
            .document(LoginHandler.location)
            .collection('food_shops')
            .document(data['queue_brn'])
            .get();
        var shop_data = shop_result.data;
        yield ShowQr(
            data['queue_brn'],
            data['queue_products'],
            data['queue_time'],
            shop_data['shop_name'],
            shop_data['shop_address']);
      }
    }
  }

  Future<List> getShopsList() async {
    List<ShopCard> shopsList = [];
    var location = LoginHandler.location;
    var result = await _firestore
        .collection('shops')
        .document(location)
        .collection('food_shops')
        .getDocuments();
    for (var element in result.documents) {
      shopsList.add(
        ShopCard(
          Shop(
            shopAddress: element.data['shop_address'],
            shopName: element.data['shop_name'],
            openFrom: element.data['open_from'],
            openUntil: element.data['open_until'],
            brn: element.documentID,
          ),
        ),
      );
    }
    return shopsList;
  }
}
