import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'constant.dart';

class ProfileImage extends StatelessWidget {
  final double height, width;
  final Color color;
  final String picUrl;
  ProfileImage(
      {this.height = 100.0, this.width = 100.0, this.color = Colors.white,this.picUrl});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.red,
        image: DecorationImage(
          image: CachedNetworkImageProvider(picUrl != null ? picUrl : devMausam),
          fit: BoxFit.contain,
        ),
        border: Border.all(
          color: color,
          width: 3.0,
        ),
      ),
    );
  }
}