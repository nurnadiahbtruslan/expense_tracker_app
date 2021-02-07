import 'package:expense_tracker_app/screens/home/homes.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracker_app/services/auth.dart';
import 'package:expense_tracker_app/screens/addreceipt.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final AuthService _auth = AuthService();
  int _currentIndex = 0;
  final List<Widget> _children = [
    Homes(),
    AddReceipt(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Expense Tracker'),
          backgroundColor: Colors.black,
          actions: <Widget>[
            FlatButton.icon(
              
              icon: Icon(Icons.person, color: Colors.white,),
              label: Text('logout'), textColor: Colors.white,
              onPressed: () async {
                await _auth.signOut();
              },
            ),
          ]),
      body: _children[_currentIndex], // new
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped, // new
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
            icon: new Icon(Icons.home),
            title: new Text('Home'),
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.money),
            title: new Text('Add Expense'),
          ),
        ],
      ),
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}
