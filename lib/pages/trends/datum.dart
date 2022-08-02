class ValueDinar {
  ValueDinar({required this.date, required this.price});

  final DateTime date;
  final double price;

  ValueDinar.fromfirebase(Map<String, dynamic> json)
      : date = DateTime.parse(json['date']),
        price = json['price'].toDouble();
}
