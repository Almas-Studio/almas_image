import 'package:almas_image/src/operations/provider.dart';
import 'package:almas_image/src/operations/resolver.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;

Future<ImageProvider> cropImage(
  ImageProvider image,
  Size cropBoxSize, {
  Size? editorSize,
  Size? originalSize,
  Offset cropBoxOffset = Offset.zero,
}) async {
  final workImage = await resolveImage(image);

  originalSize ??=
      Size(workImage.width.toDouble(), workImage.height.toDouble());
  editorSize ??= originalSize;

  final calculatedCropBoxSize = Size(
    (cropBoxSize.width / editorSize.width) * originalSize.width,
    (cropBoxSize.height / editorSize.height) * originalSize.height,
  );

  final calculatedCropBoxOffset = Offset(
    (cropBoxOffset.dx / editorSize.width) * originalSize.width,
    (cropBoxOffset.dy / editorSize.height) * originalSize.height,
  );

  final croped = img.copyCrop(
    workImage,
    calculatedCropBoxOffset.dx.toInt(),
    calculatedCropBoxOffset.dy.toInt(),
    calculatedCropBoxSize.width.toInt(),
    calculatedCropBoxSize.height.toInt(),
  );

  return imageProviderFromImage(croped);
}
