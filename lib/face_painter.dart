import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

class FacePainter extends CustomPainter {
  final ui.Image image;
  final List<Face> faces;
  final List<Rect> rects = [];

  FacePainter(this.image, this.faces) {
    for (var face in faces) {
      rects.add(face.boundingBox);
    }
  }

  @override
  bool shouldRepaint(covariant FacePainter oldDelegate) {
    return image != oldDelegate.image || faces != oldDelegate.faces;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10
      ..color = Colors.red;

    canvas.drawImage(image, Offset.zero, paint);

    for (var rect in rects) {
      canvas.drawRect(rect, paint);
    }
  }
}
