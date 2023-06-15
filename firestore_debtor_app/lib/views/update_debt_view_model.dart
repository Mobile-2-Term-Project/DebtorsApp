import 'package:debtors/models/debt_model.dart';
import 'package:debtors/services/calculator.dart';
import 'package:debtors/services/database.dart';
import 'package:flutter/material.dart';

class UpdateDebtViewModel extends ChangeNotifier {
  final Database _database = Database();
  String collectionPath = 'debts';

  Future<void> updateDebt(
      {required String debtorName,
      required String creditAmount,
      required DateTime tradeDate,
      required Debt debt}) async {
    /// Form alanındaki verileri ile önce bir debt objesi oluşturulması
    Debt newDebt = Debt(
        id: debt.id,
        debtorName: debtorName,
        creditAmount: creditAmount,
        tradeDate: Calculator.datetimeToTimestamp(tradeDate));

    /// Borc bilgisini database servisi üzerinden Firestore'a yazacak
    await _database.setDebtData(
        collectionPath: collectionPath, debtAsMap: newDebt.toMap());
  }
}
