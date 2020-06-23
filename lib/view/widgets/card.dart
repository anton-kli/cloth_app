import 'package:cloth_app/view/detail.dart';
import 'package:cloth_app/entity/look.dart';
import 'package:flutter/material.dart';

class LookCard extends StatelessWidget {

  Look look;

  LookCard(this.look);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: GestureDetector(
          child: Image.network(
            look.image,
            fit: BoxFit.cover,
          ),
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (_) {
              return LookDetail(look);
            }));
          },
        ),
      ),
    );
  }
}
