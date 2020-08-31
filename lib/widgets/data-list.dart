import 'package:flutter/material.dart';

class DataList<T> extends StatelessWidget {
  final List<T> data;
  final List<String> headerData;

  final List<Widget> Function(List<T> data, int index) rowBuilder;
  final void Function(T item) onItemTabbed;

  DataList({
    @required this.data,
    @required this.headerData,
    @required this.rowBuilder,
    this.onItemTabbed,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          ListTile(
            title: Row(
              children: headerData
                  .map(
                    (title) => Expanded(
                        child: Text(
                      title,
                      style: _Styles.listHeader,
                      textAlign: TextAlign.center,
                    )),
                  )
                  .toList(),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(vertical: 5),
              itemBuilder: (ctx, index) {
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 5),
                  child: ListTile(
                    onTap: onItemTabbed != null ? () => onItemTabbed(data[index]) : null,
                    title: Row(
                      children: rowBuilder(data, index),
                    ),
                  ),
                );
              },
              itemCount: data.length,
            ),
          ),
        ],
      ),
    );
  }
}

class _Styles {
  static const listHeader = TextStyle(
      fontSize: 20, fontStyle: FontStyle.italic, fontWeight: FontWeight.bold);
}
