import 'package:ShopQ/main.dart';
import 'package:ShopQ/screens/login_screen/login_handler.dart';
import 'package:ShopQ/screens/navigation_screen/navigation_screen.dart';
import 'package:ShopQ/screens/shop_details_screen/shop_details_screen_events.dart';
import 'package:ShopQ/screens/shop_details_screen/shop_details_screen_states.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';

Firestore _firestore = Firestore.instance;

class ShopDetailsScreenBloc
    extends Bloc<ShopDetailsScreenEvents, ShopDetailsScreenStates> {
  String chosenTime, productsList;

  @override
  ShopDetailsScreenStates get initialState => ShowDetails();

  @override
  Stream<ShopDetailsScreenStates> mapEventToState(
      ShopDetailsScreenEvents event) async* {
    if (event is TimeChosen) {
      int hour = event.chosenTime.hour;
      int minute = event.chosenTime.minute;
      chosenTime = '$hour:$minute';
    }
    if (event is ProductsListEdited) {
      productsList = event.productsList;
    }
    if (event is StandInQueue) {
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
      if (chosenTime != null) {
        var result = await _firestore
            .collection('shops')
            .document(LoginHandler.location)
            .collection('food_shops')
            .document(event.brn)
            .get();
        var data = result.data;
        var queue = data['queue'];
        int mapLength;
        if (queue == null) mapLength = 0;
        else mapLength = queue.length;
        if (mapLength < 10) {
          if (queue[chosenTime] == null) queue[chosenTime] = [];
          queue[chosenTime].add({
            'phone_number': LoginHandler.phoneNumber,
            'products_list': productsList,
          });
          await _firestore
              .collection('shops')
              .document(LoginHandler.location)
              .collection('food_shops')
              .document(event.brn)
              .updateData({
            'queue': queue,
          });
          await _firestore
              .collection('users')
              .document(LoginHandler.phoneNumber)
              .updateData({
            'queue_brn': event.brn,
            'queue_time': chosenTime,
            'queue_products': productsList,
          });
          Navigator.pop(navigatorKey.currentState.overlay.context);
          navigatorKey.currentState
              .pushNamedAndRemoveUntil(NavigationScreen.id, (route) => false);
        } else {
          Navigator.pop(navigatorKey.currentState.overlay.context);
          showDialog(
            context: navigatorKey.currentState.overlay.context,
            builder: (context) => AlertDialog(
              title: Text(
                'error',
                style: TextStyle(fontWeight: FontWeight.bold),
              ).tr(context: context),
              content: Text('no_free_space_error').tr(context: context),
            ),
          );
        }
      } else {
        Navigator.pop(navigatorKey.currentState.overlay.context);
        showDialog(
          context: navigatorKey.currentState.overlay.context,
          builder: (context) => AlertDialog(
            title: Text(
              'error',
              style: TextStyle(fontWeight: FontWeight.bold),
            ).tr(context: context),
            content: Text('choose_time_error').tr(context: context),
          ),
        );
      }
    }
  }
}
