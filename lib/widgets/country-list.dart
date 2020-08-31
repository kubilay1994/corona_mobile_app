import 'package:corona_mobile_app/models/corona-record.dart';
import 'package:corona_mobile_app/providers/corona-historical-records.dart';
import 'package:corona_mobile_app/widgets/data-list.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:provider/provider.dart';

import 'sort-select.dart';

class CountryList extends StatefulWidget {
  @override
  _CountryListState createState() => _CountryListState();
}

class _CountryListState extends State<CountryList> {
  final countryController = TextEditingController();
  var sortValue = 0;

  @override
  Widget build(BuildContext context) {
    var data =
        context.select((CoronaHistoricalRecords value) => value.latestRecords);

    if (countryController.text.trim().isNotEmpty) {
      data = data
          .where((e) => e.country
              .toLowerCase()
              .contains(countryController.text.toLowerCase()))
          .toList();
    }

    switch (sortValue) {
      case 0:
        data.sort((a, b) => b.timeline.cases - a.timeline.cases);
        break;
      case 1:
        data.sort((a, b) => b.timeline.deaths - a.timeline.deaths);
        break;
      case 2:
        data.sort((a, b) => b.timeline.recovered - a.timeline.recovered);
        break;
    }

    sortValue = 3;
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Search Country",
                  prefixIcon: Icon(Icons.search),
                ),
                controller: countryController,
                autofocus: false,
                onChanged: (val) {
                  setState(() {});
                },
              ),
            ),
            SortSelect(
                title: "Sort",
                items: [
                  SortSelectItem(0, "Sort by Case"),
                  SortSelectItem(1, "Sort by Deaths"),
                  SortSelectItem(2, "Sort by Recovered")
                ],
                onSelect: (val) {
                  if (val != sortValue) {
                    setState(() => sortValue = val);
                  }
                }),
          ],
        ),
        data.length == 0
            ? Expanded(child: Center(child: Text("Statistics are not found")))
            : DataList(
                data: data,
                headerData: ["Country", "Cases", "Deaths", "Recovered"],
                rowBuilder: (List<CoronaRecord> data, index) => [
                  Expanded(
                    child: Text(
                      data[index].country,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontStyle: FontStyle.italic),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      NumberFormat.compact().format(data[index].timeline.cases),
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      NumberFormat.compact()
                          .format(data[index].timeline.deaths),
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      NumberFormat.compact()
                          .format(data[index].timeline.recovered),
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.green),
                    ),
                  ),
                ],
              )
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
    countryController.dispose();
  }
}
