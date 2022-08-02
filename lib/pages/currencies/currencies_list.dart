import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'convert_currencies.dart';
import 'package:get/get.dart';
import 'package:dinar_ex/pages/currencies/util.dart';
import 'package:dinar_ex/pages/currencies/currencies_model.dart';

class CurrenciesList extends StatefulWidget {
  //

  @override
  State<CurrenciesList> createState() => _CurrenciesListState();
}

class _CurrenciesListState extends State<CurrenciesList> {
  RxDouble buyPrice = 0.0.obs;
  RxDouble sellPrice = 0.0.obs;
  RxString currencyCode = "".obs;
  RxInt selectedIndex = 0.obs;
  RxBool isShow = false.obs;

  var collection =
      FirebaseFirestore.instance.collection('exchange-daily').snapshots();

  var collectionfinal;
  @override
  void initState() {
    var collectionfinal = collection;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        // inside the <> you enter the type of your stream

        stream:
            FirebaseFirestore.instance.collection('exchange-daily').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          } else {
            var dinar = CurrenciesModel.fromDocumentSnapshot(snapshot);
            return Scaffold(
              body: Stack(children: [
                RefreshIndicator(
                  onRefresh: () async {},
                  child: ListView.builder(
                    itemCount: dinar.currenciescount,
                    itemBuilder: (context, index) {
                      // get the code for each counrty to set the image icon
                      var iconItem = "".obs;
                      var currencyCodeItem = "".obs;
                      var countryName = "".obs;
                      var yesterdayBuyPriceItem = 0.0.obs;
                      var buyPriceItem = 0.0.obs;
                      var sellPriceItem = 0.0.obs;
                      var percent = 0.0.obs;
                      iconItem.value =
                          dinar.todayBuyPricesMap!.keys.toList()[index];
                      //
                      currencyCodeItem.value = dinar.todayBuyPricesMap!.keys
                          .toList()[index]
                          .toUpperCase();
                      //dinar.yesterayBuyPricesMap!
                      yesterdayBuyPriceItem.value = dinar
                          .yesterayPrice!['anis'][1].values
                          .toList()[index]
                          .toDouble();
        
                      buyPriceItem.value = dinar.todayBuyPricesMap!.values
                          .toList()[index]
                          .toDouble();
                      sellPriceItem.value = dinar.todaySellPricesMap!.values
                          .toList()[index]
                          .toDouble();
                      percent.value = ((1 -
                              (yesterdayBuyPriceItem.value /
                                  buyPriceItem.value)) *
                          100);
                      //our main list
                      //Using a list of rows instead of Listile becuase we can have much more customizability
                      return Obx(() => SizedBox(
                            height: 70,
                            child: Card(
                              elevation: 10,
                              child: GestureDetector(
                                onTap: () {
                                  buyPrice = buyPriceItem;
                                  sellPrice = sellPriceItem;
                                  currencyCode = currencyCodeItem;
                                  isShow.value = true;
                                },
                                child: Row(
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      5, 0, 0, 000),
                                              child: Image.asset(
                                                'icons/currency/${iconItem.value}.png',
                                                package: 'currency_icons',
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(10.0),
                                              child: Text(
                                                currencyCodeItem.value,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headline6,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 3),
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              5, 0, 0, 0),
                                          child: Text(
                                            '${codeToCountry[currencyCodeItem.value]}',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall,
                                          ),
                                        ),
                                      ],
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
                                          percent.value.toStringAsFixed(1) +
                                              '%',
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
                                      child: Text(
                                        buyPriceItem.value.toStringAsFixed(0),
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ));
                    },
                  ),
                ),
                Obx(
                  () => Visibility(
                    visible: isShow.value,
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
                                      isShow.value = false;
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
              ]),
            );
          }
        });
  }
}
