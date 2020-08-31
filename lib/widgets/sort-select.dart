import 'package:flutter/material.dart';

class SortSelectItem {
  final int value;
  final String option;

  SortSelectItem(this.value, this.option);
}

class SortSelect extends StatelessWidget {
  final List<SortSelectItem> items;
  final String title;
  final void Function(int) onSelect;

  SortSelect({
    @required this.items,
    @required this.title,
    @required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        border: Border(
          // bottom: BorderSide(color: Theme.of(context).primaryColor, width: 2),
          left: BorderSide(color: Theme.of(context).primaryColor, width: 1),
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton(
          hint: Text(
            title,
            textAlign: TextAlign.center,
          ),
          items: items
              .map((e) =>
                  DropdownMenuItem(value: e.value, child: Text(e.option)))
              .toList(),
          onChanged: onSelect,
        ),
      ),
    );
  }
}
