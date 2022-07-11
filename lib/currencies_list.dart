import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'convert_currencies.dart';
import 'package:get/get.dart';

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
            Map<String, dynamic> yesterayPriceBuyMap = yesterayPrice['anis'][0];

            Map<String, dynamic> todayBuyPricesMap = todayPrices['anis'][0];
            Map<String, dynamic> todaySellPricesMap = todayPrices['anis'][1];

            int itemCount = todayBuyPricesMap.length;

            return Stack(children: [
              ListView.builder(
                itemCount: itemCount,
                itemBuilder: (context, index) {
                  // get the code for each counrty to set the image icon
                  var iconItem = "".obs;
                  var currencyCodeItem = "".obs;
                  var yesterdayBuyPriceItem = 0.0.obs;
                  var buyPriceItem = 0.0.obs;
                  var sellPriceItem = 0.0.obs;

                  iconItem.value = todayBuyPricesMap.keys.toList()[index];

                  currencyCodeItem.value =
                      todayBuyPricesMap.keys.toList()[index];
                  yesterdayBuyPriceItem.value =
                      yesterayPriceBuyMap.values.toList()[index].toDouble();

                  buyPriceItem.value =
                      todayBuyPricesMap.values.toList()[index].toDouble();

                  sellPriceItem.value =
                      todaySellPricesMap.values.toList()[index].toDouble();

                  //our main list
                  //Using a list of rows instead of Listile becuase we can have much more customizability
                  return GestureDetector(
                    onTap: () {
                      buy_price = buyPriceItem;
                      sellPrice = sellPriceItem;
                      currencyCode = currencyCodeItem;
                      isShow.value = true;
                    },
                    child: Row(
                      children: [
                        Image.asset(
                          'icons/currency/${iconItem.value}.png',
                          package: 'currency_icons',
                        ),
                        Text(
                          currencyCodeItem.toString(),
                        ),
                        Text(buyPriceItem.value.toString()),
                      ],
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
            return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
