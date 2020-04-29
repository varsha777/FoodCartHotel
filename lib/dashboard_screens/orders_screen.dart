import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:foodcarthotel/utils/OrderModel.dart';
import 'package:foodcarthotel/utils/screen_utils/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';

class Orders extends StatefulWidget {
  @override
  _OrdersState createState() => _OrdersState();
}

class _OrdersState extends State<Orders> with AutomaticKeepAliveClientMixin<Orders> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();
  bool isApiLoading = false;
  List<OrderModel> _ordersList = List();

  @override
  void initState() {
    _loadInitialData();
    super.initState();
  }

  _loadInitialData() async {
    setState(() {
      isApiLoading = true;
    });
    Firestore.instance
        .collection("OrderHistory")
        .where("status", isEqualTo: "Ordered")
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      if (snapshot.documents.length > 0) {
        List<DocumentSnapshot> list = snapshot.documents;
        _ordersList.clear();
        for (int i = 0; i < list.length; i++) {
          DocumentSnapshot document = list[i];
          _ordersList.add(OrderModel.fromJson(document.data));
          _ordersList[i].documentId = document.documentID;
        }
        _ordersList.sort((a, b) {
          return b.orderNo.compareTo(a.orderNo);
        });
      }

      setState(() {
        isApiLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: 360, height: 760, allowFontScaling: true);

    return Scaffold(
      key: _scaffoldKey,
      body: isApiLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : _ordersList.length == 0
              ? Center(
                  child: Text("No new orders available"),
                )
              : ListView.builder(
                  itemCount: _ordersList.length,
                  itemBuilder: (context, index) {
                    return OrdersItemRow(
                      _ordersList[index],
                      onCallBack: () {
                        _loadInitialData();
                      },
                      callbackStatus: (String Status) {
                        _sendEmail(_ordersList[index], Status);
                      },
                    );
                  }),
    );
  }

  String username = 'Sathyalakshmiaryavysyafoodcorn@gmail.com';
  String password = '123456789@Rajesh';

  void _sendEmail(OrderModel orderModel, String status) async {
    final smtpServer = gmail(username, password);
    final message = Message()
      ..from = Address(username, 'Food Cart')
      ..recipients.add(orderModel.Email)
      ..subject = 'Order NO.#${orderModel.orderNo}'
      ..text = status == "InProgress"
          ? "Hi ${orderModel.Name},\n \t Your order is on $status soon your order will be delivered at your door step. Keep track you order in FOOD CART APP"
          : "Hi ${orderModel.Name},\n \t Thank for ordering from FOOD CART. Your order Delivered done. \n We are waiting for your next order from FOOD CART APP"
      ..html = status == "InProgress"
          ? "<h3>Hi ${orderModel.Name},</h3>\n \t <h4>Your order is on $status soon your order will be delivered at your door step. Keep track you order in FOOD CART APP.</h4>"
          : "<h3>Hi ${orderModel.Name},</h3>\n \t <h4>Thank for ordering from FOOD CART. Your order Delivered done. \n</h4>.<h2>\n We are waiting for your next order from FOOD CART APP</h2>";

    try {
      final sendReport = await send(message, smtpServer);
      print('Message sent: ' + sendReport.toString());
    } on MailerException catch (e) {
      print('Message not sent.');
      for (var p in e.problems) {
        print('Problem: ${p.code}: ${p.msg}');
      }
    }
  }

  @override
  bool get wantKeepAlive => true;
}

typedef changeValue = bool Function(String);

class OrdersItemRow extends StatelessWidget {
  OrderModel _orderModel;
  VoidCallback onCallBack;
  changeValue callbackStatus;

  OrdersItemRow(this._orderModel, {this.onCallBack, this.callbackStatus});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _showDialog(context, _orderModel.documentId, onCallBack: () {
          onCallBack();
        }, callbackStatus: (String status) {
          callbackStatus(status);
        });
      },
      child: Container(
        padding: EdgeInsets.all(10.w),
        margin: EdgeInsets.only(left: 10.w, top: 10.h, right: 10.w),
        decoration: BoxDecoration(
          border: Border.all(
            color: Theme.of(context).primaryColor,
          ),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Text(
                    "Order No. ${_orderModel.orderNo}",
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.normal, fontSize: 20.ssp),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    "\u20B9 ${_orderModel.totalPrice}",
                    textAlign: TextAlign.end,
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 20.ssp),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Row(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Text(_orderModel.Name),
                ),
                Expanded(
                  flex: 1,
                  child: Text(_orderModel.Phone),
                )
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List<Widget>.generate(_orderModel.orderItemsList.length, (int index) {
                if (index == _orderModel.orderItemsList.length - 1) {
                  return Padding(
                    padding: EdgeInsets.only(top: 5.h),
                    child: Text(
                        "${_orderModel.orderItemsList[index].itemName}(${_orderModel.orderItemsList[index].quantity}) -> \u20B9${_orderModel.orderItemsList[index].itemTotal}.",
                        textAlign: TextAlign.start),
                  );
                } else {
                  return Text(
                      "${_orderModel.orderItemsList[index].itemName}(${_orderModel.orderItemsList[index].quantity}) -> \u20B9${_orderModel.orderItemsList[index].itemTotal}, ",
                      textAlign: TextAlign.start);
                }
              }),
            ),
            SizedBox(
              height: 5,
            ),
            Row(
              children: <Widget>[
                Expanded(
                  flex: 3,
                  child: Text(
                    getTimeData(),
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 13.ssp),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    "Status: ${_orderModel.status}",
                    textAlign: TextAlign.end,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.ssp),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showDialog(context, String documentID,
      {VoidCallback onCallBack, changeValue callbackStatus}) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return alert dialog object
        return AlertDialog(
          title: new Text('Update Order Status'),
          content: Container(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    Firestore.instance
                        .collection("OrderHistory")
                        .document(documentID)
                        .updateData({"status": "InProgress"}).then((_onValue) {
                      onCallBack();
                      callbackStatus("InProgress");
                      Navigator.of(context).pop();
                    }, onError: (_error) {
                      Fluttertoast.showToast(
                          msg: "${_error.toString()}",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          fontSize: 16.0);
                    });
                  },
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.sync),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: new Text(' In-progress'),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Firestore.instance
                        .collection("OrderHistory")
                        .document(documentID)
                        .updateData({"status": "Completed"}).then((_onValue) {
                      callbackStatus("Completed");
                      onCallBack();
                      Navigator.of(context).pop();
                    }, onError: (_error) {
                      Fluttertoast.showToast(
                          msg: "${_error.toString()}",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          fontSize: 16.0);
                    });
                  },
                  child: Row(
                    children: <Widget>[
                      new Icon(Icons.done_outline),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: new Text('Completed'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String getTimeData() {
    var date = new DateTime.fromMillisecondsSinceEpoch(int.parse(_orderModel.orderId) * 1000);
    var format = new DateFormat('EEE, d MMM hh:mm aaa');
    return format.format(date);
  }
}
