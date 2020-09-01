import 'package:corona_mobile_app/models/corona-record.dart';
import 'package:corona_mobile_app/providers/corona-historical-records.dart';
import 'package:corona_mobile_app/widgets/info-card.dart';
import 'package:flutter/material.dart';

import 'package:flutter_map/flutter_map.dart';
import 'package:provider/provider.dart';
import 'package:latlong/latlong.dart';

class MapChart extends StatelessWidget {
  void displayInfoDiolog(BuildContext context, CoronaRecord record) {
    showDialog(
      context: context,
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: InfoCard(
          countryInfo: record,
          onButtonClicked: () => Navigator.pop(context),
        ),
      ),
    );
  }

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
          builder: (context) => InkWell(
            onTap: () => showDialog(
              context: context,
              child: Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: InfoCard(
                  countryInfo: record,
                  onButtonClicked: () => Navigator.pop(context),
                ),
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.deepOrange.withOpacity(0.7),
              ),
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

    final worldRecord =
        context.select((CoronaHistoricalRecords value) => value.worldRecord);

    return Scaffold(
      appBar: AppBar(
        title: Text("Corona Map"),
        actions: [
          Container(
            // width: double.infinity,
            padding: const EdgeInsets.all(2),
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                    color: Theme.of(context).primaryColorLight.withOpacity(0.5),
                    offset: Offset.fromDirection(3),
                    blurRadius: 5,
                    spreadRadius: 2),
              ],
            ),
            child: RaisedButton(
              color: Theme.of(context).primaryColorDark,
              textColor: Colors.white,
              child: Text("Display world Record"),
              onPressed: () =>
                  displayInfoDiolog(context, worldRecord.latestRecord),
            ),
          ),
        ],
      ),
      body: records.length > 0 && worldRecord != null
          ? Column(children: [
              Expanded(
                child: FlutterMap(
                  options: MapOptions(
                    // center: LatLng(51.5, -0.09),
                    zoom: 3.2,
                    minZoom: 3.2,
                    maxZoom: 4,
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
                      options:
                          MarkerLayerOptions(markers: generateMarker(records)),
                    )
                  ],
                ),
              ),
            ])
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
