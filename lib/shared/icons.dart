import 'package:flutter/material.dart';

import '../theme/colors.dart';

class GemIcon extends StatelessWidget {
  const GemIcon({super.key, this.size = 18});
  final double size;
  @override
  Widget build(BuildContext context) =>
      CustomPaint(size: Size.square(size), painter: _GemPainter());
}

class _GemPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width / 24;
    canvas.scale(s);
    final fill = Paint()..color = AppColors.gemFill;
    final fillLight = Paint()..color = AppColors.gemFillLight;
    final stroke = Paint()
      ..color = AppColors.gemStroke
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2
      ..strokeJoin = StrokeJoin.round;

    final outline = Path()
      ..moveTo(6, 4)
      ..lineTo(18, 4)
      ..lineTo(22, 9)
      ..lineTo(12, 22)
      ..lineTo(2, 9)
      ..lineTo(6, 4)
      ..close();
    canvas.drawPath(outline, fill);

    void facet(List<Offset> pts) {
      final p = Path()..moveTo(pts[0].dx, pts[0].dy);
      for (var i = 1; i < pts.length; i++) {
        p.lineTo(pts[i].dx, pts[i].dy);
      }
      p.close();
      canvas.drawPath(p, fillLight);
      canvas.drawPath(p, stroke);
    }

    facet([const Offset(6, 4), const Offset(9, 9), const Offset(2, 9)]);
    facet([const Offset(18, 4), const Offset(15, 9), const Offset(22, 9)]);
    facet([const Offset(9, 9), const Offset(12, 22), const Offset(15, 9)]);
    final topRidge = Path()
      ..moveTo(9, 9)
      ..lineTo(12, 4)
      ..lineTo(15, 9);
    canvas.drawPath(topRidge, stroke);
    canvas.drawPath(outline, stroke);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class LockIcon extends StatelessWidget {
  const LockIcon({super.key, this.size = 22, this.color = AppColors.ink});
  final double size;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return CustomPaint(size: Size.square(size), painter: _LockPainter(color));
  }
}

class _LockPainter extends CustomPainter {
  _LockPainter(this.color);
  final Color color;
  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width / 24;
    canvas.scale(s);
    final body = Paint()..color = color;
    final shackle = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(5, 11, 14, 10),
        const Radius.circular(2),
      ),
      body,
    );
    final arc = Path()
      ..moveTo(8, 11)
      ..lineTo(8, 8)
      ..arcToPoint(
        const Offset(16, 8),
        radius: const Radius.circular(4),
        clockwise: true,
      )
      ..lineTo(16, 11);
    canvas.drawPath(arc, shackle);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class CheckIcon extends StatelessWidget {
  const CheckIcon({super.key, this.size = 14, this.color = Colors.white});
  final double size;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return CustomPaint(size: Size.square(size), painter: _CheckPainter(color));
  }
}

class _CheckPainter extends CustomPainter {
  _CheckPainter(this.color);
  final Color color;
  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width / 24;
    canvas.scale(s);
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    final p = Path()
      ..moveTo(5, 12)
      ..lineTo(10, 17)
      ..lineTo(19, 7);
    canvas.drawPath(p, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

enum ChevDir { up, down, left, right }

class ChevIcon extends StatelessWidget {
  const ChevIcon({
    super.key,
    this.dir = ChevDir.down,
    this.size = 16,
    this.color = AppColors.ink,
    this.strokeWidth = 2.2,
  });
  final ChevDir dir;
  final double size;
  final Color color;
  final double strokeWidth;

  @override
  Widget build(BuildContext context) {
    final turns = switch (dir) {
      ChevDir.down => 0,
      ChevDir.up => 2,
      ChevDir.left => 1,
      ChevDir.right => 3,
    };
    return RotatedBox(
      quarterTurns: turns,
      child: CustomPaint(
        size: Size.square(size),
        painter: _ChevPainter(color, strokeWidth),
      ),
    );
  }
}

class _ChevPainter extends CustomPainter {
  _ChevPainter(this.color, this.strokeWidth);
  final Color color;
  final double strokeWidth;
  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width / 24;
    canvas.scale(s);
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    final p = Path()
      ..moveTo(6, 9)
      ..lineTo(12, 15)
      ..lineTo(18, 9);
    canvas.drawPath(p, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class BackIcon extends StatelessWidget {
  const BackIcon({super.key, this.size = 20, this.color = AppColors.ink});
  final double size;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return CustomPaint(size: Size.square(size), painter: _BackPainter(color));
  }
}

class _BackPainter extends CustomPainter {
  _BackPainter(this.color);
  final Color color;
  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width / 24;
    canvas.scale(s);
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.2
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    final p = Path()
      ..moveTo(14, 6)
      ..lineTo(8, 12)
      ..lineTo(14, 18);
    canvas.drawPath(p, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class GemChip extends StatelessWidget {
  const GemChip({super.key, required this.gems});
  final int gems;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const GemIcon(size: 16),
        const SizedBox(width: 6),
        Text(
          '$gems',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.ink,
          ),
        ),
      ],
    );
  }
}
