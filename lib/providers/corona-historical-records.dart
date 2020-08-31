import 'package:corona_mobile_app/models/corona-record.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'dart:convert' as convert;

import '../models/corona-historical-record.dart';

import 'package:http/http.dart' as http;

import '../constants/constants.dart' as Constants;

class CoronaHistoricalRecords with ChangeNotifier {
  List<CoronaHistoricalRecord> _records = [];
  List<CoronaRecord> _latestRecords = [];
  CoronaHistoricalRecord worldRecord;

  CoronaHistoricalRecords() {
    fetchAndSetRecords();
  }

  List<CoronaHistoricalRecord> get records => [..._records];

  List<CoronaRecord> get latestRecords => [..._latestRecords];

  List<String> get countries => _records.map((e) => e?.country).toList();

  CoronaHistoricalRecord getRecordById(String id) =>
      _records.firstWhere((e) => e.id == id);

  CoronaHistoricalRecord getRecordByCountryName(String country) =>
      _records.firstWhere((e) => e.country == country);

  void updateRecord(String id, CoronaHistoricalRecord newRecord) {
    var index = _records.indexWhere((element) => element.id == newRecord.id);
    _records[index] = newRecord;

    var i = _latestRecords
        .indexWhere((element) => element.id == newRecord.latestRecord.id);
    _latestRecords[i] = newRecord.latestRecord;

    notifyListeners();
  }

  Future<void> fetchAndSetRecords({int timelineLimit = 360}) async {
    const baseUrl = Constants.baseUrl;

    var client = http.Client();
    try {
      final countryUrl = Uri.https(baseUrl, "api/corona/country", {
        "timelineLimit": timelineLimit.toString(),
      });

      final worldWideUrl = Uri.https(baseUrl, "api/corona/all", {
        "timelineLimit": timelineLimit.toString(),
      });

      final responses =
          await Future.wait([client.get(countryUrl), client.get(worldWideUrl)]);

      final List<CoronaHistoricalRecord> countryRecords =
          (convert.jsonDecode(responses[0].body) as List)
              .map((e) => CoronaHistoricalRecord.fromJson(e))
              .toList();
      final CoronaHistoricalRecord worldRecord =
          CoronaHistoricalRecord.fromJson(
              convert.jsonDecode(responses[1].body));

      _records = countryRecords;
      this.worldRecord = worldRecord;

      _latestRecords = _records.map((e) => e.latestRecord).toList()
        ..sort((a, b) => b.timeline.cases - a.timeline.cases);

      notifyListeners();
    } catch (e) {
      print(e);
    } finally {
      client.close();
    }
  }
}
