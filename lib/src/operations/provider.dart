import 'dart:typed_data';

import 'package:almas_image/src/operations/resolver.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'package:image/image.dart' as img;

ImageProvider imageProviderFromImage(img.Image image) {
  final png = img.encodePng(image);
  return MemoryImage(Uint8List.fromList(png));
}

Future<ImageProvider> imageProviderFromUiImage(ui.Image image) async {
  final png = await uiImageToPngBytes(image);
  return MemoryImage(png);
}