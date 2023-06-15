import 'package:debtors/services/calculator.dart';
import 'package:debtors/views/add_debt_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddDebtView extends StatefulWidget {
  const AddDebtView({super.key});

  @override
  _AddDebtViewState createState() => _AddDebtViewState();
}

class _AddDebtViewState extends State<AddDebtView> {
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
    return ChangeNotifierProvider<AddDebtViewModel>(
      create: (_) => AddDebtViewModel(),
      builder: (context, _) => Scaffold(
        appBar: AppBar(title: const Text('Yeni Borçlu Ekle')),
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
                        return 'Borçlu adı boş olamaz';
                      } else {
                        return null;
                      }
                    }),
                TextFormField(
                    controller: authorCtr,
                    decoration: const InputDecoration(
                        hintText: 'Borç Miktarı', icon: Icon(Icons.attach_money_outlined)),
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
                        hintText: 'işlem tarihi', icon: Icon(Icons.date_range)),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Lütfen Tarih Seçiniz';
                      } else {
                        return null;
                      }
                    }),
                const SizedBox(height: 20),
                ElevatedButton(
                  child: const Text('Kaydet'),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      /// kulanıcı bilgileri ile addNewDebt metodu çağırılacak,
                      await context.read<AddDebtViewModel>().addNewDebt(
                          debtorName: debtCtr.text,
                          creditAmount: authorCtr.text,
                          tradeDate: _selectedDate);

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