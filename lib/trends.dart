import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';
import 'package:get/get.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class Chart extends StatefulWidget {
  const Chart({Key? key}) : super(key: key);

  @override
  State<Chart> createState() => _ChartState();
}

class _ChartState extends State<Chart> {
  final List<charts.Series<dynamic, DateTime>> seriesList = [];

  List<String> currecies = [];
  RxList anis = [].obs;
  var templist = [];
  var dropdownvalue = 'gbp';

  // List of items in our dropdown menu
  var items = [
    "chf",
    "aed",
    "mad",
    "eur",
    "gbp",
    "sar",
    "cad",
    "usd",
    "try",
    "tnd",
    "cny"
  ];

/////////////////

  static List<charts.Series<TimeSeriesSales, DateTime>> _createSampleData(
      data) {
    return [
      charts.Series<TimeSeriesSales, DateTime>(
        id: 'Sales',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (TimeSeriesSales sales, _) => sales.time,
        measureFn: (TimeSeriesSales sales, _) => sales.sales,
        data: data,
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      //Initialize the chart widget
      FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance.collection('exchange-daily').get(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            List<TimeSeriesSales> data = [];

            var logger = Logger();

            var value = snapshot.data!.docs;
            for (var document in value) {
              Map<String, dynamic> oneDay =
                  document.data() as Map<String, dynamic>;
              //logger.i(lol['anis'][1]['cad']);
              Map<String, dynamic> codeCurrency =
                  oneDay['anis'][0] as Map<String, dynamic>;
              codeCurrency[0];
              templist.add(codeCurrency.keys.toList());

              DateTime parsedDate = DateTime.parse(document.id);
              var code = codeCurrency;
              data.add(TimeSeriesSales(
                  parsedDate, oneDay['anis'][0][dropdownvalue].toDouble()));
            }
            currecies = templist[0];
            logger.wtf(data);
            return SizedBox(
              width: 500,
              height: 300,
              child: charts.TimeSeriesChart(
                _createSampleData(data),
                animate: false,
                // Optionally pass in a [DateTimeFactory] used by the chart. The factory
                // should create the same type of [DateTime] as the data provided. If none
                // specified, the default creates local date time.
                dateTimeFactory: const charts.LocalDateTimeFactory(),

                domainAxis: const charts.DateTimeAxisSpec(
                  tickProviderSpec: charts.DayTickProviderSpec(increments: [3]),
                  tickFormatterSpec: charts.AutoDateTimeTickFormatterSpec(
             
                  ),
                  showAxisLine: false,
                  
                ),
              ),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    ]);
  }
}

class TimeSeriesSales {
  final DateTime time;
  final double sales;

  TimeSeriesSales(this.time, this.sales);
}
