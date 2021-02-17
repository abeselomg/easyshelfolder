import 'constant.dart';
import 'category.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ProfileCategories extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 10,right: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          for (Catg catg in listProfileCategories)
            Category(
              catg: catg,
            )
        ],
      ),
    );
  }
}