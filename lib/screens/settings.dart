import 'package:corona_mobile_app/providers/settings.dart';
import 'package:corona_mobile_app/widgets/app-drawer.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

class SettingsScreen extends StatelessWidget {
  static const routeName = "settings";
  @override
  Widget build(BuildContext context) {
    final settingsProvider = context.watch<Settings>();
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
      ),
      drawer: AppDrawer(),
      body: ListView(
        children: [
          SwitchListTile(
            title: Text("Dark mode"),
            subtitle: Text("Swtich to Dark Mode"),
            value: settingsProvider.darkMode,
            onChanged: (val) {
              context.read<Settings>().switchMode();
            },
          )
        ],
      ),
    );
  }
}
