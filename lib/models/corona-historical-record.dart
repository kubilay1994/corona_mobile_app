import '../models/timeline-record.dart';
import 'package:flutter/foundation.dart';

import 'corona-record.dart';

class CoronaHistoricalRecord {
  final String id;
  final String country;
  final List<TimelineRecord> timeline;
  final List<num> points;

  CoronaHistoricalRecord({
    @required this.id,
    @required this.country,
    @required this.timeline,
    this.points = const [0, 0],
  });

  CoronaRecord get latestRecord {
    return CoronaRecord(
      id: this.id,
      country: this.country,
      points: this.points,
      timeline: this.timeline.first,
    );
  }

  CoronaHistoricalRecord.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        country = json["country"],
        points = List<num>.from(json["points"]),
        timeline = (json["timeline"] as List)
            .map((e) => TimelineRecord.fromJson(e))
            .toList();

  Map<String, dynamic> toJson() =>
      {"id": id, "country": country, "timeline": timeline};
}
