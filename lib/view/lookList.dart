import 'dart:async';

import 'package:cloth_app/entity/look.dart';
import 'package:cloth_app/service/dbHandler.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import '../widgets.dart';

class LookListPage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return LookListPageState();
  }
}

class LookListPageState extends State<LookListPage> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Look> lookList;

  @override
  Widget build(BuildContext context) {
    if (lookList == null) {
      lookList = List<Look>();
      updateListView();
    }

    return CustomScrollView(
      slivers: [
        getGridView(context, lookList),
      ],
    );
  }

  void updateListView() {
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<Look>> lookListFuture = databaseHelper.getLookList();
      lookListFuture.then((lookList) {
        setState(() {
          this.lookList = lookList;
        });
      });
    });
  }
}