import 'package:flutter/material.dart';
import '../components/filmstrip_bar.dart';
import '../components/trim_handle.dart';

class VideoTrimSlider extends StatefulWidget {
  final double totalDuration;
  final double startValue;
  final double endValue;
  final double currentPosition;
  final ValueChanged<double> onStartChanged;
  final ValueChanged<double> onEndChanged;

  const VideoTrimSlider({
    super.key,
    required this.totalDuration,
    required this.startValue,
    required this.endValue,
    required this.currentPosition,
    required this.onStartChanged,
    required this.onEndChanged,
  });

  @override
  State<VideoTrimSlider> createState() => _VideoTrimSliderState();
}

class _VideoTrimSliderState extends State<VideoTrimSlider> {
  static const double _minGap = 0.5;
  static const double _barHeight = 56.0;
  static const double _handleWidth = 18.0;

  String _format(double s) {
    final minutes = (s ~/ 60).toString().padLeft(2, '0');
    final secs = (s % 60).toStringAsFixed(1).padLeft(4, '0');
    return '$minutes:$secs';
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final usableWidth = width - _handleWidth * 2;

        double secToPx(double sec) =>
            (sec / widget.totalDuration) * usableWidth + _handleWidth;

        double pxToSec(double px) =>
            ((px - _handleWidth) / usableWidth * widget.totalDuration).clamp(
              0.0,
              widget.totalDuration,
            );

        final startX = secToPx(widget.startValue);
        final endX = secToPx(widget.endValue);
        final playX = secToPx(widget.currentPosition);

        return Column(
          children: [
            SizedBox(
              height: _barHeight + 28,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned(
                    left: 0,
                    right: 0,
                    child: FilmstripBar(height: _barHeight),
                  ),

                  Positioned(
                    left: startX,
                    width: (endX - startX).clamp(0.0, width),
                    top: 14,
                    height: _barHeight,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha(30),
                        border: const Border(
                          top: BorderSide(color: Colors.white30, width: 1),
                          bottom: BorderSide(color: Colors.white30, width: 1),
                        ),
                      ),
                    ),
                  ),

                  Positioned(
                    left: playX - 1,
                    top: 14,
                    height: _barHeight,
                    child: Container(
                      width: 2,
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha(200),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.white.withAlpha(80),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                    ),
                  ),

                  TrimHandle(
                    x: startX - _handleWidth / 2,
                    barHeight: _barHeight,
                    color: const Color(0xFF4CAF50),
                    icon: Icons.arrow_right,
                    label: _format(widget.startValue),
                    labelLeft: true,
                    onDragUpdate: (delta) {
                      final newVal = pxToSec(startX + delta);
                      if (newVal < widget.endValue - _minGap) {
                        widget.onStartChanged(newVal);
                      }
                    },
                  ),

                  TrimHandle(
                    x: endX - _handleWidth / 2,
                    barHeight: _barHeight,
                    color: const Color(0xFFF44336),
                    icon: Icons.arrow_left,
                    label: _format(widget.endValue),
                    labelLeft: false,
                    onDragUpdate: (delta) {
                      final newVal = pxToSec(endX + delta);
                      if (newVal > widget.startValue + _minGap) {
                        widget.onEndChanged(newVal);
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
