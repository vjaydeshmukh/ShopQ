import 'package:ShopQ/screens/home_screen/shop.dart';
import 'package:ShopQ/screens/shop_details_screen/shop_details_screen_bloc.dart';
import 'package:ShopQ/screens/shop_details_screen/shop_details_screen_events.dart';
import 'package:ShopQ/screens/shop_details_screen/shop_details_screen_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:horizontal_time_picker/horizontal_time_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class ShopDetailsScreen extends StatefulWidget {
  final Shop _shop;

  ShopDetailsScreen(this._shop);

  @override
  _ShopDetailsScreenState createState() => _ShopDetailsScreenState();
}

class _ShopDetailsScreenState extends State<ShopDetailsScreen> {
  ShopDetailsScreenBloc _shopDetailsScreenBloc;
  var productListFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        brightness: Brightness.light,
        backgroundColor: Colors.white,
        elevation: 0,
        title: Column(
          children: <Widget>[
            Text(
              widget._shop.shopName,
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
            ),
            Text(
              widget._shop.shopAddress,
              style: TextStyle(color: Colors.black54, fontSize: 14),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: BlocProvider<ShopDetailsScreenBloc>(
          create: (BuildContext context) => ShopDetailsScreenBloc(),
          child: BlocBuilder<ShopDetailsScreenBloc, ShopDetailsScreenStates>(
            builder: (BuildContext context, ShopDetailsScreenStates state) {
              _shopDetailsScreenBloc =
                  BlocProvider.of<ShopDetailsScreenBloc>(context);
              if (state is ShowDetails)
                return _showDetailsBuilder();
              else
                return Container();
            },
          ),
        ),
      ),
    );
  }

  Widget _showDetailsBuilder() {
    var hourNow = DateTime.now().hour;
    bool isOpen = true, canOrder = true;
    if (!(hourNow <= double.parse(widget._shop.openUntil) &&
        hourNow >= double.parse(widget._shop.openFrom))) isOpen = false;
    if (isOpen && !(double.parse(widget._shop.openUntil) - hourNow > 1))
      canOrder = false;
    var splittedString = tr('order_instructions').toString().split('\\n');
    var resultString = '';
    for (var element in splittedString) {
      resultString += '$element \n';
    }
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: ListView(
                children: <Widget>[
                  isOpen
                      ? canOrder
                          ? Form(
                              key: productListFormKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: <Widget>[
                                  Text(
                                    'choose_time',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ).tr(context: context),
                                  HorizontalTimePicker(
                                    key: UniqueKey(),
                                    startTimeInHour:
                                        double.parse(widget._shop.openFrom)
                                            .toInt(),
                                    endTimeInHour:
                                        double.parse(widget._shop.openUntil)
                                            .toInt(),
                                    dateForTime: DateTime.now(),
                                    selectedTimeTextStyle: TextStyle(
                                      color: Colors.white,
                                      fontFamily: "Helvetica Neue",
                                      fontWeight: FontWeight.w300,
                                      fontSize: 16,
                                      height: 1.0,
                                    ),
                                    timeTextStyle: TextStyle(
                                      color: Colors.black,
                                      fontFamily: "Helvetica Neue",
                                      fontWeight: FontWeight.w300,
                                      fontSize: 16,
                                      height: 1.0,
                                    ),
                                    defaultDecoration: const BoxDecoration(
                                      color: Colors.white,
                                      border: Border.fromBorderSide(BorderSide(
                                        color:
                                            Color.fromARGB(255, 151, 151, 151),
                                        width: 1,
                                        style: BorderStyle.solid,
                                      )),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(5)),
                                    ),
                                    selectedDecoration: const BoxDecoration(
                                      color: Colors.black,
                                      border: Border.fromBorderSide(BorderSide(
                                        color:
                                            Color.fromARGB(255, 151, 151, 151),
                                        width: 1,
                                        style: BorderStyle.solid,
                                      )),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(5)),
                                    ),
                                    disabledDecoration: const BoxDecoration(
                                      color: Colors.black26,
                                      border: Border.fromBorderSide(BorderSide(
                                        color:
                                            Color.fromARGB(255, 151, 151, 151),
                                        width: 1,
                                        style: BorderStyle.solid,
                                      )),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(5)),
                                    ),
                                    onTimeSelected: (DateTime time) {
                                      _shopDetailsScreenBloc
                                          .add(TimeChosen(time));
                                    },
                                    showDisabled: false,
                                  ),
                                  Text(
                                    'write_products_list',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ).tr(context: context),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  TextFormField(
                                    validator: (value) {
                                      if (value.isEmpty)
                                        return tr('shouldnt_be_empty');
                                      return null;
                                    },
                                    maxLines: null,
                                    keyboardType: TextInputType.multiline,
                                    decoration: InputDecoration(
                                      hintText: tr('enter_your_products'),
                                    ),
                                    onChanged: (value) {
                                      _shopDetailsScreenBloc
                                          .add(ProductsListEdited(value));
                                    },
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    resultString,
                                    style: TextStyle(color: Colors.black54),
                                  ),
                                ],
                              ),
                            )
                          : Text(
                              'cant_order',
                              style: TextStyle(fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ).tr(context: context)
                      : Text(
                          'not_open',
                          style: TextStyle(fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ).tr(context: context),
                ],
              ),
            ),
            isOpen && canOrder
                ? GestureDetector(
                    onTap: () {
                      if (productListFormKey.currentState.validate()) {
                        _shopDetailsScreenBloc
                            .add(StandInQueue(widget._shop.brn));
                      }
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
                            Icon(MdiIcons.accountGroupOutline),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              'stand_in_queue',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ).tr(context: context),
                          ],
                        ),
                      ),
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
