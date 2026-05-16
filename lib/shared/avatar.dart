import 'package:flutter/material.dart';

import '../theme/colors.dart';

enum AvatarPose { bust, stand, meditate }

class Avatar extends StatelessWidget {
  const Avatar({
    super.key,
    this.size = 140,
    this.pose = AvatarPose.bust,
    this.skin = AppColors.avatarSkin,
    this.hair = AppColors.avatarHair,
    this.outfit = AppColors.avatarOutfit,
    this.pants = AppColors.avatarPants,
  });

  final double size;
  final AvatarPose pose;
  final Color skin;
  final Color hair;
  final Color outfit;
  final Color pants;

  Size _viewBox() {
    switch (pose) {
      case AvatarPose.bust:
        return const Size(140, 140);
      case AvatarPose.meditate:
        return const Size(200, 220);
      case AvatarPose.stand:
        return const Size(160, 340);
    }
  }

  @override
  Widget build(BuildContext context) {
    final vb = _viewBox();
    final width = size;
    final height = size * vb.height / vb.width;
    return SizedBox(
      width: width,
      height: height,
      child: CustomPaint(
        painter: _AvatarPainter(
          pose: pose,
          skin: skin,
          hair: hair,
          outfit: outfit,
          pants: pants,
          viewBox: vb,
        ),
      ),
    );
  }
}

class _AvatarPainter extends CustomPainter {
  _AvatarPainter({
    required this.pose,
    required this.skin,
    required this.hair,
    required this.outfit,
    required this.pants,
    required this.viewBox,
  });

