class Task {
  int? id;
  String? task;
  String? status;
  String? image;
  List<Map>? listimage;
  Task({this.id, this.status, this.task, this.image, this.listimage});
  factory Task.formJson(Map<String, dynamic> responsedata, List<Map>? images) {
    return Task(
        id: responsedata['id'],
        status: responsedata['status'],
        task: responsedata['task'],
        image: responsedata['image'],
        listimage: images);
  }
}
