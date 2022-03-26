library almas_image;

import 'package:almas_image/src/almas_image.dart';
import 'package:flutter/material.dart';

export 'src/operations/canvas.dart';
export 'src/operations/crop.dart';
export 'src/operations/flip.dart';
export 'src/operations/resolver.dart' show resolveUiImage, uiImageToPngBytes;
export 'src/operations/size.dart';

export 'src/almas_image.dart';

extension EasyAlmasImage on ImageProvider {

  AlmasImage get almas => AlmasImage(this);

}