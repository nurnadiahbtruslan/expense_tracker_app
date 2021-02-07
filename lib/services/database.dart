import 'package:expense_tracker_app/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker_app/models/receipt.dart';

class DatabaseService {
  final String uid;
  DatabaseService({this.uid});

  // collection reference

  final CollectionReference receiptCollection =
      Firestore.instance.collection('receipts');

  Future<void> updateUserData2(
      String storeName, String total, String date, String tags) async {
    return await receiptCollection.document(uid).setData({
      'storeName': storeName,
      'total': total,
      'date': date,
      'tags': tags,
    });
  }

  List<Receipt> _receiptListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return Receipt(
        storeName: doc.data['storeName'] ?? '',
        total: doc.data['total'] ?? '',
        date: doc.data['date'] ?? '',
        tags: doc.data['tags'] ?? '',
      );
    }).toList();
  }

  UserData2 _userData2FromSnapshot(DocumentSnapshot snapshot) {
    return UserData2(
      uid: uid,
      storeName: snapshot.data['storeName'],
      total: snapshot.data['total'],
      date: snapshot.data['date'],
      tags: snapshot.data['tags'],
    );
  }

  Future<void> addUserData2(
      String storeName, String total, String date, String tags) async {
    return await receiptCollection.add({
      'storeName': storeName,
      'total': total,
      'date': date,
      'tags': tags,
    });
  }

  Stream<List<Receipt>> get receipts {
    return receiptCollection.snapshots().map(_receiptListFromSnapshot);
  }

  Stream<UserData2> get userData2 {
    return receiptCollection
        .document(uid)
        .snapshots()
        .map(_userData2FromSnapshot);
  }
}
