import 'package:expense_tracker_app/models/receipt.dart';
import 'package:expense_tracker_app/screens/home/receipt_list.dart';
import 'package:expense_tracker_app/screens/home/settings_form.dart';
import 'package:expense_tracker_app/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:expense_tracker_app/services/database.dart';

class Homes extends StatelessWidget {
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    void _showSettingsPanel() {
      showModalBottomSheet(
          context: context,
          builder: (context) {
            return Container(
              padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 60.0),
              child: SettingsForm(),
            );
          });
    }

    return StreamProvider<List<Receipt>>.value(
      value: DatabaseService().receipts,
      child: Scaffold(
        backgroundColor: Colors.purple[100],
        appBar: AppBar(
          title: Text('Home'),
          backgroundColor: Colors.purple[500],
          elevation: 0.0,
          actions: <Widget>[
            FlatButton.icon(
              icon: Icon(Icons.settings),
              label: Text('settings'),
              onPressed: () => _showSettingsPanel(),
            )
          ],
        ),
        body: Container(child: ReceiptList()),
      ),
    );
  }
}
