import 'dart:typed_data';
import 'package:almas_image/src/operations/resolver.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'dart:ui' as ui;

import 'operations/size.dart';

class AlmasImage {
  final ImageProvider image;

  const AlmasImage(this.image);

  Future<Size> get size => resolveSize(image);

  Future<ui.Image> get uiImage => resolveUiImage(image);

  Future<Uint8List> get png async => uiImageToPngBytes(await uiImage);
}
