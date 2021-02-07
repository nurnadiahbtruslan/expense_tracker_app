import 'package:expense_tracker_app/services/database.dart';
import 'package:expense_tracker_app/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracker_app/shared/constant.dart';
import 'package:expense_tracker_app/models/user.dart';
import 'package:provider/provider.dart';

class SettingsForm extends StatefulWidget {
  @override
  _SettingsFormState createState() => _SettingsFormState();
}

class _SettingsFormState extends State<SettingsForm> {
  final _formKey = GlobalKey<FormState>();
  final List<String> tags = ['Shopping', 'Movies', 'Food', 'Travel'];

  //form values
  String _currentStoreName;
  String _currentTotal;
  String _currentDate;
  String _currentTags;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    return StreamBuilder<UserData2>(
        stream: DatabaseService(uid: user.uid).userData2,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            UserData2 userData2 = snapshot.data;
            return Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  Text(
                    'Update your expense.',
                    style: TextStyle(fontSize: 18.0),
                  ),
                  SizedBox(height: 20.0),
                  TextFormField(
                    initialValue: userData2.storeName,
                    decoration: textInputDecoration,
                    validator: (val) =>
                        val.isEmpty ? 'Please enter store name' : null,
                    onChanged: (val) => setState(() => _currentStoreName = val),
                  ),
                  SizedBox(height: 20.0),
                  TextFormField(
                    initialValue: userData2.total,
                    decoration: textInputDecoration,
                    validator: (val) =>
                        val.isEmpty ? 'Please enter receipt total' : null,
                    onChanged: (val) => setState(() => _currentTotal = val),
                  ),
                  SizedBox(height: 20.0),
                  TextFormField(
                    initialValue: userData2.date,
                    decoration: textInputDecoration,
                    validator: (val) =>
                        val.isEmpty ? 'Please enter receipt date' : null,
                    onChanged: (val) => setState(() => _currentDate = val),
                  ),
                  SizedBox(height: 20.0),
                  //dropdown
                  DropdownButtonFormField(
                    decoration: textInputDecoration,
                    value: _currentTags ?? userData2.tags,
                    items: tags.map((tag) {
                      return DropdownMenuItem(
                        value: tag,
                        child: Text('$tag '),
                      );
                    }).toList(),
                    onChanged: (val) => setState(() => _currentTags = val),
                  ),

                  //slider
                  RaisedButton(
                      color: Colors.pink[400],
                      child: Text(
                        'Update',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () async {
                        if (_formKey.currentState.validate()) {
                          await DatabaseService(uid: user.uid).updateUserData2(
                            _currentStoreName ?? userData2.storeName,
                            _currentTotal ?? userData2.total,
                            _currentDate ?? userData2.date,
                            _currentTags ?? userData2.tags,
                          );
                          Navigator.pop(context);
                        }
                      }),
                ],
              ),
            );
          } else {
            return Loading();
          }
        });
  }
}
