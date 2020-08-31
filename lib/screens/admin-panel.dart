import 'package:corona_mobile_app/models/corona-record.dart';
import 'package:corona_mobile_app/providers/corona-historical-records.dart';
import 'package:corona_mobile_app/screens/country-details.dart';
import 'package:corona_mobile_app/widgets/app-drawer.dart';
import 'package:corona_mobile_app/widgets/data-list.dart';
import 'package:corona_mobile_app/widgets/search-bar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:provider/provider.dart';

class AdminPanelScreen extends StatefulWidget {
  static const routeName = "admin";
  @override
  _AdminPanelScreenState createState() => _AdminPanelScreenState();
}

class _AdminPanelScreenState extends State<AdminPanelScreen> {
  final countryController = TextEditingController();

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

    return Scaffold(
      appBar: AppBar(
        title: Text("AdminPanel"),
      ),
      body: Column(
        children: [
          SearchBar(
            onChanged: (_) => setState(() {}),
            controller: countryController,
          ),
          DataList(
            data: data,
            headerData: ["Country", "Cases", "Deaths", "Recovered"],
            onItemTabbed: (CoronaRecord item) => Navigator.pushNamed(
                context, CounrtyDetails.routeName,
                arguments: item.id),
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
                  NumberFormat.compact().format(data[index].timeline.deaths),
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              Expanded(
                child: Text(
                  NumberFormat.compact().format(data[index].timeline.recovered),
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.green),
                ),
              ),
            ],
          )
        ],
      ),
      drawer: AppDrawer(),
    );
  }
}
