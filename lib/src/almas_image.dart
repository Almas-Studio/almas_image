import 'dart:developer' as dev;
import 'dart:math';
import 'dart:typed_data';
import 'package:almas_image/src/operations/provider.dart';
import 'package:almas_image/src/operations/resolver.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'dart:ui' as ui;

import 'operations/size.dart';

class AlmasImage {
  final ImageProvider image;

  const AlmasImage(this.image);

  factory AlmasImage.image(img.Image image) {
    return AlmasImage(imageProviderFromImage(image));
  }

  factory AlmasImage.fromBytes(Uint8List bytes) {
    return AlmasImage(MemoryImage(bytes));
  }

  static Future<AlmasImage> fromUi(ui.Image image) async {
    return AlmasImage(await imageProviderFromUiImage(image));
  }

  Future<Size> get size => resolveSize(image);

  Future<ui.Image> get uiImage => resolveUiImage(image);

  Future<img.Image> get imgImage => resolveImage(image);

  Future<Uint8List> get png async => uiImageToPngBytes(await uiImage);

  Future<ByteBuffer> get buffer async => resolveBytes(await uiImage);

  Future<Uint8List> get rawBytes async {
    final b = await buffer;
    return b.asUint8List(0, b.lengthInBytes);
  }

  Future<ui.Codec> get codec async => ui.instantiateImageCodec(await rawBytes);

  Future<List<ui.FrameInfo>> get frames async {
    final c = await codec;
    return await Future.wait(
      List.generate(c.frameCount, (i) => c.getNextFrame()),
    );
  }

  Future<AlmasImage> crop(Rect cropBox) async {
    final croppedImage = img.copyCrop(
      await imgImage,
      cropBox.left.toInt(),
      cropBox.top.toInt(),
      cropBox.width.toInt(),
      cropBox.height.toInt(),
    );

    final provider = imageProviderFromImage(croppedImage);
    return AlmasImage(provider);
  }

  Future<AlmasImage> flipHorizontally() async {
    var recorder = ui.PictureRecorder();
    var uimg = await uiImage;
    var canvas = ui.Canvas(recorder);
    final double dx = -(uimg.width / 2.0);
    canvas.translate(-dx, 0);
    canvas.scale(-1, 1);
    canvas.translate(dx, 0.0);
    canvas.drawImage(uimg, Offset.zero, Paint());
    final pic = recorder.endRecording();
    uimg = await pic.toImage(uimg.width, uimg.height);
    final provider = await imageProviderFromUiImage(uimg);
    return AlmasImage(provider);
  }

  Future<AlmasImage> flipVertically() async {
    var recorder = ui.PictureRecorder();
    var uimg = await uiImage;
    var canvas = ui.Canvas(recorder);
    final double dy = -(uimg.height / 2.0);
    canvas.translate(0, -dy);
    canvas.scale(1, -1);
    canvas.translate(0.0, dy);
    canvas.drawImage(uimg, Offset.zero, Paint());
    final pic = recorder.endRecording();
    uimg = await pic.toImage(uimg.width, uimg.height);
    final provider = await imageProviderFromUiImage(uimg);
    return AlmasImage(provider);
  }

  Future<AlmasImage> resize(Size size) async {
    return AlmasImage(ResizeImage(
      image,
      width: size.width.toInt(),
      height: size.height.toInt(),
      allowUpscaling: true,
    ));
  }
}
