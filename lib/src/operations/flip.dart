import 'package:almas_image/src/operations/provider.dart';
import 'package:almas_image/src/operations/resolver.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;

Future<ImageProvider> flipVertical(ImageProvider image) async{
  final src = await resolveImage(image);
  final flipped = img.flipVertical(src);
  return imageProviderFromImage(flipped);
}

Future<ImageProvider> flipHorizontal(ImageProvider image) async {
  final src = await resolveImage(image);
  final flipped = img.flipHorizontal(src);
  return imageProviderFromImage(flipped);
}