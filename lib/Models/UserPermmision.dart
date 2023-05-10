class PermissionUser {
  int? id;

  String? kind;
  String? days;
  String? image;
  String? houres;
  String? date;
  String? reason;
  int? status;

  PermissionUser({
    this.date,
    this.days,
    this.houres,
    this.id,
    this.image,
    this.kind,
    this.status,
    this.reason,
  });

  factory PermissionUser.fromJson(Map<String, dynamic> responsedata) {
    return PermissionUser(
      date: responsedata['date'],
      days: responsedata['days'],
      houres: responsedata['hours'],
      status: responsedata['status'],
      id: responsedata['id'],
      image: responsedata['image'],
      kind: responsedata['kind'],
      reason: responsedata['reason'],
    );
  }
}
