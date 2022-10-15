// ignore: file_names
class Transactions {
  late int? id;
  String title;
  double amount;
  String date;

  Transactions(
      {this.id,
      required this.title,
      required this.amount,
      required this.date});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'date': date
    };
  }
}
