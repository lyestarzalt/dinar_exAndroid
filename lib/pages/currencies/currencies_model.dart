import 'package:cloud_firestore/cloud_firestore.dart';

class CurrenciesModel {
  Map<String, dynamic>? todayPrices;
  Map<String, dynamic>? yesterayPrice;
  Map<String, dynamic>? todayBuyPricesMap;
  Map<String, dynamic>? todaySellPricesMap;
  String? todaydate;
  int? currenciescount;

  CurrenciesModel({
    this.todaydate,
    this.todayPrices,
    this.yesterayPrice,
    this.todayBuyPricesMap,
    this.todaySellPricesMap,
    this.currenciescount,
  });

  factory CurrenciesModel.fromDocumentSnapshot(var snapshot) {
    var todayPrices = snapshot.data!.docs.last.data() as Map<String, dynamic>;

    return CurrenciesModel(
      todaydate: snapshot.data!.docs.last.id,
      todayPrices: snapshot.data!.docs.last.data() as Map<String, dynamic>,
      yesterayPrice: snapshot.data!.docs[snapshot.data!.docs.length - 2].data()
          as Map<String, dynamic>,
      todayBuyPricesMap: todayPrices['anis'][1],
      todaySellPricesMap: todayPrices['anis'][0],
      currenciescount: todayPrices['anis'][1].length,
    );
  }
}
