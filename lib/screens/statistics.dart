import 'package:corona_mobile_app/providers/settings.dart';
import 'package:corona_mobile_app/widgets/app-drawer.dart';
import 'package:corona_mobile_app/widgets/country-list.dart';
import 'package:corona_mobile_app/widgets/line-chart-tab.dart';
import 'package:corona_mobile_app/widgets/map-chart.dart';
import 'package:corona_mobile_app/widgets/pie-chart.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

class _Page {
  final Widget page;
  final Icon icon;
  final String title;

  _Page({
    @required this.page,
    @required this.icon,
    @required this.title,
  });
}

class StaticticsScreen extends StatefulWidget {
  StaticticsScreen({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _StaticticsScreenState createState() => _StaticticsScreenState();
}

class _StaticticsScreenState extends State<StaticticsScreen> {
  var _pageIndex = 0;
  final _pageController = PageController();

  final _lineChartTabController = LineChartTabController();

  @override
  Widget build(BuildContext context) {
    var isDarkMode = context.select((Settings value) => value.darkMode);

    final _pages = [
      _Page(
        page: CountryList(),
        icon: const Icon(Icons.list),
        title: "List",
      ),
      _Page(
        page: LineChartTab(controller: _lineChartTabController),
        icon: const Icon(Icons.multiline_chart),
        title: "Line Chart",
      ),
      // _Page(
      //   page: MapChart(),
      //   icon: const Icon(Icons.map),
      //   title: "Map",
      // ),
      _Page(
        page: PieChart(),
        icon: const Icon(Icons.pie_chart),
        title: "Pie Chart",
      ),
    ];

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: Icon(Icons.map),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  fullscreenDialog: true,
                  builder: (context) => MapChart(),
                ),
              );
            },
            tooltip: "Go to Map",
          ),
          if (_pageIndex == 1) ...[
            IconButton(
              icon: Icon(Icons.keyboard_return),
              // onPressed: () => setState(() => _selectedCountry = null),
              onPressed: _lineChartTabController.resetCountryState,
            ),
            IconButton(
                icon: Icon(Icons.more_vert),
                onPressed: _lineChartTabController.showCountryPicker),
          ]
        ],
      ),
      drawer: AppDrawer(),
      body: PageView(
        onPageChanged: (newPage) => setState(() => _pageIndex = newPage),
        controller: _pageController,
        children: _pages.map((e) => e.page).toList(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Theme.of(context).primaryColor,
        // type: BottomNavigationBarType.shifting,
        onTap: (value) => _pageController.jumpToPage(value),
        currentIndex: _pageIndex,
        selectedItemColor: isDarkMode
            ? Theme.of(context).toggleableActiveColor
            : Theme.of(context).accentColor,
        unselectedItemColor: Colors.white,
        items: _pages
            .map(
              (e) => BottomNavigationBarItem(
                backgroundColor: Theme.of(context).primaryColor,
                icon: e.icon,
                title: Text(e.title),
              ),
            )
            .toList(),
      ),
    );
  }
}
