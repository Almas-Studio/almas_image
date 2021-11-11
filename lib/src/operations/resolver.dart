import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;

void resolve(ImageProvider img, ImageListener listener) {
  final stream = img.resolve(ImageConfiguration());
  late ImageStreamListener streamListener;
  streamListener = ImageStreamListener((info, _) {
    stream.removeListener(streamListener);
    listener(info, _);
  });
  stream.addListener(streamListener);
}

Future<Uint8List> uiImageToPngBytes(ui.Image image) async {
  final bytes = (await image.toByteData(format: ui.ImageByteFormat.png))!;
  return bytes.buffer.asUint8List(0, bytes.buffer.lengthInBytes);
}

Future<Uint8List> uiImageToRGBABytes(ui.Image image) async {
  final bytes = (await image.toByteData(format: ui.ImageByteFormat.rawRgba))!;
  return bytes.buffer.asUint8List(0, bytes.buffer.lengthInBytes);
}

Future<ui.Image> resolveUiImage(ImageProvider imageProvider) async {
  final Completer<ui.Image> completer = Completer();

  resolve(
    imageProvider,
    (info, synchronousCall) => completer.complete(info.image),
  );

  return completer.future;
}

Future<img.Image> resolveImage(ImageProvider imageProvider) async {
  final loadedImage = await resolveUiImage(imageProvider);
  final bytes = await uiImageToRGBABytes(loadedImage);

  final imgimg = img.Image.fromBytes(
    loadedImage.width,
    loadedImage.height,
    bytes,
  );

  return imgimg;
}
