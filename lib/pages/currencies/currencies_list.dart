import 'package:dinar_ex/pages/currencies/currencies_controller.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'convert_currencies.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

class CurrenciesList extends GetView<CurrenciesController> {
  RxDouble buyPrice = 0.0.obs;
  RxDouble sellPrice = 0.0.obs;
  RxString currencyCode = "".obs;
  RxInt selectedIndex = 0.obs;

  //
  @override
  Widget build(BuildContext context) {
    final CurrenciesController _controller = Get.put(CurrenciesController());

    return FutureBuilder<QuerySnapshot>(
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

                currencyCodeItem.value =
                    todayBuyPricesMap.keys.toList()[index].toUpperCase();
//
                yesterdayBuyPriceItem.value =
                    yesterayPriceBuyMap.values.toList()[index].toDouble();

                buyPriceItem.value =
                    todayBuyPricesMap.values.toList()[index].toDouble();

                sellPriceItem.value =
                    todaySellPricesMap.values.toList()[index].toDouble();
                percent.value =
                    ((1 - (yesterdayBuyPriceItem.value / buyPriceItem.value)) *
                        100);
                //our main list
                //Using a list of rows instead of Listile becuase we can have much more customizability
                return Container(
                  height: 70,
                  child: Card(
                    child: GestureDetector(
                      onTap: () {
                        buyPrice = buyPriceItem;
                        sellPrice = sellPriceItem;
                        currencyCode = currencyCodeItem;
                        _controller.isShow.value = true;
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
                          SizedBox(
                            width: 30,
                            child: Text(buyPriceItem.value.toStringAsFixed(0)),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
            Obx(
              () => Visibility(
                visible: _controller.isShow.value,
                child: Align(
                  alignment: Alignment.center,
                  child: SizedBox(
                    height: 300,
                    width: 300,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                                onPressed: () {
                                  _controller.isShow.value = false;
                                  //reset the textfiled _controller in the conver
                                  //page
                                },
                                icon: const Icon(Icons.cancel)),
                          ],
                        ),
                        SizedBox(
                          height: 250,
                          width: 300,
                          child: Card(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              side: const BorderSide(
                                  color: Colors.white70, width: 1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Convert(
                              buyPrice: buyPrice.value,
                              sellPrice: sellPrice.value,
                              currency: currencyCode.value,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ]);
        }
        if (snapshot.hasError) {
          return const Text('Error');
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
