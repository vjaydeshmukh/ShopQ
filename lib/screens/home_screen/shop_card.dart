import 'package:ShopQ/screens/home_screen/shop.dart';
import 'package:ShopQ/screens/shop_details_screen/shop_details_screen.dart';
import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class ShopCard extends StatelessWidget {
  final Shop shop;

  ShopCard(this.shop);

  int hourNow = DateTime.now().hour, minuteNow = DateTime.now().minute;
  int minutesBeforeClose;

  @override
  Widget build(BuildContext context) {
    bool isOpen = double.parse(shop.openFrom) < hourNow &&
        double.parse(shop.openUntil) > hourNow;
    if (isOpen && (double.parse(shop.openUntil) - hourNow) <= 1)
      minutesBeforeClose = 60 - minuteNow;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        margin: EdgeInsets.only(bottom: 5, top: 5),
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
        child: _OpenContainerWrapper(
          shop: shop,
          transitionType: ContainerTransitionType.fadeThrough,
          closedBuilder: (BuildContext _, VoidCallback openContainer) {
            return GestureDetector(
              onTap: openContainer,
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Text(
                        shop.shopName,
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        shop.shopAddress,
                        style: TextStyle(color: Colors.black54),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      isOpen
                          ? Row(
                              children: <Widget>[
                                Text(
                                  'open',
                                  style: TextStyle(color: Colors.green),
                                ).tr(context: context),
                                SizedBox(
                                  width: 10,
                                ),
                                minutesBeforeClose != null
                                    ? Text(
                                        'closes_in',
                                        style: TextStyle(color: Colors.black54),
                                      ).tr(
                                        context: context,
                                        args: [minutesBeforeClose.toString()])
                                    : Container(),
                              ],
                            )
                          : Text(
                              'closed',
                              style: TextStyle(color: Colors.red),
                            ).tr(context: context),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _OpenContainerWrapper extends StatelessWidget {
  const _OpenContainerWrapper({
    this.closedBuilder,
    this.transitionType,
    this.onClosed,
    this.shop,
  });

  final OpenContainerBuilder closedBuilder;
  final ContainerTransitionType transitionType;
  final ClosedCallback<bool> onClosed;
  final Shop shop;
  @override
  Widget build(BuildContext context) {
    return OpenContainer<bool>(
      closedElevation: 5,
      closedShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      transitionType: transitionType,
      openBuilder: (BuildContext context, VoidCallback _) {
        return ShopDetailsScreen(shop);
      },
      onClosed: onClosed,
      tappable: false,
      closedBuilder: closedBuilder,
    );
  }
}
