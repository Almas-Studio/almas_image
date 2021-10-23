import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;

ImageProvider imageProviderFromImage(img.Image image) {
  final png = img.encodePng(image);
  return MemoryImage(Uint8List.fromList(png));
}