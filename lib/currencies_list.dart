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

          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasData) {
              Map<String, dynamic> dataa =
                  snapshot.data!.docs.last.data() as Map<String, dynamic>;

              Map<String, dynamic> buy_prices = dataa['anis'][0];
              Map<String, dynamic> sell_prices = dataa['anis'][1];

              //var reversed = list.keys.toList();
              //print(reversed);
              int count = buy_prices.length;
              var rr = snapshot.data!.docs.first.data();

              return Stack(children: [
                ListView.builder(
                  itemCount: count,
                  itemBuilder: (context, index) {
                    // get the code for each counrty to set the image icon
                    var icon1 = "".obs;
                    var currenecyCode1 = "".obs;
                    var buyPrices1 = 0.0.obs;
                    var sellPrices1 = 0.0.obs;

                    icon1.value = buy_prices.keys.toList()[index];
                    /* snapshot.data!.docs[0].data().keys.toList()[index]; */

                    currenecyCode1.value = buy_prices.keys.toList()[index];
                    /*  snapshot.data!.docs[0].data().keys.toList()[index]; */

                    buyPrices1.value =
                        buy_prices.values.toList()[index].toDouble();
                    /*  snapshot.data!.docs[0].data().values.toList()[index]; */

                    sellPrices1.value =
                        sell_prices.values.toList()[index].toDouble();
                    /*   snapshot.data!.docs[1].data().values.toList()[index]; */

                    //our main list
                    return Card(
                      elevation: 50,
                      child: ListTile(
                          leading: Image.asset(
                            'icons/currency/${icon1.value}.png',
                            package: 'currency_icons',
                          ),
                          title: Text(
                            currenecyCode1.toString(),
                          ),
                          trailing: Text(buyPrices1.value.toString()),
                          onTap: () {
                            buy_price = buyPrices1;
                            sellPrice = sellPrices1;
                            currencyCode = currenecyCode1;
                            print(rr);
                            isShow.value = true;
                          }),
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
                          color: Color.fromARGB(83, 255, 7, 7),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  IconButton(
                                      onPressed: () {
                                        isShow.value = false;
                                      },
                                      icon:
                                          Icon(Icons.one_x_mobiledata_rounded))
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
