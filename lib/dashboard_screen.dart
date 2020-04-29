import 'package:flutter/material.dart';
import 'package:foodcarthotel/add_new_item.dart';
import 'package:foodcarthotel/dashboard_screens/completed.dart';
import 'package:foodcarthotel/dashboard_screens/in_progress.dart';
import 'package:foodcarthotel/dashboard_screens/orders_screen.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  String appBarTitle = "Ordered";
  int _currentIndex = 0;

  int get createdObject => _currentIndex;

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
      pageController.animateToPage(_currentIndex,
          duration: Duration(milliseconds: 300), curve: Cubic(1, 1, 1, 1));
      switch (index) {
        case 0:
          appBarTitle = "Ordered";
          break;
        case 1:
          appBarTitle = "In-Progress";
          break;
        case 2:
          appBarTitle = "Completed";
          break;
      }
    });
  }

  PageView pageView;
  PageController pageController;

  @override
  Widget build(BuildContext context) {
    pageController = new PageController();
    return Scaffold(
      appBar: AppBar(
              title: Text(appBarTitle),
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=>AddNewItem()));
                  },
                )
              ],
            ),
//      body: _children[_currentIndex],
      body: pageView = new PageView(
        physics: NeverScrollableScrollPhysics(),
        children: [Orders(), InProgress(), Completed()],
        controller: pageController,
      ),
      resizeToAvoidBottomPadding: false,
      bottomNavigationBar: new Theme(
        data: Theme.of(context).copyWith(
            canvasColor: Theme.of(context).primaryColor,
            primaryColor: Theme.of(context).primaryColor,
            textTheme:
                Theme.of(context).textTheme.copyWith(caption: new TextStyle(color: Colors.white))),
        // sets the inactive color of the `BottomNavigationBar`
        child: new BottomNavigationBar(
          showSelectedLabels: false,
          showUnselectedLabels: false,
          type: BottomNavigationBarType.fixed,
          onTap: onTabTapped,
          // new
          currentIndex: _currentIndex,
          items: [
            BottomNavigationBarItem(
              icon: new Icon(Icons.home),
              activeIcon: new Icon(
                Icons.home,
                color: Colors.black,
              ),
              title: new Text('Orders'),
            ),
            BottomNavigationBarItem(
              icon: new Icon(Icons.sync),
              activeIcon: new Icon(
                Icons.sync,
                color: Colors.black,
              ),
              title: new Text('In-Progress'),
            ),
            BottomNavigationBarItem(
              icon: new Icon(Icons.done_outline),
              activeIcon: new Icon(
                Icons.done_outline,
                color: Colors.black,
              ),
              title: new Text('Completed'),
            ),
          ],
        ),
      ),
    );
  }
}
