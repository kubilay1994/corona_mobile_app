import 'package:corona_mobile_app/providers/auth.dart';
import 'package:corona_mobile_app/screens/admin-panel.dart';
import 'package:corona_mobile_app/widgets/app-drawer.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = "/login";

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  var _isLoading = false;

  final _authData = {
    "username": "",
    "password": "",
  };

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: ListTile(
          leading: Icon(
            Icons.error,
            color: Colors.red,
          ),
          title: Text("An Error occured"),
        ),
        content: Text(message),
        actions: [
          FlatButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(
                "Okay",
              ))
        ],
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState.validate()) return;

    _formKey.currentState.save();

    setState(() {
      _isLoading = true;
    });

    try {
      await context
          .read<Auth>()
          .login(_authData["username"], _authData["password"]);
      Navigator.pushReplacementNamed(context, AdminPanelScreen.routeName);
    } catch (e) {
      _showErrorDialog(e);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceInfo = MediaQuery.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
      ),
      drawer: AppDrawer(),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(bottom: deviceInfo.viewInsets.bottom),
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Text("Login", style: Theme.of(context).textTheme.headline3),
              if (deviceInfo.size.height > 600)
                SizedBox(
                  height: deviceInfo.size.height * 0.07,
                ),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: deviceInfo.size.width * 0.05),
                child: Card(
                  elevation: 8,
                  margin: EdgeInsets.all(10),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  color: Theme.of(context).cardColor,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          onSaved: (newValue) =>
                              _authData["username"] = newValue,
                          validator: (value) => value.isEmpty
                              ? "Username field is required"
                              : null,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.account_circle),
                            hintText: "Enter Username",
                            labelText: "Username",
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 15, horizontal: 45),
                          ),
                        ),
                        TextFormField(
                          onSaved: (newValue) =>
                              _authData["password"] = newValue,
                          validator: (value) => value.isEmpty
                              ? "Password field is required"
                              : null,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.lock),
                            hintText: "Enter password",
                            labelText: "Password",
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 15, horizontal: 45),
                          ),
                          obscureText: true,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        if (_isLoading)
                          CircularProgressIndicator(
                            backgroundColor: Theme.of(context).primaryColorDark,
                          )
                        else
                          RaisedButton(
                            onPressed: _submit,
                            child: Text("Login"),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            color: Theme.of(context).primaryColorDark,
                            textColor: Colors.white,
                          ),
                        SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
