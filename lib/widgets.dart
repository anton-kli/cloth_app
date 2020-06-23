import 'package:cloth_app/view/widgets/card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'entity/look.dart';

const Color MAIN_ACCENT_COLOR = Color.fromRGBO(250, 180, 200, 1);

Text appTitle() {
  return Text(
      'cloth'
  );
}

OutlineInputBorder activeBorderStyle(BuildContext context) {
  return OutlineInputBorder(
    borderSide: BorderSide(color: Theme.of(context).accentColor, width: 2),
    borderRadius: BorderRadius.circular(30.0),
  );
}

TextStyle textStyle() {
  return TextStyle(
    color: Colors.black,
  );
}

SliverStaggeredGrid getGridView(BuildContext context, List<Look> lookList) {
  return SliverStaggeredGrid.countBuilder(
    crossAxisCount: 2,
    staggeredTileBuilder: (int index) => StaggeredTile.fit(1),
    itemCount: lookList.length,
    itemBuilder: (context, index) {
      return ClipRRect(
        child: LookCard(lookList[index]),
      );
    },
  );
}
