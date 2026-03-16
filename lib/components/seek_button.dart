import 'package:flutter/material.dart';

class SeekButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  const SeekButton({
    super.key,
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: Colors.white.withAlpha(12),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: Colors.white54, size: 22),
      ),
    );
  }
}
