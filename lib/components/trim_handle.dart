import 'package:flutter/material.dart';

class TrimHandle extends StatelessWidget {
  final double x;
  final double barHeight;
  final Color color;
  final IconData icon;
  final String label;
  final bool labelLeft;
  final ValueChanged<double> onDragUpdate;

  const TrimHandle({
    super.key,
    required this.x,
    required this.barHeight,
    required this.color,
    required this.icon,
    required this.label,
    required this.labelLeft,
    required this.onDragUpdate,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: x,
      top: 14,
      height: barHeight,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onHorizontalDragUpdate: (d) => onDragUpdate(d.delta.dx),
        child: SizedBox(
          width: 18,
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              Container(
                width: 18,
                height: barHeight,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(4),
                  boxShadow: [
                    BoxShadow(
                      color: color.withAlpha(120),
                      blurRadius: 8,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: Icon(icon, color: Colors.white, size: 14),
              ),
              Positioned(
                bottom: -22,
                left: labelLeft ? null : -28,
                right: labelLeft ? -28 : null,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 4,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: color.withAlpha(220),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    label,
                    style: const TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
