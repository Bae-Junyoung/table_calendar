class Response {
  String status;
  String message;
  List<Datum> data;

  Response({this.status, this.message, this.data});

  factory Response.fromJson(Map<String, dynamic> json) => Response(
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
  int reserv_num;
  DateTime created_at;
  int people_num;
  int table_num;
  DateTime start_time;
  DateTime end_time;
  String message;

  Datum({
    this.reserv_num,
    this.created_at,
    this.people_num,
    this.table_num,
    this.start_time,
    this.end_time,
    this.message,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        reserv_num: json["reserv_num"],
        created_at: DateTime.parse(json["created_at"].split('T')[0]+' '+json["created_at"].split('T')[1].split('.')[0]),
        people_num: json["people_num"],
        table_num: json["table_num"],
        start_time: DateTime.parse(json["start_time"].split('T')[0]+' '+json["start_time"].split('T')[1].split('+')[0]),
        end_time: DateTime.parse(json["end_time"].split('T')[0]+' '+json["end_time"].split('T')[1].split('+')[0]),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "reserv_num": reserv_num,
        "created_at":
            "${created_at.year.toString().padLeft(4, '0')}-${created_at.month.toString().padLeft(2, '0')}-${created_at.day.toString().padLeft(2, '0')}",
        "people_num": people_num,
        "table_num": table_num,
        "start_time": start_time.toIso8601String(),
        "end_time": end_time.toIso8601String(),
        "message": message,
      };
}
