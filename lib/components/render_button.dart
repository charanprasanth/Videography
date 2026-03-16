import 'package:flutter/material.dart';

class RenderButton extends StatelessWidget {
  final bool enabled;
  final VoidCallback onTap;
  const RenderButton({super.key, required this.enabled, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 52,
        decoration: BoxDecoration(
          gradient: enabled
              ? const LinearGradient(
                  colors: [Color(0xFF6C63FF), Color(0xFF48CAE4)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                )
              : null,
          color: enabled ? null : Colors.white12,
          borderRadius: BorderRadius.circular(14),
          boxShadow: enabled
              ? const [
                  BoxShadow(
                    color: Color(0x556C63FF),
                    blurRadius: 14,
                    offset: Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.movie_creation_outlined,
              size: 20,
              color: enabled ? Colors.white : Colors.white30,
            ),
            const SizedBox(width: 8),
            Text(
              'Render',
              style: TextStyle(
                color: enabled ? Colors.white : Colors.white30,
                fontSize: 15,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
