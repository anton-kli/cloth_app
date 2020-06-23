import 'dart:async';

import 'package:cloth_app/bottomWidget.dart';
import 'package:cloth_app/entity/look.dart';
import 'package:cloth_app/service/dbHandler.dart';
import 'package:cloth_app/view/widgets/card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:sqflite/sqflite.dart';

import '../widgets.dart';

class CustomLookListPage extends StatefulWidget {

  String _season;
  String _status;
  List<String> _tags;

  CustomLookListPage(this._season, this._status, this._tags);

  @override
  _CustomLookListPageState createState() => _CustomLookListPageState(_season, _status, _tags);
}

class _CustomLookListPageState extends State<CustomLookListPage> {

  String season;
  String status;
  List<String> tags;

  _CustomLookListPageState(this.season, this.status, this.tags);

  List<Look> lookList;

  DatabaseHelper helper = DatabaseHelper();

  void updateListView() {
    final Future<Database> dbFuture = helper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<Look>> lookListFuture = helper.customLookList(season, status, tags);
      lookListFuture.then((lookList) {
        setState(() {
          this.lookList = lookList;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('Custom Page');
    debugPrint(season);
    if (lookList == null) {
      lookList = List<Look>();
      updateListView();
    }
    return  Scaffold(
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
      body: detPageView(),
      bottomNavigationBar: bottomBar(context, 0)
    );
  }

  List<Widget> _listTagsView() {
    List<Widget> result = List();
    if (season != null) {
      result.add(_tagWidget(season));
    }
    if (status != null) {
      result.add(_tagWidget(status));
    }
    if (this.tags.length != 0) {
      for(int i = 0; i < this.tags.length; i++) {
        result.add(_tagWidget(tags[i]));
      }
    }
    return result;
  }

  Widget _tagWidget(String tag) {
    return Chip(
      label: Text(tag),
      deleteIcon: Icon(Icons.cancel),
      onDeleted: () {
        _deleteFilter(tag);
      },
    );
  }

  _deleteFilter(String filter) {
    if (filter == season) {
      setState(() {
        season = null;
      });
    } else if (filter == status) {
      setState(() {
        status = null;
      });
    } else if (tags.contains(filter)) {
      setState(() {
        tags.remove(filter);
      });
    }
    updateListView();
  }

  CustomScrollView detPageView() {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter (
          child: Container(
            padding: EdgeInsets.only(left: 15, right: 15, top: 10),
            child: Wrap(
              runAlignment: WrapAlignment.start,
              spacing: 8,
              runSpacing: 4,
              direction: Axis.horizontal,
              children: tags.length == 0 ? [Container()] : _listTagsView(),
            ),
          ),
        ),
        getGridView(context, lookList)
      ],
    );
  }
}
