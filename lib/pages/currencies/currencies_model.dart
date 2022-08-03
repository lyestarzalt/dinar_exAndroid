import 'package:cloud_firestore/cloud_firestore.dart';

class CurrenciesModel {
  Map<String, dynamic>? todayPrices;
  Map<String, dynamic>? yesterayPrice;
  Map<String, dynamic>? todayBuyPricesMap;
  Map<String, dynamic>? todaySellPricesMap;
  String? todaydate;
  int? currenciescount;
  List alldoc = [];
  List <String>currenciesCodes = [];

  CurrenciesModel(
      {required this.alldoc,
      required this.todaydate,
      required this.todayPrices,
      required this.yesterayPrice,
      required this.todayBuyPricesMap,
      required this.todaySellPricesMap,
      required this.currenciescount,
      required this.currenciesCodes});

  factory CurrenciesModel.fromDocumentSnapshot(var snapshot) {
    var todayPrices = snapshot.data!.docs.last.data() as Map<String, dynamic>;
    return CurrenciesModel(
      alldoc: snapshot.data!.docs,
      todaydate: snapshot.data!.docs.last.id,
      todayPrices: snapshot.data!.docs.last.data() as Map<String, dynamic>,
      yesterayPrice: snapshot.data!.docs[snapshot.data!.docs.length - 2].data()
          as Map<String, dynamic>,
      todayBuyPricesMap: todayPrices['anis'][1],
      todaySellPricesMap: todayPrices['anis'][0],
      currenciescount: todayPrices['anis'][1].length,
      currenciesCodes: todayPrices['anis'][1].keys.toList(),
    );
  }
}
