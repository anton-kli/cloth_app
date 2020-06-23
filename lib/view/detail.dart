import 'dart:async';
import 'dart:io';
import 'package:cloth_app/entity/tag.dart';
import 'package:cloth_app/service/dbHandler.dart';
import 'package:cloth_app/entity/look.dart';
import 'package:cloth_app/view/home.dart';
import 'package:cloth_app/widgets.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as Path;
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';

class LookDetail extends StatefulWidget {

  final Look look;

  LookDetail(this.look);

  @override
  State<StatefulWidget> createState() {

    return LookDetailState(this.look);
  }
}

class LookDetailState extends State<LookDetail> {

  File _imageFile;
  int selectedValue;

  LookDetailState(this.look);

  DatabaseHelper helper = DatabaseHelper();

  Look look;

  List<String> _seasonList = Look.seasonList;
  List<String> _statusList = Look.statusList;

  Tag lookTag = Tag('');
  List<Tag> tagList;

  Color mainColor;

  OutlineInputBorder borderStyle = OutlineInputBorder(
    borderSide: BorderSide(color: Colors.black),
    borderRadius: BorderRadius.circular(30.0),
  );

  TextEditingController imageController = TextEditingController();
  TextEditingController seasonController = TextEditingController();
  TextEditingController statusController = TextEditingController();
  TextEditingController tagsController = TextEditingController();

  String _tag = '';

