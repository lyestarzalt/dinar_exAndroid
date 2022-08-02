import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'line_chart.dart';
import 'datum.dart';

class Chart extends StatefulWidget {
  const Chart({Key? key}) : super(key: key);

  @override
  State<Chart> createState() => _ChartState();
}

class _ChartState extends State<Chart> {
  var dropdownvalue = 'gbp';
  var collection =
      FirebaseFirestore.instance.collection('exchange-daily').get();

  // List of items in our dropdown menu
  List<String> currenciesCodes = [];
  var _collection;
  @override
  void initState() {
    _collection = collection;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      //Initialize the chart widget
      FutureBuilder<QuerySnapshot>(
        future: _collection,
        builder: (BuildContext context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData) {
            List<QueryDocumentSnapshot<Object?>> allDocuments =
                snapshot.data!.docs;

            final List<dynamic> tempList = [];

            //? get last day and store every key to the curreincesCodes list
            //? to be used in the dropdown menu
            Map<dynamic, dynamic> lastDay =
                allDocuments.last.data() as Map<dynamic, dynamic>;

            Map<String, dynamic> curenciesMap = lastDay['anis'][0];
            currenciesCodes = curenciesMap.keys.toList();

            //? loop through each document in the collect and store the buy values and
            //? the date in a list of objects called tempList that consist of ValueDinar objects
            for (var document in allDocuments) {
              Map<String, dynamic> prices =
                  document.data() as Map<String, dynamic>;
              tempList.add({
                "date": document.id,
                'price': prices['anis'][0][dropdownvalue]
              });
            }
            List<ValueDinar> chartData =
                tempList.map((json) => ValueDinar.fromfirebase(json)).toList();

            return Column(
              children: [
                DinarChart(data: chartData),
                DropdownButton(
                  // Initial allDocuments
                  value: dropdownvalue,

                  // Down Arrow Icon
                  icon: const Icon(Icons.keyboard_arrow_down),

                  // Array list of items
                  items: currenciesCodes.map((String item) {
                    return DropdownMenuItem<String>(
                      value: item,
                      child: Row(
                        children: [
                          SizedBox(
                            height: 20,
                            width: 20,
                            child: Image.asset(
                              'icons/currency/$item.png',
                              package: 'currency_icons',
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                  // After selecting the desired option,it will
                  // change button allDocuments to selected allDocuments
                  onChanged: (String? newValue) {
                    setState(() {
                      dropdownvalue = newValue!;
                      _collection = FirebaseFirestore.instance
                          .collection('exchange-daily')
                          .get();
                    });
                  },
                ),
              ],
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    ]);
  }
}
