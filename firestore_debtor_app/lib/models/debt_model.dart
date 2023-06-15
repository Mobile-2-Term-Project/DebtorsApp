import 'package:cloud_firestore/cloud_firestore.dart';

class Debt {
  final String id;
  final String debtorName;
  final String creditAmount;
  final Timestamp tradeDate;

  Debt({required this.id, required this.debtorName, required this.creditAmount, required this.tradeDate});

  /// objeden map oluşturan

  Map<String, dynamic> toMap() => {
    'id': id,
    'debtorName': debtorName,
    'creditAmount': creditAmount,
    'tradeDate': tradeDate
  };

  /// mapTen obje oluşturan yapıcı

  factory Debt.fromMap(Map map) => Debt(
      id: map['id'],
      debtorName: map['debtorName'],
      creditAmount: map['creditAmount'],
      tradeDate: map['tradeDate']);
}