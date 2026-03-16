import 'package:flutter/material.dart';

class FilmstripBar extends StatelessWidget {
  final double height;
  
  const FilmstripBar({super.key, required this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        gradient: const LinearGradient(
          colors: [
            Color(0xFF1a1a2e),
            Color(0xFF16213e),
            Color(0xFF0f3460),
            Color(0xFF16213e),
            Color(0xFF1a1a2e),
          ],
        ),
        border: Border.all(color: Colors.white12),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: CustomPaint(painter: _FilmPerforationPainter()),
      ),
    );
  }
}

class _FilmPerforationPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black54
      ..style = PaintingStyle.fill;

    const holeSize = 6.0;
    const holeSpacing = 16.0;
    const margin = 4.0;

    double x = holeSpacing / 2;
    while (x < size.width) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(x - holeSize / 2, margin, holeSize, holeSize),
          const Radius.circular(2),
        ),
        paint,
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(
            x - holeSize / 2,
            size.height - margin - holeSize,
            holeSize,
            holeSize,
          ),
          const Radius.circular(2),
        ),
        paint,
      );
      x += holeSpacing;
    }
  }

  @override
  bool shouldRepaint(_FilmPerforationPainter oldDelegate) => false;
}
