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

  Future<Size> get size => resolveSize(image);

  Future<ui.Image> get uiImage => resolveUiImage(image);

  Future<img.Image> get imgImage => resolveImage(image);

  Future<Uint8List> get png async => uiImageToPngBytes(await uiImage);

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
    final flippedImg = await compute(img.flipHorizontal, await imgImage);
    final provider = imageProviderFromImage(flippedImg);
    return AlmasImage(provider);
  }

  Future<AlmasImage> flipVertically() async {
/*    if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
      // gpu
      var bitmap = await Bitmap.fromProvider(image);
      bitmap = bitmap.apply(BitmapFlip.vertical());
      final flippedImg = await bitmap.buildImage();
      final provider = await imageProviderFromUiImage(flippedImg);
      return AlmasImage(provider);
    }*/
    // cpu
    final flippedImg = await compute(img.flipVertical, await imgImage);
    final provider = imageProviderFromImage(flippedImg);
    return AlmasImage(provider);
  }

  Future<AlmasImage> resize(Size size) async {
    final resizedImage = await compute(
      resizeImgImage,
      ImageResizeParams(await imgImage, size),
    );
    final provider = imageProviderFromImage(resizedImage);
    return AlmasImage(provider);
  }
}
