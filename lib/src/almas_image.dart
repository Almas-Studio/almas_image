import 'dart:async';
import 'dart:typed_data';
import 'package:almas_image/almas_image.dart';
import 'package:almas_image/src/operations/provider.dart';
import 'package:almas_image/src/operations/resolver.dart';
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

  Future<ui.Picture> get picture async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    canvas.drawImage(await uiImage, Offset.zero, Paint());
    return recorder.endRecording();
  }

  Future<Uint8List> get bytes async {
    final completer = Completer<Uint8List>();
    Future<ui.Codec> _c(bytes,
        {allowUpscaling, cacheHeight, cacheWidth}) async {
      completer.complete(bytes);
      return ui.instantiateImageCodec(bytes);
    }

    image.load(image, _c);
    return completer.future;
  }

  Future<ui.Codec> get codec async {
    final completer = Completer<ui.Codec>();
    Future<ui.Codec> _c(bytes,
        {allowUpscaling, cacheHeight, cacheWidth}) async {
      final codec = await ui.instantiateImageCodec(bytes);
      completer.complete(codec);
      return codec;
    }

    image.load(image, _c);
    return completer.future;
  }

  Future<List<ui.FrameInfo>> get frames async {
    final c = await codec;
    return await Future.wait(
      List.generate(c.frameCount, (i) => c.getNextFrame()),
    );
  }

  Future<int> get frameCount async => (await codec).frameCount;

  Future<bool> get animated async => (await frameCount) > 1;

  Future<AlmasImage> crop(Rect cropBox) async {
    var recorder = ui.PictureRecorder();
    var uimg = await uiImage;
    var canvas = ui.Canvas(recorder);
    canvas.drawImageRect(uimg, cropBox,
        Rect.fromLTWH(0, 0, cropBox.width, cropBox.height), Paint());
    final pic = recorder.endRecording();
    uimg = await pic.toImage(cropBox.width.toInt(), cropBox.height.toInt());
    final provider = await imageProviderFromUiImage(uimg);
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

  Future<AlmasImage> applyImageFilter(ui.ImageFilter filter) async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    final uimg = await uiImage;
    canvas.drawImage(uimg, Offset.zero, Paint()..imageFilter = filter);
    final picture = recorder.endRecording();
    final image = await picture.toImage(uimg.width, uimg.height);
    return await AlmasImage.fromUi(image);
  }

  Future<AlmasImage> applyColorFilter(ui.ColorFilter filter) async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    final uimg = await uiImage;
    canvas.drawImage(uimg, Offset.zero, Paint()..colorFilter = filter);
    final picture = recorder.endRecording();
    final image = await picture.toImage(uimg.width, uimg.height);
    return await AlmasImage.fromUi(image);
  }

  Future<AlmasImage> applyMaskFilter(ui.MaskFilter filter) async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    final uimg = await uiImage;
    canvas.drawImage(uimg, Offset.zero, Paint()..maskFilter = filter);
    final picture = recorder.endRecording();
    final image = await picture.toImage(uimg.width, uimg.height);
    return await AlmasImage.fromUi(image);
  }

  Future<AlmasImage> applyShader(ui.Shader shader) async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    final uimg = await uiImage;
    canvas.drawImage(uimg, Offset.zero, Paint()..shader = shader);
    final picture = recorder.endRecording();
    final image = await picture.toImage(uimg.width, uimg.height);
    return await AlmasImage.fromUi(image);
  }
}
