import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:debtors/models/debt_model.dart';

class Database {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Firestore servisinden Borcların verisini stream olarak alıp sağlamak

  Stream<QuerySnapshot> getDebtListFromApi(String referencePath) {
    return _firestore.collection(referencePath).snapshots();
  }

  /// Firestore üzerindeki bir veriyi silme hizmeti
  Future<void> deleteDocument({String? referencePath, String? id}) async {
    await _firestore.collection(referencePath!).doc(id).delete();
  }

  /// firestore'a yeni veri ekleme ve güncelleme hizmeti
  Future<void> setDebtData(
      {String? collectionPath, required Map<String, dynamic> debtAsMap}) async {
    await _firestore
        .collection(collectionPath!)
        .doc(Debt.fromMap(debtAsMap).id)
        .set(debtAsMap);
  }
}