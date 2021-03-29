class ReservationInformation {
  String status;
  String message;
  List<Datum> data;

  ReservationInformation({this.status, this.message, this.data});

  factory ReservationInformation.fromJson(Map<String, dynamic> json) => ReservationInformation(
        status: json["status"],
        message: json["message"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Datum {
  int reservNum;
  DateTime createdAt;
  int peopleNum;
  int tableNum;
  DateTime startTime;
  DateTime endTime;
  String message;

  Datum({
    this.reservNum,
    this.createdAt,
    this.peopleNum,
    this.tableNum,
    this.startTime,
    this.endTime,
    this.message,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        reservNum: json["reserv_num"],
        createdAt: DateTime.parse(json["created_at"].split('T')[0]+' '+json["created_at"].split('T')[1].split('.')[0]),
        peopleNum: json["people_num"],
        tableNum: json["table_num"],
        startTime: DateTime.parse(json["start_time"].split('T')[0]+' '+json["start_time"].split('T')[1].split('+')[0]),
        endTime: DateTime.parse(json["end_time"].split('T')[0]+' '+json["end_time"].split('T')[1].split('+')[0]),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "reserv_num": reservNum,
        "created_at":
            "${createdAt.year.toString().padLeft(4, '0')}-${createdAt.month.toString().padLeft(2, '0')}-${createdAt.day.toString().padLeft(2, '0')}",
        "people_num": peopleNum,
        "table_num": tableNum,
        "start_time": startTime.toIso8601String(),
        "end_time": endTime.toIso8601String(),
        "message": message,
      };
}
