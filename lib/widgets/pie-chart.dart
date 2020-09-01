import 'package:corona_mobile_app/models/corona-record.dart';
import 'package:corona_mobile_app/models/timeline-record.dart';
import 'package:corona_mobile_app/providers/corona-historical-records.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class PieChart extends StatelessWidget {
  // final colors = [
  //   charts.MaterialPalette.cyan.shadeDefault.darker.darker,
  //   charts.MaterialPalette.cyan.shadeDefault.darker,
  //   charts.MaterialPalette.cyan.shadeDefault,
  //   charts.MaterialPalette.cyan.shadeDefault.lighter,
  //   charts.MaterialPalette.cyan.shadeDefault.lighter.lighter,
  //   charts.MaterialPalette.cyan.shadeDefault.lighter.lighter.lighter,
  // ];

  @override
  Widget build(BuildContext context) {
    var data =
        context.select((CoronaHistoricalRecords value) => value.latestRecords);

    if (data.length > 5) data = data.sublist(0, 5);

    final worldRecord =
        context.select((CoronaHistoricalRecords value) => value.worldRecord);

    final deviceInfo = MediaQuery.of(context);

    final other = CoronaRecord(
      country: "Other",
      id: "other",
      points: null,
      timeline: TimelineRecord(
        date: null,
        cases: worldRecord != null
            ? worldRecord.timeline[0].cases -
                data.fold(0, (curr, next) => curr + next.timeline.cases)
            : null,
        deaths: null,
        recovered: null,
      ),
    );

    data.insert(0, other);

    return data.length > 1
        ? charts.PieChart(
            [
              charts.Series<CoronaRecord, String>(
                data: data,
                id: "Cases",
                domainFn: (datum, _) => datum.country,
                measureFn: (datum, _) => datum.timeline.cases,
                // colorFn: (_, index) => colors[index],
              )
            ],
            animate: true,
            behaviors: [
              charts.DatumLegend(
                position: charts.BehaviorPosition.bottom,
                horizontalFirst: false,
                desiredMaxRows:
                    deviceInfo.orientation == Orientation.landscape ? 2 : 3,
                showMeasures: true,
                legendDefaultMeasure: charts.LegendDefaultMeasure.firstValue,
                measureFormatter: (measure) {
                  return (measure / worldRecord.timeline[0].cases * 100)
                          .toStringAsFixed(1) +
                      "%";
                },
              ),
            ],
          )
        : Center(
            child: CircularProgressIndicator(),
          );
  }
}