  final AvatarPose pose;
  final Color skin;
  final Color hair;
  final Color outfit;
  final Color pants;
  final Size viewBox;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.scale(size.width / viewBox.width);
    switch (pose) {
      case AvatarPose.bust:
        _paintBust(canvas);
        break;
      case AvatarPose.meditate:
        _paintMeditate(canvas);
        break;
      case AvatarPose.stand:
        _paintStand(canvas);
        break;
    }
  }

  Paint _fill(Color c) => Paint()..color = c;
  Paint _stroke(Color c, double w, {bool round = true}) => Paint()
    ..color = c
    ..style = PaintingStyle.stroke
    ..strokeWidth = w
    ..strokeCap = round ? StrokeCap.round : StrokeCap.butt
    ..strokeJoin = round ? StrokeJoin.round : StrokeJoin.miter;

  void _drawEye(Canvas c, double cx, double cy) {
    c.drawOval(
      Rect.fromCenter(center: Offset(cx, cy), width: 6, height: 8),
      _fill(AppColors.ink),
    );
  }

  void _drawBlush(Canvas c, double cx, double cy) {
    c.drawOval(
      Rect.fromCenter(center: Offset(cx, cy), width: 10, height: 6),
      _fill(AppColors.avatarBlush.withValues(alpha: 0.5)),
    );
  }

  void _paintBust(Canvas canvas) {
    // shoulders
    final shoulders = Path()
      ..moveTo(30, 140)
      ..quadraticBezierTo(30, 100, 70, 100)
      ..quadraticBezierTo(110, 100, 110, 140)
      ..close();
    canvas.drawPath(shoulders, _fill(outfit));
    // neck
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(62, 84, 16, 20),
        const Radius.circular(6),
      ),
      _fill(skin),
    );
    // face
    canvas.drawOval(
      Rect.fromCenter(center: const Offset(70, 62), width: 56, height: 64),
      _fill(skin),
    );
    // hair cap
    final hairCap = Path()
      ..moveTo(42, 56)
      ..quadraticBezierTo(44, 26, 70, 24)
      ..quadraticBezierTo(98, 22, 100, 52)
      ..quadraticBezierTo(98, 46, 88, 44)
      ..quadraticBezierTo(82, 52, 70, 50)
      ..quadraticBezierTo(56, 50, 50, 56)
      ..close();
    canvas.drawPath(hairCap, _fill(hair));
    final sideburn = Path()
      ..moveTo(42, 56)
      ..quadraticBezierTo(40, 70, 46, 78)
      ..quadraticBezierTo(46, 64, 50, 56)
      ..close();
    canvas.drawPath(sideburn, _fill(hair));
    // eyes / blush / mouth
    _drawEye(canvas, 60, 64);
    _drawEye(canvas, 80, 64);
    _drawBlush(canvas, 54, 74);
    _drawBlush(canvas, 86, 74);
    final mouth = Path()
      ..moveTo(64, 80)
      ..quadraticBezierTo(70, 84, 76, 80);
    canvas.drawPath(mouth, _stroke(AppColors.avatarLipsShadow, 2.5));
  }

  void _paintMeditate(Canvas canvas) {
    // mat
    canvas.drawOval(
      Rect.fromCenter(center: const Offset(100, 200), width: 160, height: 20),
      _fill(AppColors.matShadow.withValues(alpha: 0.6)),
    );
    // crossed legs
    final legs = Path()
      ..moveTo(40, 195)
      ..quadraticBezierTo(40, 170, 75, 165)
      ..lineTo(100, 160)
      ..lineTo(125, 165)
      ..quadraticBezierTo(160, 170, 160, 195)
      ..close();
    canvas.drawPath(legs, _fill(pants));
    // feet
    canvas.drawOval(
      Rect.fromCenter(center: const Offset(48, 190), width: 28, height: 20),
      _fill(skin),
    );
    canvas.drawOval(
      Rect.fromCenter(center: const Offset(152, 190), width: 28, height: 20),
      _fill(skin),
    );
    // torso
    final torso = Path()
      ..moveTo(68, 160)
      ..quadraticBezierTo(70, 110, 100, 105)
      ..quadraticBezierTo(130, 110, 132, 160)
      ..close();
    canvas.drawPath(torso, _fill(outfit));
    final bustLine = Path()
      ..moveTo(75, 130)
      ..quadraticBezierTo(85, 138, 100, 138)
      ..quadraticBezierTo(115, 138, 125, 130);
    canvas.drawPath(bustLine, _stroke(const Color(0xFF7A2530), 1));
    // arms (thick strokes)
    final armL = Path()
      ..moveTo(68, 150)
      ..quadraticBezierTo(40, 168, 50, 188);
    canvas.drawPath(armL, _stroke(skin, 14));
    final armR = Path()
      ..moveTo(132, 150)
      ..quadraticBezierTo(160, 168, 150, 188);
    canvas.drawPath(armR, _stroke(skin, 14));
    // neck
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(92, 92, 16, 18),
        const Radius.circular(6),
      ),
      _fill(skin),
    );
    // head
    canvas.drawOval(
      Rect.fromCenter(center: const Offset(100, 72), width: 56, height: 64),
      _fill(skin),
    );
    // hair
    final h = Path()
      ..moveTo(72, 66)
      ..quadraticBezierTo(74, 36, 100, 34)
      ..quadraticBezierTo(128, 32, 130, 62)
      ..quadraticBezierTo(128, 56, 118, 54)
      ..quadraticBezierTo(112, 62, 100, 60)
      ..quadraticBezierTo(86, 60, 80, 66)
      ..close();
    canvas.drawPath(h, _fill(hair));
    // eyes / mouth / blush
    _drawEye(canvas, 90, 74);
    _drawEye(canvas, 110, 74);
    final mouth = Path()
      ..moveTo(94, 90)
      ..quadraticBezierTo(100, 94, 106, 90);
    canvas.drawPath(mouth, _stroke(AppColors.avatarLipsShadow, 2.5));
    _drawBlush(canvas, 84, 84);
    _drawBlush(canvas, 116, 84);
  }

  void _paintStand(Canvas canvas) {
    // legs (two prism-like paths)
    final legL = Path()
      ..moveTo(62, 200)
      ..lineTo(58, 320)
      ..lineTo(78, 320)
      ..lineTo(80, 215)
      ..close();
    canvas.drawPath(legL, _fill(pants));
    final legR = Path()
      ..moveTo(98, 200)
      ..lineTo(102, 320)
      ..lineTo(82, 320)
      ..lineTo(80, 215)
      ..close();
    canvas.drawPath(legR, _fill(pants));
    // feet
    canvas.drawOval(
      Rect.fromCenter(center: const Offset(68, 325), width: 28, height: 12),
      _fill(skin),
    );
    canvas.drawOval(
      Rect.fromCenter(center: const Offset(92, 325), width: 28, height: 12),
      _fill(skin),
    );
    // hips
    final hips = Path()
      ..moveTo(55, 175)
      ..quadraticBezierTo(80, 170, 105, 175)
      ..lineTo(105, 205)
      ..lineTo(55, 205)
      ..close();
    canvas.drawPath(hips, _fill(pants));
    // torso
    final torso = Path()
      ..moveTo(52, 110)
      ..quadraticBezierTo(52, 100, 65, 98)
      ..quadraticBezierTo(80, 95, 95, 98)
      ..quadraticBezierTo(108, 100, 108, 110)
      ..lineTo(108, 178)
      ..lineTo(52, 178)
      ..close();
    canvas.drawPath(torso, _fill(outfit));
    final bustLine = Path()
      ..moveTo(65, 130)
      ..quadraticBezierTo(80, 142, 95, 130);
    canvas.drawPath(bustLine, _stroke(const Color(0xFF7A2530), 1));
    // arms
    final armL = Path()
      ..moveTo(52, 110)
      ..quadraticBezierTo(35, 150, 45, 195);
    canvas.drawPath(armL, _stroke(skin, 14));
    final armR = Path()
      ..moveTo(108, 110)
      ..quadraticBezierTo(125, 150, 115, 195);
    canvas.drawPath(armR, _stroke(skin, 14));
    // neck
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(72, 78, 16, 22),
        const Radius.circular(6),
      ),
      _fill(skin),
    );
    // head
    canvas.drawOval(
      Rect.fromCenter(center: const Offset(80, 50), width: 56, height: 64),
      _fill(skin),
    );
    // hair
    final h = Path()
      ..moveTo(52, 44)
      ..quadraticBezierTo(54, 14, 80, 12)
      ..quadraticBezierTo(108, 10, 110, 40)
      ..quadraticBezierTo(108, 34, 98, 32)
      ..quadraticBezierTo(92, 40, 80, 38)
      ..quadraticBezierTo(66, 38, 60, 44)
      ..close();
    canvas.drawPath(h, _fill(hair));
    _drawEye(canvas, 70, 52);
    _drawEye(canvas, 90, 52);
    final mouth = Path()
      ..moveTo(74, 68)
      ..quadraticBezierTo(80, 72, 86, 68);
    canvas.drawPath(mouth, _stroke(AppColors.avatarLipsShadow, 2.5));
    _drawBlush(canvas, 64, 62);
    _drawBlush(canvas, 96, 62);
  }

  @override
  bool shouldRepaint(covariant _AvatarPainter old) =>
      old.pose != pose ||
      old.skin != skin ||
      old.hair != hair ||
      old.outfit != outfit ||
      old.pants != pants;
}

