import 'dart:convert';

import 'package:corona_mobile_app/models/corona-historical-record.dart';
import 'package:corona_mobile_app/providers/auth.dart';
import 'package:corona_mobile_app/providers/corona-historical-records.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:provider/provider.dart';

import 'package:http/http.dart' as http;

import '../constants/constants.dart' as Constants;

class UpdateTimelineForm extends StatefulWidget {
  final Map<String, dynamic> formData;
  final String id;

  UpdateTimelineForm({
    @required this.id,
    this.formData,
  });

  @override
  _UpdateTimelineFormState createState() => _UpdateTimelineFormState();
}

class _UpdateTimelineFormState extends State<UpdateTimelineForm> {
  final _formKey = GlobalKey<FormState>();
  Map<String, dynamic> _formData;

  @override
  initState() {
    super.initState();
    _formData = widget.formData ??
        {
          "selectedDate": DateTime.now(),
          "cases": null,
          "deaths": null,
          "recovered": null,
        };
  }

  Future<void> selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _formData["selectedDate"] ?? DateTime.now(),
      firstDate: DateTime(2019, 11),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        _formData["selectedDate"] = picked;
      });
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState.validate()) return;

    _formKey.currentState.save();

    final body = jsonEncode({
      "date": DateFormat("yyyy-MM-dd").format(_formData["selectedDate"]),
      "cases": int.parse(_formData["cases"]),
      "deaths": int.parse(_formData["deaths"]),
      "recovered": int.parse(_formData["recovered"]),
    });

    final authProvider = context.read<Auth>();
    final token = authProvider.token;
    const baseUrl = Constants.baseUrl;

    try {
      final response = await http.patch(
        Uri.https(baseUrl, "api/corona/timeline/${widget.id}",
            {"timelineLimit": "360"}),
        body: body,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token"
        },
      );

      if (response.statusCode == 401) {
        return authProvider.logout();
      }

      final responseBody = jsonDecode(response.body);

      var newRecord = CoronaHistoricalRecord.fromJson(
        responseBody["updatedDocument"],
      );

      var newWorldRecord =
          CoronaHistoricalRecord.fromJson(responseBody["worldRecord"]);
      var coronaProvider = context.read<CoronaHistoricalRecords>();

      coronaProvider.updateRecord(widget.id, newRecord);
      coronaProvider.seTworldRecord(newWorldRecord);

      Navigator.pop(context, "Timeline Updated Successfully");
    } catch (e) {
      print(e);
      Navigator.pop(context, "An error occured");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Text(
              "Update Timeline",
              style: Theme.of(context).textTheme.headline4,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      "${DateFormat.yMMMd().format(_formData["selectedDate"])}",
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                    FlatButton(
                      onPressed: () => selectDate(),
                      child: const Text("Select Date"),
                      // textColor: Theme.of(context).primaryColorDark,
                    )
                  ],
                ),
              ),
              Flexible(
                child: Column(
                  children: [
                    TextFormField(
                      initialValue: _formData["cases"]?.toString(),
                      keyboardType: TextInputType.number,
                      onSaved: (val) => _formData["cases"] = val,
                      decoration: InputDecoration(
                          hintText: "Case Count", labelText: "Case count"),
                    ),
                  ],
                ),
              )
            ],
          ),
          Container(
            height: 120,
            child: Column(
              children: [
                Flexible(
                  child: TextFormField(
                    initialValue: _formData["deaths"]?.toString(),
                    keyboardType: TextInputType.number,
                    onSaved: (val) => _formData["deaths"] = val,
                    decoration: InputDecoration(
                      hintText: "Dead Count",
                      labelText: "Dead count",
                    ),
                  ),
                ),
                Flexible(
                  child: TextFormField(
                    initialValue: _formData["recovered"]?.toString(),
                    keyboardType: TextInputType.number,
                    onSaved: (val) => _formData["recovered"] = val,
                    decoration: InputDecoration(
                      hintText: "Recovery Count",
                      labelText: "Recovery count",
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          RaisedButton(
            onPressed: _submit,
            child: Text("Save"),
            color: Theme.of(context).primaryColorLight,
          )
        ],
      ),
    );
  }
}
