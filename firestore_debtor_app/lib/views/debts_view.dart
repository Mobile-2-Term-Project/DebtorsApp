import 'package:debtors/models/debt_model.dart';
import 'package:debtors/services/calculator.dart';
import 'package:debtors/views/debts_view_model.dart';
import 'package:debtors/views/update_debt_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'add_debt_view.dart';
import 'package:intl/intl.dart';


class DebtsView extends StatefulWidget {
  const DebtsView({super.key});

  @override
  _DebtsViewState createState() => _DebtsViewState();
}

class _DebtsViewState extends State<DebtsView> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<DebtsViewModel>(
      create: (_) => DebtsViewModel(),
      builder: (context, child) => Scaffold(
        appBar: AppBar(title: const Text('Borçlu listesi'), centerTitle: true,),
        body: Center(
          child: Column(children: [
            StreamBuilder<List<Debt>>(
              stream: Provider.of<DebtsViewModel>(context, listen: false)
                  .getDebtList(),
              builder: (context, asyncSnapshot) {
                if (asyncSnapshot.hasError) {
                  print(asyncSnapshot.error);
                  return const Center(
                      child:
                      Text('Bir Hata Oluştu, daha sonra tekrar deneyiniz'));
                } else {
                  if (!asyncSnapshot.hasData) {
                    return const CircularProgressIndicator();
                  } else {
                    List<Debt>? DebtList = asyncSnapshot.data;
                    return BuildListView(DebtList: DebtList!);
                  }
                }
              },
            ),
            const Divider(),
          ]),
        ),
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const AddDebtView()));
            },
            child: const Icon(Icons.add)),
      ),
    );
  }
}

class BuildListView extends StatefulWidget {
  const BuildListView({
    Key? key,
    required this.DebtList,
  }) : super(key: key);

  final List<Debt> DebtList;

  @override
  _BuildListViewState createState() => _BuildListViewState();
}

class _BuildListViewState extends State<BuildListView> {
  bool isFiltering = false;
  late List<Debt> filteredList;

  @override
  Widget build(BuildContext context) {
    var fullList = widget.DebtList;
    return Flexible(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(6.0),
            child: TextField(
              decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  hintText: 'Arama: Borçlu adı',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6.0))),
              onChanged: (query) {
                if (query.isNotEmpty) {
                  isFiltering = true;

                  setState(() {
                    filteredList = fullList
                        .where((debt) => debt.debtorName
                        .toLowerCase()
                        .contains(query.toLowerCase()))
                        .toList();
                  });
                } else {
                  WidgetsBinding.instance.focusManager.primaryFocus!.unfocus();
                  setState(() {
                    isFiltering = false;
                  });
                }
              },
            ),
          ),
          Flexible(
            child: ListView.builder(
                itemCount: isFiltering ? filteredList.length : fullList.length,
                itemBuilder: (context, index) {
                  var list = isFiltering ? filteredList : fullList;
                  return Slidable(
                    child: Card(
                      child: ListTile(
                        title: Text(list[index].debtorName),
                        subtitle: Text(list[index].creditAmount),
                        trailing: Text(DateFormat("dd/MM/yyyy").format(Calculator.datetimeFromTimestamp(list[index].tradeDate))),
                      ),
                    ),
                    endActionPane: ActionPane(
                      motion: const ScrollMotion(),
                      children: [
                        SlidableAction(
                          label: 'Edit',
                          backgroundColor: Colors.white60,
                          icon: Icons.edit,
                          onPressed: (_) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => UpdateDebtView(
                                        debt: list[index])));
                          },
                        ),
                        SlidableAction(
                          label: 'Delete',
                          backgroundColor: Colors.red,
                          icon: Icons.delete,
                          onPressed: (_) async {
                            await Provider.of<DebtsViewModel>(context,
                                listen: false)
                                .deleteDebt(list[index]);

                          },
                        ),

                    ],
                    ),

                  );


                }),
          ),
        ],
      ),
    );
  }
}