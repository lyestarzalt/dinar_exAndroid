class Value {
  Value({required this.date, required this.price});

  final DateTime date;
  final double price;

  Value.fromfirebase(Map<String, dynamic> json)
      : date = DateTime.parse(json['date']),
        price = json['close'].toDouble();
}
