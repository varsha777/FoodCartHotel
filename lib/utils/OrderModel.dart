class OrderModel {
  String documentId;
  String orderBy;
  String Name;
  String status;
  int orderNo;
  int totalPrice;
  int totalQty;
  String orderId;
  String Phone;
  String Email;
  List<OrderItemsListListBean> orderItemsList;

  OrderModel(
      {this.orderBy,
        this.Name,
        this.status,
        this.orderNo,
        this.totalPrice,
        this.totalQty,
        this.orderId,
        this.Phone,
        this.Email,
        this.orderItemsList});

  OrderModel.fromJson(Map<String, dynamic> json) {
    this.orderBy = json['orderBy'];
    this.Name = json['Name'];
    this.status = json['status'];
    this.orderNo = json['orderNo'];
    this.totalPrice = json['totalPrice'];
    this.totalQty = json['totalQty'];
    this.orderId = json['orderId'].toString();
    this.Phone = json['Phone'];
    this.Email = json['Email'];
    this.orderItemsList = (json['orderItemsList'] as List) != null
        ? (json['orderItemsList'] as List).map((i) => OrderItemsListListBean.fromJson(i)).toList()
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['orderBy'] = this.orderBy;
    data['Name'] = this.Name;
    data['status'] = this.status;
    data['orderNo'] = this.orderNo;
    data['totalPrice'] = this.totalPrice;
    data['totalQty'] = this.totalQty;
    data['orderId'] = this.orderId;
    data['Phone'] = this.Phone;
    data['Email'] = this.Email;
    data['orderItemsList'] =
    this.orderItemsList != null ? this.orderItemsList.map((i) => i.toJson()).toList() : null;
    return data;
  }
}

class OrderItemsListListBean {
  String itemName;
  int itemTotal;
  int quantity;
  int itemPrice;
  num itemId;

  OrderItemsListListBean(
      {this.itemName, this.itemTotal, this.quantity, this.itemPrice, this.itemId});

  OrderItemsListListBean.fromJson(Map<String, dynamic> json) {
    this.itemName = json['itemName'];
    this.itemTotal = json['itemTotal'];
    this.quantity = json['quantity'];
    this.itemPrice = json['itemPrice'];
    this.itemId = json['itemId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['itemName'] = this.itemName;
    data['itemTotal'] = this.itemTotal;
    data['quantity'] = this.quantity;
    data['itemPrice'] = this.itemPrice;
    data['itemId'] = this.itemId;
    return data;
  }
}
