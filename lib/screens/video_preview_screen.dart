import 'dart:io';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:gal/gal.dart';
import 'package:share_plus/share_plus.dart';
import '../components/action_button.dart';

class VideoPreviewScreen extends StatefulWidget {
  final String videoPath;

  const VideoPreviewScreen({super.key, required this.videoPath});

  @override
  State<VideoPreviewScreen> createState() => _VideoPreviewScreenState();
}

class _VideoPreviewScreenState extends State<VideoPreviewScreen> {
  late VideoPlayerController _controller;
  bool _isPlaying = true;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(File(widget.videoPath))
      ..initialize().then((_) {
        setState(() {});
        _controller.setLooping(true);
        _controller.play();
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _togglePlayback() {
    setState(() {
      if (_controller.value.isPlaying) {
        _controller.pause();
        _isPlaying = false;
      } else {
        _controller.play();
        _isPlaying = true;
      }
    });
  }

  Future<void> _saveToGallery() async {
    setState(() => _isSaving = true);
    try {
      final hasAccess = await Gal.hasAccess();
      if (!hasAccess) {
        final request = await Gal.requestAccess();
        if (!request) {
          _showSnackBar('Gallery access denied', isError: true);
          return;
        }
      }

      await Gal.putVideo(widget.videoPath);
      _showSnackBar('Video saved to gallery!');
    } catch (e) {
      _showSnackBar('Failed to save to gallery: $e', isError: true);
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  Future<void> _shareOrSaveToFiles() async {
    try {
      // ignore: deprecated_member_use
      await Share.shareXFiles([XFile(widget.videoPath)], text: 'Trimmed video');
    } catch (e) {
      _showSnackBar('Failed to share: $e', isError: true);
    }
  }

  Future<void> _deleteVideo() async {
    try {
      final file = File(widget.videoPath);
      if (await file.exists()) {
        await file.delete();
      }
      if (mounted) {
        Navigator.pop(context);
        _showSnackBar('Video deleted');
      }
    } catch (e) {
      _showSnackBar('Failed to delete video: $e', isError: true);
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(color: Colors.white)),
        backgroundColor: isError ? Colors.red.shade900 : Colors.green.shade800,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0d0d14),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.white,
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Preview',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: _controller.value.isInitialized
                    ? GestureDetector(
                        onTap: _togglePlayback,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            AspectRatio(
                              aspectRatio: _controller.value.aspectRatio,
                              child: VideoPlayer(_controller),
                            ),
                            if (!_isPlaying)
                              Container(
                                width: 64,
                                height: 64,
                                decoration: BoxDecoration(
                                  color: Colors.black54,
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.white30),
                                ),
                                child: const Icon(
                                  Icons.play_arrow,
                                  color: Colors.white,
                                  size: 32,
                                ),
                              ),
                          ],
                        ),
                      )
                    : const CircularProgressIndicator(color: Color(0xFF6C63FF)),
              ),
            ),

            // Actions bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
              decoration: BoxDecoration(
                color: const Color(0xFF13131f),
                border: Border(
                  top: BorderSide(color: Colors.white.withAlpha(20)),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ActionButton(
                    icon: Icons.delete_outline,
                    label: 'Delete',
                    color: Colors.red.shade400,
                    onTap: _deleteVideo,
                  ),
                  ActionButton(
                    icon: Icons.photo_library_outlined,
                    label: 'Gallery',
                    color: const Color(0xFF48CAE4),
                    isLoading: _isSaving,
                    onTap: _isSaving ? null : _saveToGallery,
                  ),
                  ActionButton(
                    icon: Icons.ios_share_rounded,
                    label: 'Share/Files',
                    color: const Color(0xFF6C63FF),
                    onTap: _shareOrSaveToFiles,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
