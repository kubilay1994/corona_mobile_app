import 'package:flutter/cupertino.dart';

class TimelineRecord {
  String date;
  int cases;
  int deaths;
  int recovered;

  TimelineRecord({
    @required this.date,
    @required this.cases,
    @required this.deaths,
    @required this.recovered,
  });

  factory TimelineRecord.fromJson(Map<String, dynamic> json) {
    return TimelineRecord(
      cases: json["cases"],
      date: json["date"],
      recovered: json["recovered"],
      deaths: json["deaths"],
    );
  }
}
