import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';
import 'package:get/get.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'chart/line_chart.dart';

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

  List<charts.TickSpec<num>> _createTickSpec(double minVal, double maxVal) {
    List<charts.TickSpec<num>> _tickProvidSpecs = [];
    int d = minVal.toInt();
    while (d <= maxVal) {
      _tickProvidSpecs.add(charts.TickSpec(d,
          label: '$d', style: charts.TextStyleSpec(fontSize: 14)));
      d += 1;
    }

    return _tickProvidSpecs;
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
            var values = [];
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
              values.add(oneDay['anis'][0][dropdownvalue].toDouble());
            }

            double yMin = values.cast<double>().reduce(min);
            double yMax = values.cast<double>().reduce(max);

            currecies = templist[0];
            logger.wtf(yMin);
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

                primaryMeasureAxis: new charts.NumericAxisSpec(
                  tickProviderSpec: new charts.StaticNumericTickProviderSpec(
                    _createTickSpec(yMin, yMax),
                  ),
                ),

                domainAxis: const charts.DateTimeAxisSpec(
                  tickProviderSpec: charts.DayTickProviderSpec(increments: [1]),
                  tickFormatterSpec: charts.AutoDateTimeTickFormatterSpec(),
                  showAxisLine: false,
                ),
              ),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      StockChartExample()
    ]);
  }
}

class TimeSeriesSales {
  final DateTime time;
  final double sales;

  TimeSeriesSales(this.time, this.sales);
}
