import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:foodcarthotel/utils/messages/MessagesFunctions.dart';
import 'package:foodcarthotel/utils/screen_utils/flutter_screenutil.dart';

class AddNewItem extends StatefulWidget {
  @override
  _AddNewItemState createState() => _AddNewItemState();
}

class _AddNewItemState extends State<AddNewItem> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();
  TextEditingController _itemNameController = TextEditingController();
  TextEditingController _itemDescriptionController = TextEditingController();
  TextEditingController _itemPriceController = TextEditingController();
  TextEditingController _itemImageUrlController = TextEditingController();
  TextEditingController _itemTimeController = TextEditingController();
  final List<String> _dropdownValues = ["Select Item Type", "Tiffin", "Lunch", "Snacks", "Dinner"];
  String _currentlySelected = "Select Item Type";
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: 360, height: 760, allowFontScaling: true);

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Add New Item"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(10.w),
          child: Column(
            children: <Widget>[
              TextField(
                controller: _itemNameController,
                maxLines: 1,
                decoration: InputDecoration(labelText: "Item Name", hintText: "Enter Item Name"),
              ),
              TextField(
                controller: _itemDescriptionController,
                minLines: 2,
                maxLines: 3,
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                    labelText: "Item Description", hintText: "Enter item description"),
              ),
              TextField(
                controller: _itemPriceController,
                maxLines: 1,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: "Item Price", hintText: "Enter item price"),
              ),
              TextField(
                controller: _itemImageUrlController,
                maxLines: 1,
                keyboardType: TextInputType.text,
                decoration:
                    InputDecoration(labelText: "Item Image Url", hintText: "Enter item image Url"),
              ),
              TextField(
                controller: _itemTimeController,
                maxLines: 1,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(labelText: "Time", hintText: "Enter Time"),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10.h),
                child: DropdownButton(
                  items: _dropdownValues.map((String dropDownItems) {
                    return DropdownMenuItem<String>(
                      value: dropDownItems,
                      child: Padding(
                        padding: EdgeInsets.only(top: 10.h, bottom: 10.h),
                        child: Text(
                          dropDownItems,
                          style: TextStyle(color: Theme.of(context).primaryColor),
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (String value) {
                    setState(() {
                      _currentlySelected = value;
                    });
                  },
                  isExpanded: true,
                  value: _currentlySelected,
                ),
              ),
              Visibility(
                  visible: isLoading,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                  )),
              SizedBox(
                height: 20,
              ),
              MaterialButton(
                  onPressed: () {
                    _validateItems();
                  },
                  child: Text(
                    "Add New Item",
                    style: TextStyle(color: Colors.white),
                  ),
                  color: Theme.of(context).accentColor)
            ],
          ),
        ),
      ),
    );
  }

  void _validateItems() {
    setState(() {
      isLoading=true;
    });
    if (_itemNameController.text.isEmpty) {
      _scaffoldKey.currentState.showSnackBar(ErrorMessages.showErrorMessage("Enter Item Name"));
    } else if (_itemDescriptionController.text.isEmpty) {
      _scaffoldKey.currentState
          .showSnackBar(ErrorMessages.showErrorMessage("Enter Item Description"));
    } else if (_itemPriceController.text.isEmpty) {
      _scaffoldKey.currentState.showSnackBar(ErrorMessages.showErrorMessage("Enter Item Price"));
    } else if (_itemImageUrlController.text.isEmpty) {
      _scaffoldKey.currentState.showSnackBar(ErrorMessages.showErrorMessage("Enter Item Image"));
    } else if (_itemTimeController.text.isEmpty) {
      _scaffoldKey.currentState.showSnackBar(ErrorMessages.showErrorMessage("Enter Item Time"));
    } else if (_currentlySelected == "Select Item Type") {
      _scaffoldKey.currentState.showSnackBar(ErrorMessages.showErrorMessage("Enter Item Type"));
    } else {
      Map<String, dynamic> data = Map();
      data["description"] = _itemDescriptionController.text;
      data["image"] = _itemImageUrlController.text;
      data["itemCount"] = 0;
      data["itemName"] = _itemNameController.text;
      data["price"] = int.parse(_itemPriceController.text);
      data["status"] = 1;
      data["time"] = _itemTimeController.text;
      data["id"] = DateTime.now().millisecondsSinceEpoch;

      switch (_currentlySelected) {
        case "Tiffin":
          data["type"] = "1";
          break;
        case "Lunch":
          data["type"] = "2";
          break;
        case "Snacks":
          data["type"] = "3";
          break;
        case "Dinner":
          data["type"] = "4";
          break;
      }

      Firestore.instance.collection("MenuItems").document().setData(data).then((onValue) {
        setState(() {
          isLoading = false;
        });
        Navigator.of(context).pop();
      }, onError: (_error) {
        setState(() {
          isLoading = false;
        });
        _scaffoldKey.currentState.showSnackBar(ErrorMessages.showErrorMessage(_error.toString()));
      });
    }
  }
}
