import 'package:corona_mobile_app/models/corona-record.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class InfoCard extends StatelessWidget {
  final CoronaRecord countryInfo;
  final void Function() onButtonClicked;
  InfoCard({
    @required this.countryInfo,
    @required this.onButtonClicked,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        alignment: Alignment.center,
        height: 250,
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              countryInfo.country,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headline4,
            ),
            SizedBox(
              height: 30,
            ),
            Row(
              children: ["Cases", "Deaths", "Recovered"]
                  .map(
                    (title) => Expanded(
                      child: Text(
                        title,
                        style: TextStyle(
                          fontSize: 20,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                  .toList(),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    NumberFormat.compact().format(countryInfo.timeline.cases),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.red,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    NumberFormat.compact().format(countryInfo.timeline.deaths),
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
                Expanded(
                  child: Text(
                    NumberFormat.compact()
                        .format(countryInfo.timeline.recovered),
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.green),
                  ),
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.only(top: 20),
              child: RaisedButton(
                onPressed: onButtonClicked,
                child: Text("Close"),
                color: Theme.of(context).buttonTheme.colorScheme.primary,
                textColor: Colors.white,
              ),
            )
          ],
        ),
      ),
    );
  }
}
