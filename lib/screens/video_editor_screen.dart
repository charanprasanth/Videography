import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:video_player/video_player.dart';
import 'package:path_provider/path_provider.dart';
import '../models/trim_job.dart';
import '../services/video_trimmer_service.dart';
import '../widgets/video_trim_slider.dart';
import '../components/time_chip.dart';
import '../components/duration_badge.dart';
import '../components/seek_button.dart';
import '../components/play_pause_button.dart';
import '../components/outline_button.dart';
import '../components/render_button.dart';
import '../components/top_bar.dart';
import '../components/empty_state.dart';
import '../components/render_overlay.dart';
import 'video_preview_screen.dart';

class VideoEditorScreen extends StatefulWidget {
  const VideoEditorScreen({super.key});

  @override
  State<VideoEditorScreen> createState() => _VideoEditorScreenState();
}

class _VideoEditorScreenState extends State<VideoEditorScreen>
    with SingleTickerProviderStateMixin {
  VideoPlayerController? _controller;
  String? _inputPath;
  double _totalDuration = 1.0;
  double _startValue = 0.0;
  double _endValue = 1.0;
  double _currentPosition = 0.0;
  bool _isRendering = false;
  bool _isPlaying = false;
  late AnimationController _playButtonAnim;

  @override
  void initState() {
    super.initState();
    _playButtonAnim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
  }

  @override
  void dispose() {
    _controller?.removeListener(_positionListener);
    _controller?.dispose();
    _playButtonAnim.dispose();
    super.dispose();
  }

  Future<void> _pickVideo() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.video,
      allowMultiple: false,
    );
    if (result == null || result.files.single.path == null) return;

    final path = result.files.single.path!;
    await _loadVideo(path);
  }

  Future<void> _loadVideo(String path) async {
    await _controller?.dispose();
    final controller = VideoPlayerController.file(File(path));
    await controller.initialize();

    final duration = controller.value.duration.inMilliseconds / 1000.0;

    controller.addListener(_positionListener);
    controller.setLooping(false);

    setState(() {
      _controller = controller;
      _inputPath = path;
      _totalDuration = duration;
      _startValue = 0.0;
      _endValue = duration;
      _currentPosition = 0.0;
      _isPlaying = false;
    });
    _playButtonAnim.reverse();
  }

  void _positionListener() {
    if (_controller == null) return;
    final pos = _controller!.value.position.inMilliseconds / 1000.0;
    if (pos >= _endValue && _isPlaying) {
      _controller!.seekTo(Duration(milliseconds: (_startValue * 1000).round()));
      _controller!.pause();
      setState(() => _isPlaying = false);
      _playButtonAnim.reverse();
    }
    if (mounted) setState(() => _currentPosition = pos);
  }

  void _togglePlayback() {
    if (_controller == null) return;
    if (_controller!.value.isPlaying) {
      _controller!.pause();
      _playButtonAnim.reverse();
      setState(() => _isPlaying = false);
    } else {
      // Seek to start if at or past end
      if (_currentPosition >= _endValue - 0.1) {
        _controller!.seekTo(
          Duration(milliseconds: (_startValue * 1000).round()),
        );
      }
      _controller!.play();
      _playButtonAnim.forward();
      setState(() => _isPlaying = true);
    }
  }

  void _onStartChanged(double val) {
    setState(() => _startValue = val);
    _controller?.seekTo(Duration(milliseconds: (val * 1000).round()));
  }

  void _onEndChanged(double val) {
    setState(() => _endValue = val);
    _controller?.seekTo(Duration(milliseconds: (val * 1000).round()));
  }

  Future<void> _render() async {
    if (_inputPath == null) return;
    setState(() => _isRendering = true);

    try {
      final dir = await getApplicationDocumentsDirectory();
      final outputName = 'trimmed_${DateTime.now().millisecondsSinceEpoch}.mp4';
      final outputPath = '${dir.path}/$outputName';

      final job = TrimJob(
        inputPath: _inputPath!,
        outputPath: outputPath,
        startSeconds: _startValue,
        endSeconds: _endValue,
      );

      final result = await runTrimJob(job);

      if (mounted) {
        setState(() => _isRendering = false);
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => VideoPreviewScreen(videoPath: result),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isRendering = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: const Color(0xFF3e1e1e),
            content: Text(
              'Render failed: $e',
              style: const TextStyle(color: Colors.white),
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0d0d14),
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              children: [
                TopBar(),
                Expanded(child: _buildVideoPreview()),
                _buildTrimSection(),
                _buildBottomBar(),
              ],
            ),
          ),
          if (_isRendering) RenderOverlay(),
        ],
      ),
    );
  }

  Widget _buildVideoPreview() {
    if (_controller == null || !_controller!.value.isInitialized) {
      return EmptyState();
    }

    return GestureDetector(
      onTap: _togglePlayback,
      child: Stack(
        alignment: Alignment.center,
        children: [
          AspectRatio(
            aspectRatio: _controller!.value.aspectRatio,
            child: VideoPlayer(_controller!),
          ),
          AnimatedOpacity(
            opacity: _isPlaying ? 0.0 : 1.0,
            duration: const Duration(milliseconds: 200),
            child: Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(32),
                border: Border.all(color: Colors.white30),
              ),
              child: const Icon(
                Icons.play_arrow,
                color: Colors.white,
                size: 32,
              ),
            ),
          ),
          Positioned(
            bottom: 12,
            right: 12,
            child: TimeChip(seconds: _currentPosition),
          ),
        ],
      ),
    );
  }

  Widget _buildTrimSection() {
    if (_controller == null) return const SizedBox.shrink();

    final duration = _endValue - _startValue;

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      decoration: BoxDecoration(
        color: const Color(0xFF13131f),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Trim',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.3,
                ),
              ),
              DurationBadge(seconds: duration),
            ],
          ),
          const SizedBox(height: 14),

          VideoTrimSlider(
            totalDuration: _totalDuration,
            startValue: _startValue,
            endValue: _endValue,
            currentPosition: _currentPosition,
            onStartChanged: _onStartChanged,
            onEndChanged: _onEndChanged,
          ),

          const SizedBox(height: 20),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SeekButton(
                label: 'Jump to start',
                icon: Icons.skip_previous_rounded,
                onTap: () => _controller?.seekTo(
                  Duration(milliseconds: (_startValue * 1000).round()),
                ),
              ),
              const SizedBox(width: 16),
              PlayPauseButton(isPlaying: _isPlaying, onTap: _togglePlayback),
              const SizedBox(width: 16),
              SeekButton(
                label: 'Jump to end',
                icon: Icons.skip_next_rounded,
                onTap: () => _controller?.seekTo(
                  Duration(milliseconds: (_endValue * 1000).round()),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    final hasVideo = _controller != null;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 20),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: OutlineButton(
              label: hasVideo ? 'Change Video' : 'Pick Video',
              icon: Icons.video_library_outlined,
              onTap: _isRendering ? null : _pickVideo,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 3,
            child: RenderButton(
              enabled: hasVideo && !_isRendering,
              onTap: _render,
            ),
          ),
        ],
      ),
    );
  }
}
