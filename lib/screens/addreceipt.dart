import 'package:flutter/material.dart';
import 'package:expense_tracker_app/shared/constant.dart';
import 'package:expense_tracker_app/services/database.dart';
import 'package:expense_tracker_app/shared/loading.dart';
import 'package:expense_tracker_app/models/user.dart';
import 'package:provider/provider.dart';
import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'home/home.dart';

class AddReceipt extends StatefulWidget {
  @override
  _AddReceiptState createState() => _AddReceiptState();
}

class _AddReceiptState extends State<AddReceipt> {
  String FB_INTERSTITIAL_AD_ID =
      "IMG_16_9_APP_INSTALL#2312433698835503_2650502525028617";
  bool isInterstitialAdLoaded = false;

  final _formKey = GlobalKey<FormState>();
  final List<String> tags = ['Shopping', 'Movies', 'Food', 'Travel'];

  String _currentStoreName;
  String _currentTotal;
  String _currentDate;
  String _currentTags;

  @override
  void initState() {
    FacebookAudienceNetwork.init(
      testingId: "37b1da9d-b48c-4103-a393-2e095e734bd6", //optional
    );

    _loadInterstitialAd();

    super.initState();
  }

  void _loadInterstitialAd() {
    FacebookInterstitialAd.loadInterstitialAd(
        placementId: FB_INTERSTITIAL_AD_ID,
        listener: (result, value) {
          if (result == InterstitialAdResult.LOADED) {
            isInterstitialAdLoaded = true;
          }

          if (result == InterstitialAdResult.DISMISSED &&
              value["invalidated"] == true) {
            isInterstitialAdLoaded = false;
            _loadInterstitialAd();
          }
        });
  }

  _showInterstitialAd() {
    if (isInterstitialAdLoaded == true) {
      FacebookInterstitialAd.showInterstitialAd();
    } else {
      print("Ad not loaded yet");
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    return StreamBuilder<UserData2>(
        stream: DatabaseService(uid: user.uid).userData2,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            UserData2 userData2 = snapshot.data;

            return Scaffold(
              resizeToAvoidBottomInset: false,
              backgroundColor: Colors.purple[100],
              appBar: AppBar(
                backgroundColor: Colors.purple[500],
                elevation: 0.0,
                title: Text('Add Expense'),
              ),
              body: Builder(
                builder: (context) => Container(
                  padding:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 50.0),
                  child: Form(
                    key: _formKey,
                    child: SingleChildScrollView(
                      child: Column(children: <Widget>[
                        FlatButton.icon(
                          icon: Icon(Icons.shopping_bag),
                          label: Text('Store Name'),
                          onPressed: () {},
                        ),
                        TextFormField(
                          initialValue: userData2.storeName,
                          decoration: textInputDecoration.copyWith(
                              hintText: 'Store name'),
                          validator: (val) =>
                              val.isEmpty ? 'Please enter store name' : null,
                          onChanged: (val) =>
                              setState(() => _currentStoreName = val),
                        ),
                        FlatButton.icon(
                          icon: Icon(Icons.receipt),
                          label: Text('Expense total'),
                          onPressed: () {},
                        ),
                        TextFormField(
                          initialValue: userData2.total,
                          decoration: textInputDecoration.copyWith(
                              hintText: 'Expense total'),
                          validator: (val) =>
                              val.isEmpty ? 'Please enter expense total' : null,
                          onChanged: (val) =>
                              setState(() => _currentTotal = val),
                        ),
                        FlatButton.icon(
                          icon: Icon(Icons.calendar_today),
                          label: Text('Expense date'),
                          onPressed: () {},
                        ),
                        TextFormField(
                          initialValue: userData2.date,
                          decoration: textInputDecoration.copyWith(
                              hintText: 'Expense date'),
                          validator: (val) =>
                              val.isEmpty ? 'Please enter expense date' : null,
                          onChanged: (val) =>
                              setState(() => _currentDate = val),
                        ),
                        DropdownButtonFormField(
                          hint: Text('Select tags'),
                          value: _currentTags ?? userData2.tags,
                          items: tags.map((tag) {
                            return DropdownMenuItem(
                              value: tag,
                              child: Text('$tag '),
                            );
                          }).toList(),
                          onChanged: (val) =>
                              setState(() => _currentTags = val),
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              FlatButton(
                                color: Colors.blueAccent,
                                textColor: Colors.white,
                                child: Text('Save'),
                                onPressed: () async {
                                  _showInterstitialAd();
                                  if (_formKey.currentState.validate()) {
                                    await DatabaseService(uid: user.uid)
                                        .addUserData2(
                                            _currentStoreName ??
                                                userData2.storeName,
                                            _currentTotal ?? userData2.total,
                                            _currentDate ?? userData2.date,
                                            _currentTags ?? userData2.tags);
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => Home()));
                                  }
                                },
                              ),
                            ]),
                       
                      ]),
                    ),
                  ),
                ),
              ),
            );
          } else {
            return Loading();
          }
        });
  }
}
