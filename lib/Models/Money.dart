class Money {
  int? id;
  String? amount;
  String? amount_status;
  String? date;
  String? reason;

  Money({this.amount, this.amount_status, this.date, this.reason, this.id});

  factory Money.fromJson(Map<String, dynamic> responsedata) {
    return Money(
        id: responsedata['id'],
        amount: responsedata['amount'],
        amount_status: responsedata['amount_status'],
        date: responsedata['date'] ?? "لا يوجد",
        reason: responsedata['reason'] ?? "لايوجد");
  }
}
