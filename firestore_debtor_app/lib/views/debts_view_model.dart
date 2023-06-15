import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:debtors/models/debt_model.dart';
import 'package:debtors/services/database.dart';
import 'package:flutter/material.dart';

class DebtsViewModel extends ChangeNotifier {

  final String _collectionPath = 'debts';

  final Database _database = Database();

  Stream<List<Debt>> getDebtList() {
    /// stream<QuerySnapshot> --> Stream<List<DocumentSnapshot>>
    Stream<List<DocumentSnapshot>> streamListDocument = _database
        .getDebtListFromApi(_collectionPath)
        .map((querySnapshot) => querySnapshot.docs);

    ///Stream<List<DocumentSnapshot>> --> Stream<List<Debt>>
    Stream<List<Debt>> streamListDebt = streamListDocument.map(
            (listOfDocSnap) => listOfDocSnap
            .map((docSnap) => Debt.fromMap(docSnap.data() as Map<String, dynamic>))
            .toList());

    return streamListDebt;
  }

  Future<void> deleteDebt(Debt debt) async {
    await _database.deleteDocument(referencePath: _collectionPath, id: debt.id);
  }
}