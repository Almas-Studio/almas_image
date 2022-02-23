import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:almas_image/src/operations/resolver.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;

Future<Size> resolveSize(ImageProvider image) async {
  final completer = Completer<Size>();

  resolve(image, (info, _) {
    final size = Size(
      info.image.width.toDouble(),
      info.image.height.toDouble(),
    );
    completer.complete(size);
  });

  return completer.future;
}

Future<ui.Image> resizeUiImage(ui.Image image, int width, int height) async {
  var bytes = await uiImageToPngBytes(image);
  var png = img.decodePng(bytes);
  var resized = img.copyResize(png!, width: width, height: height);
  var resizedBytes = img.encodePng(resized);
  var codec = await ui.instantiateImageCodec(Uint8List.fromList(resizedBytes),
      targetWidth: width, targetHeight: height);
  var frame = await codec.getNextFrame();
  return frame.image;
}

class ImageResizeParams {
  final img.Image image;
  final Size size;

  ImageResizeParams(this.image, this.size);
}

Future<img.Image> resizeImgImage(ImageResizeParams params) async {
  return img.copyResize(
    params.image,
    width: params.size.width.toInt(),
    height: params.size.height.toInt(),
  );
}
