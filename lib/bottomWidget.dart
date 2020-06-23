
import 'package:cloth_app/view/detail.dart';
import 'package:cloth_app/view/favoritePage.dart';
import 'package:cloth_app/view/home.dart';
import 'package:flutter/material.dart';

import 'entity/look.dart';

const double BIG_NAV_ICON = 30;
const double LTL_NAV_ICON = 24;

void navigatorHome(BuildContext context) {
  Navigator.push(context, MaterialPageRoute(builder: (_) {
    return HomePage();
  }));
}

void navigatorFavorite(BuildContext context) {
  Navigator.push(context, MaterialPageRoute(builder: (_) {
    return FavoriteLookListPage();
  }));
}

void navigatorDetail(BuildContext context) async {
  Navigator.push(context, MaterialPageRoute(builder: (_) {
    return LookDetail(Look(''));
  }));
}

IconButton activeHome(BuildContext context) {
  return IconButton(
    icon: Icon(Icons.home, color: Theme.of(context).accentColor),
    iconSize: BIG_NAV_ICON,
    onPressed: () {navigatorHome(context);},
  );
}

IconButton passiveHome(BuildContext context) {
  return IconButton(
    icon: Icon(Icons.home),
    iconSize: LTL_NAV_ICON,
    onPressed: () {navigatorHome(context);},
  );
}

IconButton activeFavorite(BuildContext context) {
  return IconButton(
    icon: Icon(Icons.favorite, color: Theme.of(context).accentColor),
    iconSize: BIG_NAV_ICON,
    onPressed: () {navigatorFavorite(context);},
  );
}

IconButton passiveFavorite(BuildContext context) {
  return IconButton(
    icon: Icon(Icons.favorite_border),
    iconSize: LTL_NAV_ICON,
    onPressed: () {navigatorFavorite(context);},
  );
}


Widget bottomBar(BuildContext context, int activePage) {
  return Container(
    color: Colors.white,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Expanded(
          flex: 1,
          child: SizedBox(),
        ),
        Expanded(
          flex: 3,
          child: activePage == 1
              ? activeHome(context)
              : passiveHome(context),
        ),
        Expanded(
          flex: 3,
          child: IconButton(
            icon: Icon(Icons.center_focus_weak),
            iconSize: LTL_NAV_ICON,
            onPressed: () {navigatorDetail(context);},
          ),
        ),
        Expanded(
          flex: 3,
          child: activePage == 2
              ? activeFavorite(context)
              : passiveFavorite(context),
        ),
        Expanded(
          flex: 1,
          child: SizedBox(),
        ),
      ],
    ),
  );
}