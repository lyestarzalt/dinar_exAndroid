import 'package:cloud_firestore/cloud_firestore.dart';

class CurrenciesModel {
  Map<String, dynamic>? todayPrices;
  Map<String, dynamic>? yesterayPrice;
  Map<String, dynamic>? todayBuyPricesMap;
  Map<String, dynamic>? todaySellPricesMap;

  CurrenciesModel({
    this.todayPrices,
    this.yesterayPrice,
    this.todayBuyPricesMap,
    this.todaySellPricesMap,
  });

  factory CurrenciesModel.fromDocumentSnapshot(
      QuerySnapshot<Map<String, dynamic>> snapshot) {
    return CurrenciesModel(
      todayPrices: snapshot.docs.last.data(),
      yesterayPrice: snapshot.docs[snapshot.docs.length - 2].data(),
      todayBuyPricesMap:
          snapshot.docs.last.data()['anis'][1] as Map<String, dynamic>,
      todaySellPricesMap:
          snapshot.docs.last.data()['anis'][0] as Map<String, dynamic>,
    );
  }
}
