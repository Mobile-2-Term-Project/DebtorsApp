import 'package:debtors/models/debt_model.dart';
import 'package:debtors/services/calculator.dart';
import 'package:debtors/views/update_debt_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UpdateDebtView extends StatefulWidget {
  final Debt debt;

  const UpdateDebtView({super.key, required this.debt});

  @override
  _UpdateDebtViewState createState() => _UpdateDebtViewState();
}

class _UpdateDebtViewState extends State<UpdateDebtView> {
  TextEditingController debtCtr = TextEditingController();
  TextEditingController authorCtr = TextEditingController();
  TextEditingController publishCtr = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  var _selectedDate;

  @override
  void dispose() {
    debtCtr.dispose();
    authorCtr.dispose();
    publishCtr.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debtCtr.text = widget.debt.debtorName;
    authorCtr.text = widget.debt.creditAmount;
    publishCtr.text = Calculator.dateTimeToString(
        Calculator.datetimeFromTimestamp(widget.debt.tradeDate));

    return ChangeNotifierProvider<UpdateDebtViewModel>(
      create: (_) => UpdateDebtViewModel(),
      builder: (context, _) => Scaffold(
        appBar: AppBar(title: const Text('Borç Bilgisi Güncelle')),
        body: Container(
          padding: const EdgeInsets.all(15),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                    controller: debtCtr,
                    decoration: const InputDecoration(
                        hintText: 'Borçlu Adı', icon: Icon(Icons.person)),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Borç Adı Boş Olamaz';
                      } else {
                        return null;
                      }
                    }),
                TextFormField(
                    controller: authorCtr,
                    decoration: const InputDecoration(
                        hintText: 'Yazar Adı', icon: Icon(Icons.attach_money_outlined)),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Borç miktarı boş bırakılamaz';
                      } else {
                        return null;
                      }
                    }),
                TextFormField(
                    onTap: () async {
                      _selectedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(-1000),
                          lastDate: DateTime.now());

                      publishCtr.text =
                          Calculator.dateTimeToString(_selectedDate);
                    },
                    controller: publishCtr,
                    decoration: const InputDecoration(
                        hintText: 'İşlem tarihi', icon: Icon(Icons.date_range)),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Lütfen Tarih Seçiniz';
                      } else {
                        return null;
                      }
                    }),
                const SizedBox(height: 20),
                ElevatedButton(
                  child: const Text('Güncelle'),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      /// kulanıcı bilgileri ile addNewDebt metodu çağırılacak,
                      await context.read<UpdateDebtViewModel>().updateDebt(
                          debtorName: debtCtr.text,
                          creditAmount: authorCtr.text,
                          tradeDate: _selectedDate ??
                              Calculator.datetimeFromTimestamp(
                                  widget.debt.tradeDate),
                          debt: widget.debt);

                      /// navigator.pop
                      Navigator.pop(context);
                    }
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}