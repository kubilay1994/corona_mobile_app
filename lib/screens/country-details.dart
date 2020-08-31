import 'package:corona_mobile_app/models/timeline-record.dart';
import 'package:corona_mobile_app/providers/corona-historical-records.dart';
import 'package:corona_mobile_app/widgets/data-list.dart';
import 'package:corona_mobile_app/widgets/update-timeline-form.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:provider/provider.dart';

class CounrtyDetails extends StatefulWidget {
  static const routeName = "admin/details";

  @override
  _CounrtyDetailsState createState() => _CounrtyDetailsState();
}

class _CounrtyDetailsState extends State<CounrtyDetails> {
  void displayTimelineForm(BuildContext ctx,
      {String id, Map<String, dynamic> formData}) async {
    String val = await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (ctx) => SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  20,
                  20,
                  20,
                  MediaQuery.of(context).viewInsets.bottom + 20,
                ),
                child: UpdateTimelineForm(
                  id: id,
                  formData: formData,
                ),
              ),
            ));
    if (val != null)
      Scaffold.of(ctx).showSnackBar(SnackBar(content: Text(val)));
  }

  @override
  Widget build(BuildContext context) {
    final String id = ModalRoute.of(context).settings.arguments;

    var data = context
        .select((CoronaHistoricalRecords value) => value.getRecordById(id));

    return Scaffold(
      appBar: AppBar(
        title: Text("Details"),
      ),
      body: Builder(
        builder: (ctx) => Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Center(
              child: Text(
                "Details for country with id $id",
                style: Theme.of(context).textTheme.headline6,
              ),
            ),
            // UpdateTimelineForm(),
            SizedBox(
              height: 10,
            ),
            RaisedButton(
              onPressed: () => displayTimelineForm(ctx, id: id),
              child: Text("Update Timeline"),
              color: Theme.of(context).primaryColorLight,
              textColor: Theme.of(context).primaryColorDark,
            ),
            DataList(
              data: data.timeline,
              headerData: ["Date", "Cases", "Deaths", "Recovered"],
              onItemTabbed: (TimelineRecord item) =>
                  displayTimelineForm(ctx, id: id, formData: {
                "selectedDate": DateTime.parse(item.date),
                "cases": item.cases,
                "deaths": item.deaths,
                "recovered": item.recovered,
              }),
              rowBuilder: (List<TimelineRecord> data, index) => [
                Expanded(
                  child: Text(
                    DateFormat.yMMMd().format(DateTime.parse(data[index].date)),
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                ),
                Expanded(
                  child: Text(
                    NumberFormat.compact().format(data[index].cases),
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.red),
                  ),
                ),
                Expanded(
                  child: Text(
                    NumberFormat.compact().format(data[index].deaths),
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
                Expanded(
                  child: Text(
                    NumberFormat.compact().format(data[index].recovered),
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.green),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
