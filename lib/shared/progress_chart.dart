import 'package:flutter/material.dart';

import '../theme/colors.dart';

enum SplitSide { left, right, middle }

const Map<SplitSide, List<int>> _splitData = {
  SplitSide.left: [
    121, 124, 126, 128, 129, 132, 133, 135, 137, 139, //
    141, 143, 145, 146, 149, 151, 153, 156, 158, 160, //
    162, 164, 166, 167, 169,
  ],
  SplitSide.right: [
    125, 126, 128, 130, 131, 133, 134, 136, 137, 139, //
    141, 142, 144, 145, 147, 149, 151, 152, 154, 156, //
    158, 159, 161, 163, 164,
  ],
  SplitSide.middle: [
    110, 112, 114, 115, 117, 119, 121, 122, 124, 125, //
    127, 129, 130, 132, 133, 135, 137, 138, 140, 142, //
    143, 145, 147, 148, 150,
  ],
};

class ProgressChart extends StatelessWidget {
  const ProgressChart({super.key, required this.side});
  final SplitSide side;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.chartBg,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
            color: Color(0x2D1F2333),
            blurRadius: 18,
            offset: Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 10),
      child: AspectRatio(
        aspectRatio: 280 / 150,
        child: CustomPaint(painter: _ChartPainter(side)),
      ),
    );
  }
}

class _ChartPainter extends CustomPainter {
  _ChartPainter(this.side);
  final SplitSide side;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.scale(size.width / 280, size.height / 150);
    const w = 280.0;
    const h = 150.0;
    const padL = 40.0, padR = 16.0, padT = 12.0, padB = 22.0;
    const minVal = 121.0, maxVal = 180.0;

    final labelPaint = TextPainter(
      text: const TextSpan(
        text: '180°',
        style: TextStyle(
          color: AppColors.chartLabel,
          fontSize: 11,
          fontWeight: FontWeight.w600,
          fontFamily: 'Plus Jakarta Sans',
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    labelPaint.paint(canvas, const Offset(6, 9));

    final bot = TextPainter(
      text: const TextSpan(
        text: '121°',
        style: TextStyle(
          color: AppColors.chartLabel,
          fontSize: 11,
          fontWeight: FontWeight.w600,
          fontFamily: 'Plus Jakarta Sans',
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    bot.paint(canvas, const Offset(6, h - 22));

    // gridlines
    final grid = Paint()
      ..color = AppColors.chartGrid
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.6;
    for (var i = 0; i <= 5; i++) {
      final y = padT + (i / 5) * (h - padT - padB);
      canvas.drawLine(Offset(padL - 2, y), Offset(w - padR, y), grid);
    }

    final data = _splitData[side]!;
    final xs = List<double>.generate(
      data.length,
      (i) => padL + (i / (data.length - 1)) * (w - padL - padR),
    );
    final ys = data
        .map(
          (v) =>
              padT + (1 - (v - minVal) / (maxVal - minVal)) * (h - padT - padB),
        )
        .toList();
    final split = data.length ~/ 2;

    void drawSegment(List<Offset> pts, Color color) {
      final paint = Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.4
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round;
      final p = Path()..moveTo(pts.first.dx, pts.first.dy);
      for (var i = 1; i < pts.length; i++) {
        p.lineTo(pts[i].dx, pts[i].dy);
      }
      canvas.drawPath(p, paint);
    }

    final early = <Offset>[];
    for (var i = 0; i <= split; i++) {
      early.add(Offset(xs[i], ys[i]));
    }
    final late_ = <Offset>[];
    for (var i = split; i < xs.length; i++) {
      late_.add(Offset(xs[i], ys[i]));
    }
    drawSegment(early, AppColors.chartGreen);
    drawSegment(late_, AppColors.chartBlue);

    // dots
    for (var i = 0; i < xs.length; i++) {
      final r = (i == xs.length - 1) ? 3.6 : 1.8;
      final color = i < split ? AppColors.chartGreen : AppColors.chartBlue;
      canvas.drawCircle(Offset(xs[i], ys[i]), r, Paint()..color = color);
    }
  }

  @override
  bool shouldRepaint(covariant _ChartPainter old) => old.side != side;
}
