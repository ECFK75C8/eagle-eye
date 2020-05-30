import 'package:flutter/material.dart';

import './capture_screen.dart';
import './history_screen.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, Object>> _pages = [];
  var _selectedPageIndex = 0;

  @override
  void initState() {
    super.initState();
    _pages = [
      {
        'screen': CaptureScreen(),
        'title': 'Capture',
      },
      {
        'screen': HistoryScreen(),
        'title': 'History',
      }
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
        _pages[_selectedPageIndex]['title'],
      )),
      body: _pages[_selectedPageIndex]['screen'],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Theme.of(context).primaryColor,
        type: BottomNavigationBarType.shifting,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.camera),
            title: Text('Capture'),
            backgroundColor: Theme.of(context).primaryColor,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            title: Text('History'),
            backgroundColor: Theme.of(context).primaryColor,
          )
        ],
        currentIndex: _selectedPageIndex,
        onTap: (index) {
          setState(() {
            _selectedPageIndex = index;
          });
        },
      ),
    );
  }
}
