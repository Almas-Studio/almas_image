import 'package:almas_image/src/operations/resolver.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'dart:ui' as ui;

class AlmasImage {
  final img.Image image;

  const AlmasImage(this.image);

  static Future<AlmasImage> fromImageProvider(
      ImageProvider imageProvider) async {
    final image = await resolveImage(imageProvider);
    return AlmasImage(image);
  }

  Size get size => Size(image.width.toDouble(), image.height.toDouble());

  List<int> get png => img.encodePng(image);
}
