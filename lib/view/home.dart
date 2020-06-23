
import 'package:cloth_app/view/fielterLook.dart';
import 'package:cloth_app/view/lookList.dart';
import 'package:cloth_app/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../bottomWidget.dart';

class HomePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.trip_origin, color: Colors.white),
        centerTitle: true,
        title: appTitle(),
        actions: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(horizontal: 4),
            child: IconButton(
              icon: Icon(Icons.filter_list),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) {
                  return FilterPage();
                }));
              }
            ),
          ),
        ],
      ),
      body: LookListPage(),
      bottomNavigationBar: bottomBar(context, 1)
    );
  }
}


