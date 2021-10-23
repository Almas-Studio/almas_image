import 'dart:ui';

Future<Image> createCanvas(
  int width,
  int height, {
  Color color = const Color(0xFFFFFFFF),
}) {
  final recorder = PictureRecorder();
  final rect = Rect.fromPoints(
    Offset.zero,
    Offset(
      width.toDouble(),
      height.toDouble(),
    ),
  );
  final canvas = Canvas(recorder, rect);
  final paint = Paint()..color = color;
  canvas.drawRect(rect, paint);
  final picture = recorder.endRecording();
  final image = picture.toImage(width, height);
  return image;
}
