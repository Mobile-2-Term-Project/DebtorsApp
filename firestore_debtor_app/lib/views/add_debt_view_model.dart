import 'package:debtors/models/debt_model.dart';
import 'package:debtors/services/calculator.dart';
import 'package:debtors/services/database.dart';
import 'package:flutter/material.dart';

class AddDebtViewModel extends ChangeNotifier {
  final Database _database = Database();
  String collectionPath = 'debts';

  Future<void> addNewDebt(
      {required String debtorName, required String creditAmount, required DateTime tradeDate}) async {
    /// Form alanındaki verileri ile önce bir debt objesi oluşturulması
    Debt newDebt = Debt(
        id: DateTime.now().toIso8601String(),
        debtorName: debtorName,
        creditAmount: creditAmount,
        tradeDate: Calculator.datetimeToTimestamp(tradeDate));

    /// bu Borc bilgisini database servisi üzerinden Firestore'a yazacak
    await _database.setDebtData(
        collectionPath: collectionPath, debtAsMap: newDebt.toMap());
  }
}