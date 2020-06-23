import 'package:cloth_app/entity/look.dart';
import 'package:cloth_app/entity/tag.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {

  static DatabaseHelper _databaseHelper;    // Singleton DatabaseHelper
  static Database _database;                // Singleton Database

  String lookTable = 'look_table';
  String colId = 'id';
  String colImage = 'image';
  String colSeason = 'season';
  String colStatus = 'status';
  String colTags = 'tags';
  String colFavorite = 'favorite';

  String tagTable = 'tag_table';
  String colTagId = 'id';
  String colTagTitle = 'title';
  String colTagLook = 'look';

  int _customListSize;

  DatabaseHelper._createInstance(); // Named constructor to create instance of DatabaseHelper

  factory DatabaseHelper() {

    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper._createInstance(); // This is executed only once, singleton object
    }
    return _databaseHelper;
  }

  int countCustomLookList() => _customListSize;

  Future<Database> get database async {

    if (_database == null) {
      _database = await initializeDatabase();
    }
    return _database;
  }

  Future<Database> initializeDatabase() async {
    // Get the directory path for both Android and iOS to store database.
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'look_table_v7.db';

    // Open/create the database at a given path
    var looksDatabase = await openDatabase(path, version: 1, onCreate: _createLookDb);
    return looksDatabase;
  }

  void _createLookDb(Database db, int newVersion) async {
    await db.execute('CREATE TABLE $lookTable($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colImage TEXT, '
        '$colSeason TEXT, $colStatus TEXT, $colTags TEXT, $colFavorite BIT)');
    await db.execute('CREATE TABLE $tagTable($colTagId INTEGER PRIMARY KEY AUTOINCREMENT, $colTagTitle TEXT, $colTagLook TEXT)');
  }

  // Fetch Operation: Get all look objects from database
  Future<List<Map<String, dynamic>>> getLookMapList() async {
    Database db = await this.database;
    var result = await db.query(lookTable);
    return result;
  }

  Future<List<Map<String, dynamic>>> getSeasonLookMapList(String season) async {
    Database db = await this.database;
    var result = await db.rawQuery('SELECT * FROM $lookTable Where $colSeason = "$season";');
    return result;
  }

  Future<List<Map<String, dynamic>>> getStatusLookMapList(String status) async {
    Database db = await this.database;
    var result = await db.rawQuery('SELECT * FROM $lookTable Where $colStatus = "$status";');
    return result;
  }

  Future<List<Map<String, dynamic>>> getSeasonAndStatusLookMapList(String status, String season) async {
    Database db = await this.database;
    var result = await db.rawQuery('SELECT * FROM $lookTable Where $colSeason = "$season" AND $colStatus = "$status";');
    return result;
  }

  // Insert Operation: Insert a look object to database
  Future<int> insertLook(Look look) async {
    Database db = await this.database;
    var result = await db.insert(lookTable, look.toMap());
    return result;
  }

  // Update Operation: Update a look object and save it to database
  Future<int> updateLook(Look look) async {
    var db = await this.database;
    var result = await db.update(lookTable, look.toMap(), where: '$colId = ?', whereArgs: [look.id]);
    return result;
  }


  // Delete Operation: Delete a look object from database
  Future<int> deleteLook(int id) async {
    var db = await this.database;
    int result = await db.rawDelete('DELETE FROM $lookTable WHERE $colId = $id');
    return result;
  }

  // Get number of look objects in database
  Future<int> getCount() async {
    Database db = await this.database;
    List<Map<String, dynamic>> x = await db.rawQuery('SELECT COUNT (*) from $lookTable');
    int result = Sqflite.firstIntValue(x);
    return result;
  }

  // Get the 'Map List' [ List<Map> ] and convert it to 'look List' [ List<Look> ]
  Future<List<Look>> getLookList() async {

    var lookMapList = await getLookMapList(); // Get 'Map List' from database
    int count = lookMapList.length;         // Count the number of map entries in db table

    List<Look> lookList = List<Look>();
    // For loop to create a 'look List' from a 'Map List'
    for (int i = 0; i < count; i++) {
      lookList.add(Look.fromMapObject(lookMapList[i]));
    }

    return lookList;
  }

  Future<List<Look>> getLookFavoriteList() async {

    Database db = await this.database;
    var lookMapList = await db.rawQuery('SELECT * FROM $lookTable Where $colFavorite="1"');

    int count = lookMapList.length;         // Count the number of map entries in db table

    List<Look> lookList = List<Look>();
    // For loop to create a 'look List' from a 'Map List'
    for (int i = 0; i < count; i++) {
      lookList.add(Look.fromMapObject(lookMapList[i]));
    }

    return lookList;
  }

  Future<List<Look>> getCustomLookList(String season, String status) async {
    var lookMapList;
    if(season != null && status != null) {
      lookMapList = await getSeasonAndStatusLookMapList(status, season);
    } else if (season != null && status == null) {
      lookMapList = await getSeasonLookMapList(season);
    } else if (season == null && status != null) {
      lookMapList = await getStatusLookMapList(status);
    } else {
      lookMapList = await getLookMapList();
    }

    int count = lookMapList.length;

    List<Look> lookList = List<Look>();
    // For loop to create a 'look List' from a 'Map List'
    for (int i = 0; i < count; i++) {
      lookList.add(Look.fromMapObject(lookMapList[i]));
    }

    _customListSize = lookList.length;

    return lookList;
  }

  // Fetch Operation: Get all look objects from database
  Future<List<Map<String, dynamic>>> getTagMapList(String lookId) async {
    Database db = await this.database;
    var result = await db.rawQuery('SELECT * FROM $tagTable WHERE $colTagLook="$lookId"');
    return result;
  }

  // Insert Operation: Insert a look object to database
  Future<int> insertTag(Tag tag) async {
    Database db = await this.database;
    var result = await db.insert(tagTable, tag.toMap());
    return result;
  }

  // Update Operation: Update a look object and save it to database
  Future<int> updateTag(Tag tag) async {
    var db = await this.database;
    var result = await db.update(tagTable, tag.toMap(), where: '$colTagId = ?', whereArgs: [tag.id]);
    return result;
  }

  // Delete Operation: Delete a look object from database
  Future<int> deleteTag(int id) async {
    var db = await this.database;
    int result = await db.rawDelete('DELETE FROM $tagTable WHERE $colTagId = $id');
    return result;
  }

  // Get number of look objects in database
  Future<int> getTagCount() async {
    Database db = await this.database;
    List<Map<String, dynamic>> x = await db.rawQuery('SELECT COUNT (*) from $lookTable');
    int result = Sqflite.firstIntValue(x);
    return result;
  }

  // Get the 'Map List' [ List<Map> ] and convert it to 'Tag List' [ List<Tag> ]
  Future<List<Tag>> getLookTags(String lookId) async {

    var tagMapList = await getTagMapList(lookId);
    int count = tagMapList.length;
    List<Tag> tagList = List<Tag>();
    for (int i = 0; i < count; i++) {
      tagList.add(Tag.fromMapObject(tagMapList[i]));
    }

    return tagList;
  }

  Future<List<Tag>> getTagList() async {
    var tagMapList = await getAllTagMapList();

    int count = tagMapList.length;

    List<Tag> tagList = List<Tag>();
    for (int i = 0; i < count; i++) {
      tagList.add(Tag.fromMapObject(tagMapList[i]));
    }
    return tagList;
  }

  Future<List<String>> getTags() async {
    var tagList = await getTagList();

    int count = tagList.length;

    List<String> tags = List<String>();

    for (int i = 0; i < count; i++) {
      if (!tags.contains(tagList[i].title)) {
        tags.add(tagList[i].title);
      }
    }
    return tags;
  }

  Future<List<Map<String, dynamic>>> getAllTagMapList() async {
    Database db = await this.database;
    var result = await db.rawQuery('SELECT * FROM $tagTable');
    return result;
  }

  Future<List<Map<String, dynamic>>> getArrayTagMapList(List<String> tags) async {
    String tag = tags[0];
    String query = 'SELECT * FROM $tagTable WHERE $colTagTitle="$tag"';
    for (int i = 1; i < tags.length; i++) {
      tag = tags[i];
      query += ' OR WHERE $colTagTitle="$tag"';
    }
    Database db = await this.database;
    var result = await db.rawQuery(query);
    return result;
  }

  Future<List<Tag>> getCustomTagList(List<String> tags) async {
    var tagMapList;
    if (tags == null || tags.length == 0) {
      tagMapList = await getAllTagMapList();
    } else {
      tagMapList = await getArrayTagMapList(tags);
    }
    int count = tagMapList.length;
    List<Tag> tagList = List<Tag>();
    for (int i = 0; i < count; i++) {
      tagList.add(Tag.fromMapObject(tagMapList[i]));
    }

    return tagList;
  }

  Future<List<Look>> customLookList(String season, String status, List<String> tags) async {
    if (season == null && status == null && tags == null) {
      return  await getLookList();
    }

    if (tags == null || tags.length == 0) {
      return  await  getCustomLookList(season, status);
    }

    List<Look> lookList = await getCustomLookList(season, status);
    List<Tag> tagList = await getCustomTagList(tags);

    List<Look> looks = List<Look>();
    for(int i = 0; i < lookList.length; i++) {
      for(int j = 0; j < tagList.length; j++) {
        if (lookList[i].tags == tagList[j].look && !looks.contains(lookList[i])) {
          looks.add(lookList[i]);
        }
      }
    }
    return looks;
  }


}