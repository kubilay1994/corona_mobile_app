import 'package:corona_mobile_app/models/timeline-record.dart';
import 'package:corona_mobile_app/providers/corona-historical-records.dart';
import 'package:corona_mobile_app/providers/settings.dart';
import 'package:corona_mobile_app/widgets/search-bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:charts_flutter/flutter.dart' as charts;

class LineChartTabController {
  void Function() resetCountryState;
  void Function() showCountryPicker;
}

class LineChartTab extends StatefulWidget {
  final LineChartTabController controller;
  LineChartTab({@required this.controller});
  @override
  _LineChartTabState createState() => _LineChartTabState(controller);
}

class _LineChartTabState extends State<LineChartTab> {
  String _selectedCountry;
  var countryController = TextEditingController();

  _LineChartTabState(LineChartTabController _controller) {
    _controller.resetCountryState = resetCountryState;
    _controller.showCountryPicker = showCountryPicker;
  }

  charts.Series createLineSeries({
    @required List<TimelineRecord> data,
    @required String id,
    @required num Function(TimelineRecord rec, int index) measureFn,
    @required MaterialColor color,
  }) =>
      charts.Series<TimelineRecord, DateTime>(
        data: data,
        id: id,
        domainFn: (datum, index) => DateTime.parse(datum.date),
        measureFn: measureFn,
        colorFn: (datum, index) => charts.ColorUtil.fromDartColor(color),
      );

  void resetCountryState() => setState(() => _selectedCountry = null);

  void showCountryPicker() => showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) => StatefulBuilder(
          builder: (context, setInnerState) {
            var countries = context.select((CoronaHistoricalRecords value) =>
                value.countries..sort((a, b) => a.compareTo(b)));

            if (countryController.text.trim().isNotEmpty) {
              countries = countries
                  .where((country) => country
                      .toLowerCase()
                      .contains(countryController.text.toLowerCase()))
                  .toList();
            }
            final deviceInfo = MediaQuery.of(context);
            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(
                  bottom: deviceInfo.viewInsets.bottom / 1.5,
                ),
                child: Column(
                  children: [
                    SearchBar(
                      onChanged: (_) => setInnerState(() {}),
                      controller: countryController,
                    ),
                    SizedBox(
                      height: deviceInfo.size.height / 2.3,
                      child: ListView.builder(
                        itemCount: countries.length,
                        itemBuilder: (context, index) => CheckboxListTile(
                            title: Text(countries[index]),
                            value: countries[index] == _selectedCountry,
                            onChanged: (value) {
                              setState(
                                () => _selectedCountry = countries[index],
                              );
                              Navigator.pop(context);
                            }),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );

  @override
  Widget build(BuildContext context) {
    final isDarkMode = context.watch<Settings>().darkMode;
    var data = context.select((CoronaHistoricalRecords value) =>
        _selectedCountry != null
            ? value.getRecordByCountryName(_selectedCountry)
            : value.worldRecord);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(10),
          child: Text(
            "${data == null ? "" : data.country} Historical Data Distribution",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headline5.copyWith(
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                ),
          ),
        ),
        Flexible(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: data == null
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : charts.TimeSeriesChart(
                    [
                      createLineSeries(
                          data: data.timeline,
                          id: "Cases",
                          measureFn: (rec, _) => rec.cases,
                          color: Colors.red),
                      createLineSeries(
                          data: data.timeline,
                          id: "Deaths",
                          measureFn: (rec, _) => rec.deaths,
                          color: Colors.grey),
                      createLineSeries(
                          data: data.timeline,
                          id: "Recovered",
                          measureFn: (rec, _) => rec.recovered,
                          color: Colors.green),
                    ],
                    animate: true,
                    behaviors: [charts.SeriesLegend()],
                    domainAxis: charts.DateTimeAxisSpec(
                      renderSpec: charts.SmallTickRendererSpec(
                        labelStyle: charts.TextStyleSpec(
                          color: charts.ColorUtil.fromDartColor(
                              isDarkMode ? Colors.white : Colors.black),
                        ),
                      ),
                    ),
                    primaryMeasureAxis: charts.NumericAxisSpec(
                        renderSpec: charts.GridlineRendererSpec(
                      labelStyle: charts.TextStyleSpec(
                        color: charts.ColorUtil.fromDartColor(
                            isDarkMode ? Colors.white : Colors.black),
                      ),
                    )),
                  ),
          ),
        ),
      ],
    );
  }
}
