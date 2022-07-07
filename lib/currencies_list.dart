import 'package:dinar_ex/main.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dinar_ex/convert_currencies.dart';

class CurrenciesList extends StatefulWidget {
  const CurrenciesList({Key? key}) : super(key: key);

  @override
  State<CurrenciesList> createState() => _CurrenciesListState();
}

class _CurrenciesListState extends State<CurrenciesList> {
  late Future<Map<dynamic, dynamic>> fixtures;

  @override
  void initState() {
    fixtures = _getData();
    super.initState();
  }

  Future<Map<dynamic, dynamic>> _getData() async {
    return await fetchData();
  }

  Future<Map<dynamic, dynamic>> fetchData() async {
    var value = await FirebaseFirestore.instance
        .collection('exchange-daily')
        .limit(1)
        .get();
    return value.docs.first.data();
  }



  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: fixtures,
      builder: (BuildContext context,
          AsyncSnapshot<Map<dynamic, dynamic>> snapshot) {
        if (snapshot.hasError) {
          return Text("Something went wrong");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data = snapshot.data as Map<String, dynamic>;
          return ListView(children: [
            ListTile(
              leading: Image.asset('icons/currency/usd.png',
                  package: 'currency_icons'),
              title: Text('USD'),
              subtitle: Text('United States Dollar'),
            ),
            ListTile(
              leading: Image.asset('icons/currency/eur.png',
                  package: 'currency_icons'),
              title: Text('EURO'),
              subtitle: Text('Euro'),
              trailing: Text(data['eur_buy'].toString()),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Convert(sell_price: data['eur_sell'],buy_price: data['eur_buy'], currency: 'eur',)),
                );
              },
            )
          ]);
        } else {
          return Text("Loading");
        }
      },
    );
  }
}
