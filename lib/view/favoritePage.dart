import 'dart:async';

import 'package:cloth_app/bottomWidget.dart';
import 'package:cloth_app/entity/look.dart';
import 'package:cloth_app/service/dbHandler.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import '../widgets.dart';

class FavoriteLookListPage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return FavoriteLookListPageState();
  }
}

class FavoriteLookListPageState extends State<FavoriteLookListPage> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Look> lookList;

  @override
  Widget build(BuildContext context) {
    if (lookList == null) {
      lookList = List<Look>();
      updateListView();
    }
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.chevron_left,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context, true);
          },
        ),
        title: appTitle(),
        centerTitle: true,
      ),
        body: CustomScrollView(
          slivers: [
            getGridView(context, lookList),
          ],
        ),
        bottomNavigationBar: bottomBar(context, 2)
    );
  }

  void updateListView() {
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<Look>> lookListFuture = databaseHelper.getLookFavoriteList();
      lookListFuture.then((lookList) {
        setState(() {
          this.lookList = lookList;
        });

      });
    });
  }
}