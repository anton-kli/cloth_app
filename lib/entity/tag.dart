class Tag {

  int _id;
  String _title;
  String _look;

  Tag(this._title, [this._look]);

  Tag.withId(this._id, this._title, [this._look]);

  int get id => _id;

  String get title => _title;

  String get look => _look;


  set title(String newTitle) {
    if (newTitle.length <= 255) {
      this._title = newTitle;
    }
  }
  set look(String newLook) {
    if (newLook.length <= 255) {
      this._look = newLook;
    }
  }

  // Convert a Note object into a Map object
  Map<String, dynamic> toMap() {

    var map = Map<String, dynamic>();
    if (id != null) {
      map['id'] = _id;
    }
    map['title'] = _title;
    map['look'] = _look;
    return map;
  }

  // Extract a Note object from a Map object
  Tag.fromMapObject(Map<String, dynamic> map) {
    this._id = map['id'];
    this._title = map['title'];
    this._look = map['look'];
  }
}
