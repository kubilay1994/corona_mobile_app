import 'package:flutter/material.dart';

class SearchBar extends StatelessWidget {
  final void Function(String val) onChanged;
  final TextEditingController controller;

  SearchBar({
    @required this.onChanged,
    @required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border:
            Border.all(width: 1, color: Theme.of(context).primaryColorLight),
        boxShadow: [
          BoxShadow(
              color: Theme.of(context).primaryColorLight.withOpacity(0.5),
              offset: Offset.fromDirection(3),
              blurRadius: 5,
              spreadRadius: 2),
        ],
      ),
      child: TextField(
          decoration: InputDecoration(
            hintText: "Search Country",
            prefixIcon: Icon(Icons.search),
          ),
          controller: controller,
          autofocus: false,
          onChanged: onChanged),
    );
  }
}
