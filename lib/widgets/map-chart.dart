import 'package:corona_mobile_app/models/corona-record.dart';
import 'package:corona_mobile_app/providers/corona-historical-records.dart';
import 'package:flutter/material.dart';

import 'package:flutter_map/flutter_map.dart';
import 'package:provider/provider.dart';
import 'package:latlong/latlong.dart';

class MapChart extends StatelessWidget {
  List<Marker> generateMarker(List<CoronaRecord> records) {
    final oldMin = records.last.timeline.cases;
    final oldMax = records.first.timeline.cases;
    final oldRange = oldMax - oldMin;

    final newRange = 80 - 12;

    return records.map(
      (record) {
        final val =
            (((record.timeline.cases - oldMin) * newRange) / oldRange) + 6;
        return Marker(
          width: val,
          height: val,
          point: LatLng(
            record.points[0].toDouble(),
            record.points[1].toDouble(),
          ),
          builder: (context) => Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.deepOrange.withOpacity(0.7),
            ),
          ),
        );
      },
    ).toList();
  }

  @override
  Widget build(BuildContext context) {
    final records =
        context.select((CoronaHistoricalRecords value) => value.latestRecords);

    return Scaffold(
      appBar: AppBar(
        title: Text("Corona Map"),
      ),
      body: Column(children: [
        Expanded(
          child: FlutterMap(
            options: MapOptions(
              // center: LatLng(51.5, -0.09),
              zoom: 3.5,
              minZoom: 3,
              maxZoom: 5,
            ),
            children: [
              TileLayerWidget(
                options: TileLayerOptions(
                  urlTemplate:
                      "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                  subdomains: ['a', 'b', 'c'],
                ),
              ),
              MarkerLayerWidget(
                options: MarkerLayerOptions(markers: generateMarker(records)),
              )
            ],
          ),
        ),
      ]),
    );
  }
}
