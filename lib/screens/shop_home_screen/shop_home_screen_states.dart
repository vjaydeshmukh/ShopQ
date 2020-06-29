import 'package:ShopQ/screens/shop_home_screen/shop_order_card.dart';
import 'package:equatable/equatable.dart';

class ShopHomeScreenStates extends Equatable{
  @override
  List<Object> get props => [];
}

class Loading extends ShopHomeScreenStates{}

class ShowOrders extends ShopHomeScreenStates{
  final List<ShopOrderCard> shopOrders;
  ShowOrders(this.shopOrders);
}