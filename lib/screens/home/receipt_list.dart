import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:expense_tracker_app/models/receipt.dart';
import 'package:expense_tracker_app/screens/home/receipt_tile.dart';

class ReceiptList extends StatefulWidget {
  @override
  _ReceiptListState createState() => _ReceiptListState();
}

class _ReceiptListState extends State<ReceiptList> {
  @override
  Widget build(BuildContext context) {
    final receipts = Provider.of<List<Receipt>>(context) ?? [];

    return ListView.builder(
      itemCount: receipts.length,
      itemBuilder: (context, index) {
        return ReceiptTile(receipt: receipts[index]);
      },
    );
  }
}
