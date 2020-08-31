import 'package:corona_mobile_app/providers/auth.dart';
import 'package:corona_mobile_app/screens/admin-panel.dart';
import 'package:corona_mobile_app/screens/login.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final auth = context.watch<Auth>();
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.business,
                  size: 50,
                  color: Theme.of(context).primaryColorDark,
                ),
                Text(
                  "Covid-19 App",
                  style: Theme.of(context).textTheme.headline4,
                ),
              ],
            ),
            decoration:
                BoxDecoration(color: Theme.of(context).primaryColorLight),
          ),
          ListTile(
            leading: Icon(Icons.insert_chart),
            title: Text("View Statistics"),
            onTap: () {
              Navigator.of(context).pushReplacementNamed("/");
            },
          ),
          Divider(
            color: Theme.of(context).primaryColorDark,
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text("Settings"),
            onTap: () {
              Navigator.of(context).pushReplacementNamed("settings");
            },
          ),
          Divider(
            color: Theme.of(context).primaryColorDark,
          ),

          if (auth.token == null)
            ListTile(
                leading: Icon(Icons.account_circle),
                title: Text("Login"),
                onTap: () => Navigator.of(context)
                    .pushReplacementNamed(LoginScreen.routeName))
          else ...[
            ListTile(
              leading: Icon(Icons.edit),
              title: Text("Admin Panel"),
              onTap: () {
                Navigator.pushReplacementNamed(
                    context, AdminPanelScreen.routeName);
              },
            ),
            Divider(
              color: Theme.of(context).primaryColorDark,
            ),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text("Logout"),
              onTap: () {
                auth.logout();
              },
            ),
          ],
          Divider(
            color: Theme.of(context).primaryColorDark,
          ),
          // ListTile(),
        ],
      ),
    );
  }
}
