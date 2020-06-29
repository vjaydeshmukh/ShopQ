import 'package:ShopQ/screens/login_screen/login_handler.dart';
import 'package:ShopQ/screens/shop_home_screen/shop_home_screen_events.dart';
import 'package:ShopQ/screens/shop_home_screen/shop_home_screen_states.dart';
import 'package:ShopQ/screens/shop_home_screen/shop_order.dart';
import 'package:ShopQ/screens/shop_home_screen/shop_order_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Firestore _firestore = Firestore.instance;

class ShopHomeScreenBloc
    extends Bloc<ShopHomeScreenEvents, ShopHomeScreenStates> {
  @override
  ShopHomeScreenStates get initialState => Loading();

  @override
  Stream<ShopHomeScreenStates> mapEventToState(
      ShopHomeScreenEvents event) async* {
    if (event is FetchShopOrders) {
      List<ShopOrderCard> shopOrders = [];
      shopOrders = await _getOrders();
      yield ShowOrders(shopOrders);
    }
  }

  Future<List<ShopOrderCard>> _getOrders() async {
    List<ShopOrderCard> orders = [];
    var result = await _firestore
        .collection('shops')
        .document(LoginHandler.location)
        .collection('food_shops')
        .document(LoginHandler.brn)
        .get();
    var data = result.data;
    var queue = data['queue'];
    queue.forEach((key, value) {
      for (var element in queue[key]) {
        orders.add(
          ShopOrderCard(
            ShopOrder(element['phone_number'], key, element['products_list']),
          ),
        );
      }
    });
    return orders;
  }
}
