import 'dart:ffi';

class User {

  final String uid;

  User({this.uid});
}


class UserData2 {

  final String uid;

  UserData2({ this.uid, storeName, total, date, tags});

  get storeName => 'Store Name';

  get total => 'Expense total';

  get date => 'Date';

  get tags => null;
  

}