import 'package:ShopQ/screens/home_screen/shop.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../constants.dart';
import 'package:easy_localization/easy_localization.dart';
import 'shop_order.dart';

Firestore _firestore = Firestore.instance;

class ShopOrderCard extends StatelessWidget {
  final ShopOrder _shopOrder;

  ShopOrderCard(this._shopOrder);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.red,
            boxShadow: [
              BoxShadow(
                color: Colors.grey,
                offset: Offset(0.0, 1.0),
                blurRadius: 5.0,
              ),
            ]),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                          'name'
                      ),
                      Text(
                        'KZT',
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    _shopOrder.products,
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: GestureDetector(
                    onTap: () {
//                    navigatorKey.currentState.push(
//                      CupertinoPageRoute(
//                        builder: (context) => EditMenuScreen(
//                          _menuItem.name,
//                          _menuItem.description,
//                          _menuItem.price,
//                          _menuItem.image,
//                        ),
//                      ),
//                    );
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(20)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.done,
                            color: Colors.white,
                          ),
                          Text(
                            'accept',
                          ).tr(context: context),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () async {
                      await showDialog(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          title: Text(
                            'delete',
                          ).tr(context: context),
                          content: Text(
                            'are_sure_delete',
                          ).tr(context: context),
                          actions: <Widget>[
                            FlatButton(
                              child: Text(
                                'no',
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                            FlatButton(
                              child: Text(
                                'yes',
                              ),
                              onPressed: () async {
//                              Navigator.pop(context);
//                              showDialog(
//                                context: context,
//                                builder: (context) => AlertDialog(
//                                  title: Text(
//                                    'deleting',
//                                  ).tr(context: context),
//                                  content: Row(
//                                    mainAxisAlignment:
//                                    MainAxisAlignment.center,
//                                    children: <Widget>[
//                                      CircularProgressIndicator()
//                                    ],
//                                  ),
//                                ),
//                              );
//                              var result = await _firestore
//                                  .collection('places')
//                                  .document('kz')
//                                  .collection(LoginHandler.brnLocation)
//                                  .document(LoginHandler.brn)
//                                  .get();
//                              Map menu = result.data['menu'];
//                              menu.remove(_menuItem.name);
//                              await _firestore
//                                  .collection('places')
//                                  .document('kz')
//                                  .collection(LoginHandler.brnLocation)
//                                  .document(LoginHandler.brn)
//                                  .updateData({'menu': menu});
//                              Navigator.pop(navigatorKey
//                                  .currentState.overlay.context);
//                              navigatorKey.currentState.pushAndRemoveUntil(
//                                  MaterialPageRoute(
//                                      builder: (context) =>
//                                          NavigationScreen(2)),
//                                      (route) => false);
                              },
                            ),
                          ],
                        ),
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(20)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.delete,
                            color: Colors.white,
                          ),
                          Text(
                            'delete',
                          ).tr(context: context),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
