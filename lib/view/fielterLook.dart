import 'dart:async';

import 'package:cloth_app/entity/look.dart';
import 'package:cloth_app/service/dbHandler.dart';
import 'package:cloth_app/widgets.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import 'customLookList.dart';

class FilterPage extends StatefulWidget {

  @override
  _FilterPageState createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {

  DatabaseHelper helper = DatabaseHelper();

  List<String> _seasonList = Look.seasonList;
  List<String> _statusList = Look.statusList;
  List<String> _tagList;


  Color _activeColor;
  Color _inactiveColor;

  String season = null;
  String status = null;
  List<String> tags = List<String>();

  uploadTags()  {
    final Future<Database> dbFuture = helper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<String>> tagsFuture = helper.getTags();
      tagsFuture.then((tagList) {
        setState(() {
          this._tagList = tagList;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    uploadTags();

    _activeColor = Theme.of(context).accentColor;
    _inactiveColor = Colors.white.withOpacity(0);

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
        actions: <Widget>[
          FlatButton(
            textColor: _activeColor,
            child: Text('Найти'),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) {
                return CustomLookListPage(season, status, tags);
              }));
            },
          )
        ],
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 15, bottom: 10),
              child: Center(
                child: Text('Сезон'),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
              child: Container(
                height: 1,
                color: Colors.grey,
              ),
            ),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 8,
              children: _seasonList.map((String name) => FlatButton(
                color: season == name ? _activeColor : _inactiveColor,
                shape: activeBorderStyle(context),
                textColor: season == name ? Colors.white : Colors.black,
                child: Text(name),
                onPressed: () {
                  season == name ? season = null : season = name;
                },
              )).toList(),
            ),
            Padding(
              padding: EdgeInsets.only(top: 25, bottom: 10),
              child: Center(
                child: Text('Статус'),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25, vertical: 5),
              child: Container(
                height: 1,
                color: Colors.grey,
              ),
            ),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 8,
              children: _statusList.map((String name) => FlatButton(
                color: status == name ? _activeColor : _inactiveColor,
                shape: activeBorderStyle(context),
                textColor: status == name ? Colors.white : Colors.black,
                child: Text(name),
                onPressed: () {
                  status == name ? status = null : status = name;
                },
              )).toList(),
            ),
            Padding(
              padding: EdgeInsets.only(top: 25, bottom: 10),
              child: Center(
                child: Text('Тэги'),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25, vertical: 5),
              child: Container(
                height: 1,
                color: Colors.grey,
              ),
            ),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 8,
              children: _tagList.map((String title) => FlatButton(
                color: tags.contains(title) ? _activeColor : _inactiveColor,
                shape: activeBorderStyle(context),
                textColor: tags.contains(title) ? Colors.white : Colors.black,
                child: Text(title),
                onPressed: () {
                  tags.contains(title) ? tags.remove(title) : tags.add(title);
                },
              )).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
