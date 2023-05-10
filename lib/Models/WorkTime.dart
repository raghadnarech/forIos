class WorkTime {
  String? date;
  String? in_time;
  String? out_time;
  String? total;
  WorkTime({this.date, this.in_time, this.out_time, this.total});
  factory WorkTime.fromJson(Map<String, dynamic> responsedata) {
    return WorkTime(
      date: responsedata["date"],
      in_time: responsedata["in_time"] ?? "غير محدد",
      out_time: responsedata["out_time"] ?? "غير محدد",
      total: responsedata["total_time"] ?? "غير محدد",
    );
  }
}
