import 'package:flutter/cupertino.dart';

class Shop {
  final String shopName, shopAddress, openFrom, openUntil, brn;

  Shop(
      {@required this.shopAddress,
      @required this.shopName,
      @required this.openFrom,
      @required this.openUntil,
      @required this.brn});
}