  @override
  Widget build(BuildContext context) {

    mainColor = Theme.of(context).accentColor;

    if (look.id == null) {
      look.favorite = false;
    }
    if (tagList == null) {
      tagList = List<Tag>();
      _updateTagListView();
    }

    seasonController.text = look.season;
    statusController.text = look.status;
    tagsController.text = _tag;

    return Scaffold(
      appBar: AppBar(
        title: appTitle(),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.chevron_left,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context, true);
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
        child: ListView(
          children: <Widget>[
            Container(
                margin: EdgeInsets.only(left: 10, right: 10, bottom: 15),
                child: GestureDetector(
                  onTap: () {
                    _showImageDialog();
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(25),
                    child: _isEmpty(look.image)
                        ? Container(
                          height: 300,
                          color: Colors.grey[200],
                          child: Center(
                            child: Icon(Icons.add, size: 64, color: Colors.grey,),
                          ),
                        )
                        : Stack(
                      alignment: AlignmentDirectional.bottomEnd,
                      children: <Widget>[
                        Image(
                          image: NetworkImage(look.image),
                        ),
                        IconButton(
                          icon: _favoriteIcon(),
                          onPressed: () {
                            _makeFavorite();
                          },
                        ),
                      ],
                    ),
                  ),
                ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: TextField(
                onTap: () {_showSeasonPicker();},
                readOnly: true,
                controller: seasonController,
                style: textStyle(),
                onChanged: (value) {_updateSeason();},
                decoration: InputDecoration(
                  labelText: 'Сезон',
                  labelStyle: textStyle(),
                  focusedBorder: activeBorderStyle(context),
                  border: borderStyle,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: TextField(
                onTap: () {_showStatusPicker();},
                readOnly: true,
                cursorColor: Colors.black,
                controller: statusController,
                style: textStyle(),
                onChanged: (value) {_updateStatus();},
                decoration: InputDecoration(
                  labelText: 'Статус',
                  labelStyle: textStyle(),
                  focusedBorder: activeBorderStyle(context),
                  border: borderStyle,
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: TextField(
                cursorColor: Colors.black,
                controller: tagsController,
                style: textStyle(),
                onChanged: (value) {_updateTagField();},
                decoration: InputDecoration(
                  labelText: 'Тэги',
                  labelStyle: textStyle(),
                  focusedBorder: activeBorderStyle(context),
                  border: borderStyle,
                  suffix: IconButton(
                    highlightColor: Colors.white,
                    splashColor: Colors.white,
                    icon: Icon(Icons.check),
                    onPressed: () {
                      _updateTags();
                      debugPrint('check pressed');
                    },
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Wrap(
                runAlignment: WrapAlignment.start,
                spacing: 8,
                runSpacing: 4,
                direction: Axis.horizontal,
                children: tagList.length == 0 ? [Container()] : _listTagsView(),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 10, bottom: 20, left: 15, right: 15),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: FlatButton(
                      padding: EdgeInsets.symmetric(vertical: 15),
                      highlightColor: mainColor,
                      splashColor: mainColor,
                      color: mainColor,
                      shape: activeBorderStyle(context),
                      child: Text(
                        'Save',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          _save();
                        });
                      },
                    ),
                  ),
                  Container(width: 15),
                  Expanded(
                    child: FlatButton(
                      padding: EdgeInsets.symmetric(vertical: 15),
                      highlightColor: mainColor,
                      splashColor: mainColor,
                      color: mainColor,
                      shape: activeBorderStyle(context),
                      child: Text(
                        'Delete',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          _delete();
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Icon _favoriteIcon() {
    return Icon(
    look.favorite
    ? Icons.favorite
        : Icons.favorite_border,
    color: look.favorite
    ? Colors.red
        : Colors.black,
    );
  }

  void moveToHomeScreen() {
    Navigator.push(context, MaterialPageRoute(builder: (_) {
      return HomePage();
    }));
  }

  void _updateSeason(){
    look.season = seasonController.text;
  }

  void _updateStatus(){
    look.status = statusController.text;
  }

  void _updateTagField() {
    lookTag.title = tagsController.text;
  }

  Future<void> _updateTags() async {
    Uuid uuid = Uuid();
    if (look.tags == null || look.tags == '') {
      look.tags = uuid.v4();
    }
    lookTag.look = look.tags;
    debugPrint(lookTag.toString());
    if (lookTag.id != null) {
      helper.updateTag(lookTag);
    } else {
      helper.insertTag(lookTag);
    }
    setState(() {
      _tag = '';
      this.lookTag = Tag('');
      _updateTagListView();
    });
  }

  void _deleteTag(int id) async {
    helper.deleteTag(id);
    setState(() {
      _updateTagListView();
    });
  }

  bool _isEmpty(String urlPath) {
    return (urlPath == null) || (urlPath == '') || (urlPath == ' ');
  }

  void _makeFavorite() async {
    debugPrint('makeFavorite');
    if (look.id != null) {
      setState(() {
        look.favorite = !look.favorite;
        debugPrint(look.favorite.toString());
      });
      helper.updateLook(look);
    }
  }

  void _save() async {
    moveToHomeScreen();
    if (look.favorite == null) {
      look.favorite = false;
    }
    int result;
    if (look.id != null) {  // Case 1: Update operation
      result = await helper.updateLook(look);
    } else { // Case 2: Insert Operation
      result = await helper.insertLook(look);
    }
    if (result != 0) {  // Success
      _showAlertDialog('Status', 'Look Saved Successfully');
    } else {  // Failure
      _showAlertDialog('Status', 'Problem Saving Look');
    }
  }

  void _delete() async {
    moveToHomeScreen();
    if (look.id == null) {
      _showAlertDialog('Status', 'No Look was deleted');
      return;
    }
    int result = await helper.deleteLook(look.id);
    if (result != 0) {
      _showAlertDialog('Status', 'Look Deleted Successfully');
    } else {
      _showAlertDialog('Status', 'Error Occured while Deleting Look');
    }
  }

  Future _getImage(bool isCamera) async {
    File image;
    if(isCamera) {
      image = await ImagePicker.pickImage(source: ImageSource.camera);
    } else {
      image = await ImagePicker.pickImage(source: ImageSource.gallery);
    }
    setState(() {
      _imageFile = image;
    });
    _uploadFile();
  }

  Future _uploadFile() async {
    StorageReference storageReference = FirebaseStorage.instance
        .ref()
        .child('looks/${Path.basename(_imageFile.path)}');
    StorageUploadTask uploadTask = storageReference.putFile(_imageFile);
    await uploadTask.onComplete;
    storageReference.getDownloadURL().then((fileURL) {
      setState(() {
        look.image = fileURL;
      });
    });
  }

  void _showAlertDialog(String title, String message) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text(message),
        );
      },
    );
  }

  _showSeasonPicker() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return CupertinoPicker(
          backgroundColor: Colors.white,
          onSelectedItemChanged: (value) {
            setState(() {
              look.season = _seasonList[value];
            });
          },
          itemExtent: 36.0,
          children: _seasonList.map((String season) => Text(season)).toList()
        );
      },
    );
  }

  _showStatusPicker() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return CupertinoPicker(
          backgroundColor: Colors.white,
          onSelectedItemChanged: (value) {
            setState(() {
              look.status = _statusList[value];
            });
          },
          itemExtent: 36.0,
          children: _statusList.map((String season) => Text(season)).toList()
        );
      },
    );
  }

  void _showImageDialog() {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) {
        return CupertinoActionSheet(
          title: Text('Add photo'),
          message: Text('Please select the best dessert from the options below.'),
          actions: <Widget>[
            CupertinoActionSheetAction(
              child: Text('Camera'),
              onPressed: () {
                _getImage(true);
                Navigator.pop(context);
              },
            ),
            CupertinoActionSheetAction(
              child: Text('Gallery'),
              onPressed: () {
                _getImage(false);
                Navigator.pop(context);
              },
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            isDefaultAction: true,
            child: Text(
              'Cancel',
              style: TextStyle(
                color: CupertinoColors.systemRed,
              ),
            ),
            onPressed: () {Navigator.pop(context);},
          ),
        );
      },
    );
  }

  List<Widget> _listTagsView() {
    List<Widget> result = List();
    if (this.tagList.length != 0) {
      for(int i = 0; i < this.tagList.length; i++) {
        result.add(_tagWidget(tagList[i]));
      }
    }
    return result;
  }

  Widget _tagWidget(Tag tag) {
    return Chip(
      label: Text(tag.title),
      deleteIcon: Icon(Icons.cancel),
      onDeleted: () {
        _deleteTag(tag.id);
      },
    );
  }

  void _updateTagListView() {
    final Future<Database> dbFuture = helper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<Tag>> tagListFuture = helper.getLookTags(look.tags);
      tagListFuture.then((tagList) {
        setState(() {
          this.tagList = tagList;
        });
      });
    });
  }
}