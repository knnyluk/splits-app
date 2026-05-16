import 'dart:math';

import 'package:flutter/material.dart';

import '../state/app_state.dart';

class StoreItemPlant extends StatelessWidget {
  const StoreItemPlant({super.key, this.size = 60});
  final double size;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(size: Size(size, size * 1.2), painter: _PlantPainter());
  }
}

class _PlantPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    canvas.scale(size.width / 60, size.height / 72);

    // strings
    final string = Paint()
      ..color = const Color(0xFFC97A4A)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    canvas.drawLine(const Offset(20, 6), const Offset(28, 36), string);
    canvas.drawLine(const Offset(40, 6), const Offset(32, 36), string);

    // pot
    final pot = Path()
      ..moveTo(22, 36)
      ..quadraticBezierTo(22, 50, 30, 56)
      ..quadraticBezierTo(38, 50, 38, 36)
      ..close();
    canvas.drawPath(pot, Paint()..color = const Color(0xFFE8A24A));
    final rim = Paint()
      ..color = const Color(0xFFB57828)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8;
    canvas.drawLine(const Offset(22, 36), const Offset(38, 36), rim);

    // tassel
    final tassel = Paint()
      ..color = const Color(0xFFE89060)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    canvas.drawLine(const Offset(30, 56), const Offset(28, 66), tassel);
    canvas.drawLine(const Offset(30, 56), const Offset(30, 66), tassel);
    canvas.drawLine(const Offset(30, 56), const Offset(32, 66), tassel);

    // leaves — rotated ellipses
    void leaf(Offset c, double rx, double ry, double rotDeg, Color color) {
      canvas.save();
      canvas.translate(c.dx, c.dy);
      canvas.rotate(rotDeg * pi / 180);
      canvas.drawOval(
        Rect.fromCenter(center: Offset.zero, width: rx * 2, height: ry * 2),
        Paint()..color = color,
      );
      canvas.restore();
    }

    leaf(const Offset(14, 22), 6, 14, -30, const Color(0xFF6FA85E));
    leaf(const Offset(46, 22), 6, 14, 30, const Color(0xFF6FA85E));
    leaf(const Offset(20, 14), 5, 12, -20, const Color(0xFF84B770));
    leaf(const Offset(40, 14), 5, 12, 20, const Color(0xFF84B770));
    canvas.drawOval(
      Rect.fromCenter(center: const Offset(30, 10), width: 8, height: 20),
      Paint()..color = const Color(0xFF9DC588),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class StoreItemTable extends StatelessWidget {
  const StoreItemTable({super.key, this.size = 60});
  final double size;
  @override
  Widget build(BuildContext context) =>
      CustomPaint(size: Size(size, size * 0.7), painter: _TablePainter());
}

class _TablePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    canvas.scale(size.width / 60, size.height / 42);
    final fillUnder = Paint()..color = const Color(0xFFE8D4B8);
    final fillTop = Paint()..color = const Color(0xFFF0DDC0);
    final stroke = Paint()
      ..color = const Color(0xFFB59672)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    canvas.drawOval(
      Rect.fromCenter(center: const Offset(30, 16), width: 48, height: 12),
      fillUnder,
    );
    canvas.drawOval(
      Rect.fromCenter(center: const Offset(30, 16), width: 48, height: 12),
      stroke,
    );
    canvas.drawOval(
      Rect.fromCenter(center: const Offset(30, 14), width: 48, height: 12),
      fillTop,
    );

    final legs = Paint()
      ..color = const Color(0xFFB59672)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;
    canvas.drawLine(const Offset(12, 18), const Offset(14, 38), legs);
    canvas.drawLine(const Offset(48, 18), const Offset(46, 38), legs);
    canvas.drawLine(const Offset(30, 20), const Offset(30, 40), legs);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class StoreItemLamp extends StatelessWidget {
  const StoreItemLamp({super.key, this.size = 60});
  final double size;
  @override
  Widget build(BuildContext context) =>
      CustomPaint(size: Size.square(size), painter: _LampPainter());
}

class _LampPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    canvas.scale(size.width / 60, size.height / 60);
    final shade = Path()
      ..moveTo(18, 14)
      ..lineTo(42, 14)
      ..lineTo(36, 30)
      ..lineTo(24, 30)
      ..close();
    canvas.drawPath(shade, Paint()..color = const Color(0xFFF4D896));
    canvas.drawPath(
      shade,
      Paint()
        ..color = const Color(0xFFC9A56B)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1,
    );
    final stem = Paint()
      ..color = const Color(0xFFB59672)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawLine(const Offset(30, 30), const Offset(30, 50), stem);
    canvas.drawOval(
      Rect.fromCenter(center: const Offset(30, 52), width: 20, height: 6),
      Paint()..color = const Color(0xFFB59672),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class StoreItemPicture extends StatelessWidget {
  const StoreItemPicture({super.key, this.size = 60});
  final double size;
  @override
  Widget build(BuildContext context) =>
      CustomPaint(size: Size(size, size * 0.9), painter: _PicturePainter());
}

class _PicturePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    canvas.scale(size.width / 60, size.height / 54);
    canvas.drawRect(
      const Rect.fromLTWH(6, 6, 48, 42),
      Paint()..color = const Color(0xFFB8DCE8),
    );
    canvas.drawRect(
      const Rect.fromLTWH(6, 6, 48, 42),
      Paint()
        ..color = const Color(0xFF8FA9B2)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );
    canvas.drawCircle(
      const Offset(20, 20),
      5,
      Paint()..color = const Color(0xFFF4D896),
    );
    final mountains = Path()
      ..moveTo(6, 40)
      ..lineTo(22, 28)
      ..lineTo(34, 36)
      ..lineTo(54, 24)
      ..lineTo(54, 48)
      ..lineTo(6, 48)
      ..close();
    canvas.drawPath(mountains, Paint()..color = const Color(0xFF7FB07A));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

Widget storeItemFor(StoreItemKind kind, {double size = 60}) {
  switch (kind) {
    case StoreItemKind.table:
      return StoreItemTable(size: size);
    case StoreItemKind.plant:
      return StoreItemPlant(size: size);
    case StoreItemKind.lamp:
      return StoreItemLamp(size: size);
    case StoreItemKind.picture:
      return StoreItemPicture(size: size);
  }
}

String labelFor(StoreItemKind kind) {
  switch (kind) {
    case StoreItemKind.table:
      return 'Round table';
    case StoreItemKind.plant:
      return 'Hanging fern';
    case StoreItemKind.lamp:
      return 'Floor lamp';
    case StoreItemKind.picture:
      return 'Landscape';
  }
}
