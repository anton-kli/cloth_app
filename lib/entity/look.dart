class Look {

  int _id;
  String _image;
  String _season;
  String _status;
  String _tags;
  bool _favorite;

  //todo: lenguage lib
  static List<String> seasonList = ['Все', 'Деми', 'Весна', 'Лето', 'Осень', 'Зима'];
  static List<String> statusList = ['Новое', 'Регулярно ношу', 'Редко надеваю', 'Сторое'];


  Look(this._image, [this._tags, this._season, this._status, this._favorite] );

  Look.withId(this._id, this._image, [this._tags, this._season, this._status, this._favorite]);

  int get id => _id;

  String get season => _season;

  String get image => _image;

  String get status => _status;

  String get tags => _tags;

  bool get favorite => _favorite;

  set image(String newImage) {
    if (newImage.length <= 255) {
      this._image = newImage;
    }
  }
  set tags(String newTags) {
    if (newTags.length <= 255) {
      this._tags = newTags;
    }
  }

  set season(String newSeason) {
    if (newSeason.length <= 255) {
      this._season = newSeason;
    }
  }

  set status(String newStatus) {
    if (newStatus.length <= 255) {
      this._status = newStatus;
    }
  }

  set favorite(bool newFavorite) {
    this._favorite = newFavorite;
  }

  // Convert a Note object into a Map object
  Map<String, dynamic> toMap() {

    var map = Map<String, dynamic>();
    if (id != null) {
      map['id'] = _id;
    }
    map['image'] = _image;
    map['season'] = _season;
    map['status'] = _status;
    map['tags'] = _tags;
    map['favorite'] = _favorite ? 1 : 0;
    return map;
  }

  // Extract a Note object from a Map object
  Look.fromMapObject(Map<String, dynamic> map) {
    this._id = map['id'];
    this._image = map['image'];
    this._season = map['season'];
    this._status = map['status'];
    this._tags = map['tags'];
    this._favorite = map['date'] == 1;
  }
}