class Permission {
  int? id;
  String? username;
  String? phone;
  String? kind;
  String? days;
  String? image;
  String? houres;
  String? date;
  String? reason;
  int? status;

  Permission(
      {this.date,
      this.days,
      this.houres,
      this.id,
      this.image,
      this.kind,
      this.status,
      this.reason,
      this.phone,
      this.username});

  factory Permission.fromJson(Map<String, dynamic> responsedata) {
    return Permission(
      date: responsedata['date'],
      days: responsedata['days'],
      houres: responsedata['hours'],
      status: responsedata['status'],
      id: responsedata['id'],
      image: responsedata['image'],
      kind: responsedata['kind'],
      reason: responsedata['reason'],
      phone: responsedata['user']['phone'] ?? "",
      username: responsedata['user']['name'] ?? "",
    );
  }
}
