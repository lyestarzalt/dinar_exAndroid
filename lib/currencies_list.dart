import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'convert_currencies.dart';
import 'util.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class CurrenciesList extends StatefulWidget {
  const CurrenciesList({Key? key}) : super(key: key);

  @override
  State<CurrenciesList> createState() => _CurrenciesListState();
}

class _CurrenciesListState extends State<CurrenciesList> {
  var buy_price = 0.0.obs;
  var sellPrice = 0.0.obs;
  var currencyCode = "".obs;
  var isShow = false.obs;
  var selectedIndex = 0.obs;

  NumberFormat currency(code) {
    Locale locale = Localizations.localeOf(context);
    locale.countryCode;
    var format =
        NumberFormat.simpleCurrency(name: code.toString().toUpperCase());
    print("CURRENCY SYMBOL ${format.currencySymbol}"); // $
    print(
        "CURRENCY NAME ${codeToCountry[code.toString().toUpperCase()]}"); // USD
    return format;
  }

  //
  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder<QuerySnapshot>(
        // inside the <> you enter the type of your stream

        future: FirebaseFirestore.instance.collection('exchange-daily').get(),

        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            Map<String, dynamic> yesterayPrice =
                snapshot.data!.docs[snapshot.data!.docs.length - 2].data()
                    as Map<String, dynamic>;

            Map<String, dynamic> todayPrices =
                snapshot.data!.docs.last.data() as Map<String, dynamic>;
            Map<String, dynamic> yesterayPriceBuyMap = yesterayPrice['anis'][1];

            Map<String, dynamic> todayBuyPricesMap = todayPrices['anis'][1];
            Map<String, dynamic> todaySellPricesMap = todayPrices['anis'][0];

            int itemCount = todayBuyPricesMap.length;
/*             for (var anis in todayBuyPricesMap.keys) {
              currency(anis);
            } */
            var format = NumberFormat.currency(name: 'DZD');
            return Stack(children: [
              ListView.builder(
                itemCount: itemCount,
                itemBuilder: (context, index) {
                  // get the code for each counrty to set the image icon
                  var iconItem = "".obs;
                  var currencyCodeItem = "".obs;
                  var countryName = "".obs;
                  var yesterdayBuyPriceItem = 0.0.obs;
                  var buyPriceItem = 0.0.obs;
                  var sellPriceItem = 0.0.obs;
                  var percent = 0.0.obs;
                  iconItem.value = todayBuyPricesMap.keys.toList()[index];
                  //
                  countryName.value = codeToCountry[
                      todayBuyPricesMap.keys.toList()[index].toUpperCase()];
                  //
                  currencyCodeItem.value =
                      todayBuyPricesMap.keys.toList()[index].toUpperCase();
//
                  yesterdayBuyPriceItem.value =
                      yesterayPriceBuyMap.values.toList()[index].toDouble();

                  buyPriceItem.value =
                      todayBuyPricesMap.values.toList()[index].toDouble();

                  sellPriceItem.value =
                      todaySellPricesMap.values.toList()[index].toDouble();
                  percent.value = ((1 -
                          (yesterdayBuyPriceItem.value / buyPriceItem.value)) *
                      100);
                  //our main list
                  //Using a list of rows instead of Listile becuase we can have much more customizability
                  return Container(
                    height: 70,
                    child: Card(
                      child: GestureDetector(
                        onTap: () {
                          buy_price = buyPriceItem;
                          sellPrice = sellPriceItem;
                          currencyCode = currencyCodeItem;
                          isShow.value = true;
                        },
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(5, 0, 0, 000),
                              child: Image.asset(
                                'icons/currency/${iconItem.value}.png',
                                package: 'currency_icons',
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                currencyCodeItem.value,
                              ),
                            ),
                            const Spacer(),
                            Column(
                              children: [
                                Icon(percent.value > 0.0
                                    ? Icons.trending_up
                                    : percent.value == 0.0
                                        ? Icons.trending_flat
                                        : Icons.trending_down),
                                Text(
                                  percent.value.toStringAsFixed(1) + '%',
                                  style: TextStyle(
                                      color: percent.value >= 0.0
                                          ? Colors.green
                                          : Colors.red),
                                ),
                              ],
                            ),
                            const Spacer(),
                            Container(
                              width: 30,
                              child:
                                  Text(buyPriceItem.value.toStringAsFixed(0)),
                            ),
                            Text('DZD')
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
              Obx(
                () => Visibility(
                  visible: isShow.value,
                  child: Align(
                    alignment: Alignment.center,
                    child: Card(
                      elevation: 100,
                      child: Container(
                        height: 350,
                        width: 300,
                        color: const Color.fromARGB(83, 255, 7, 7),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton(
                                    onPressed: () {
                                      isShow.value = false;
                                    },
                                    icon: const Icon(
                                        Icons.one_x_mobiledata_rounded))
                              ],
                            ),
                            Convert(
                              buyPrice: buy_price.value,
                              sellPrice: sellPrice.value,
                              currency: currencyCode.value,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ]);
          }
          if (snapshot.hasError) {
            return const Text('Error');
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