// Tiny silhouette thumbnails used inside the customizer slider cards.
class SilBody extends StatelessWidget {
  const SilBody({
    super.key,
    required this.outfit,
    this.pants = AppColors.avatarPants,
  });
  final Color outfit;
  final Color pants;
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(36, 56),
      painter: _SilBodyPainter(outfit, pants),
    );
  }
}

class _SilBodyPainter extends CustomPainter {
  _SilBodyPainter(this.outfit, this.pants);
  final Color outfit;
  final Color pants;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.scale(size.width / 36, size.height / 56);
    final skin = Paint()..color = AppColors.avatarSkin;
    canvas.drawOval(
      Rect.fromCenter(center: const Offset(18, 8), width: 12, height: 14),
      skin,
    );
    final body = Path()
      ..moveTo(8, 22)
      ..quadraticBezierTo(8, 18, 12, 17)
      ..quadraticBezierTo(18, 16, 24, 17)
      ..quadraticBezierTo(28, 18, 28, 22)
      ..lineTo(28, 36)
      ..lineTo(8, 36)
      ..close();
    canvas.drawPath(body, Paint()..color = outfit);
    final lp = Path()
      ..moveTo(10, 36)
      ..lineTo(8, 54)
      ..lineTo(18, 54)
      ..lineTo(18, 38)
      ..close();
    final rp = Path()
      ..moveTo(26, 36)
      ..lineTo(28, 54)
      ..lineTo(18, 54)
      ..lineTo(18, 38)
      ..close();
    canvas.drawPath(lp, Paint()..color = pants);
    canvas.drawPath(rp, Paint()..color = pants);
  }

  @override
  bool shouldRepaint(covariant _SilBodyPainter old) =>
      old.outfit != outfit || old.pants != pants;
}

class SilFace extends StatelessWidget {
  const SilFace({super.key, required this.skin, required this.hair});
  final Color skin;
  final Color hair;
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(36, 44),
      painter: _SilFacePainter(skin, hair),
    );
  }
}

class _SilFacePainter extends CustomPainter {
  _SilFacePainter(this.skin, this.hair);
  final Color skin;
  final Color hair;
  @override
  void paint(Canvas canvas, Size size) {
    canvas.scale(size.width / 36, size.height / 44);
    canvas.drawOval(
      Rect.fromCenter(center: const Offset(18, 22), width: 26, height: 30),
      Paint()..color = skin,
    );
    final h = Path()
      ..moveTo(5, 18)
      ..quadraticBezierTo(5, 4, 18, 4)
      ..quadraticBezierTo(31, 4, 31, 18)
      ..quadraticBezierTo(28, 14, 22, 14)
      ..quadraticBezierTo(15, 16, 12, 18)
      ..quadraticBezierTo(8, 18, 5, 18)
      ..close();
    canvas.drawPath(h, Paint()..color = hair);
    canvas.drawCircle(
      const Offset(14, 22),
      1.4,
      Paint()..color = AppColors.ink,
    );
    canvas.drawCircle(
      const Offset(22, 22),
      1.4,
      Paint()..color = AppColors.ink,
    );
  }

  @override
  bool shouldRepaint(covariant _SilFacePainter old) =>
      old.skin != skin || old.hair != hair;
}
