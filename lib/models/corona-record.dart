import '../models/timeline-record.dart';
import 'package:flutter/foundation.dart';

class CoronaRecord {
  final String id;
  final String country;
  final TimelineRecord timeline;
  final List<num> points;

  CoronaRecord({
    @required this.id,
    @required this.country,
    @required this.timeline,
    @required this.points,
  });
}
