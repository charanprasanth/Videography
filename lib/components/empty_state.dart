import 'package:flutter/material.dart';

class EmptyState extends StatelessWidget {
  const EmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: const Color(0xFF6C63FF).withAlpha(20),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: const Color(0xFF6C63FF).withAlpha(80)),
            ),
            child: const Icon(
              Icons.video_library_outlined,
              size: 48,
              color: Color(0xFF6C63FF),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'No video selected',
            style: TextStyle(color: Colors.white38, fontSize: 15),
          ),
          const SizedBox(height: 6),
          const Text(
            'Tap "Pick Video" below to get started',
            style: TextStyle(color: Colors.white24, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
