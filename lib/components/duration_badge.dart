import 'package:flutter/material.dart';

class DurationBadge extends StatelessWidget {
  final double seconds;
  
  const DurationBadge({super.key, required this.seconds});

  @override
  Widget build(BuildContext context) {
    final m = (seconds ~/ 60).toString().padLeft(2, '0');
    final s = (seconds % 60).toStringAsFixed(1).padLeft(4, '0');
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF6C63FF).withAlpha(30),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF6C63FF).withAlpha(60)),
      ),
      child: Row(
        children: [
          const Icon(Icons.timer_outlined, size: 12, color: Color(0xFF6C63FF)),
          const SizedBox(width: 4),
          Text(
            '$m:$s',
            style: const TextStyle(
              color: Color(0xFF6C63FF),
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
