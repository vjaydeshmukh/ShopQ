import 'package:ShopQ/screens/home_screen/shop_card.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

class HomeScreenStates extends Equatable{
  @override
  List<Object> get props => [];
}

class ShowSearch extends HomeScreenStates{
  @override
  List<Object> get props => [shopsList];
  final List<ShopCard> shopsList;
  ShowSearch(this.shopsList);
}

class ShowQr extends HomeScreenStates{
  final String queue_brn, queue_products, queue_time, shop_name, shop_address;
  ShowQr(this.queue_brn, this.queue_products, this.queue_time, this.shop_name, this.shop_address);
}

class ChooseLocation extends HomeScreenStates{}

class Loading extends HomeScreenStates{}