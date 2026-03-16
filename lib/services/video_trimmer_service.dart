import 'package:ffmpeg_kit_flutter_new_min/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter_new_min/return_code.dart';
import '../models/trim_job.dart';

Future<String> runTrimJob(TrimJob job) async {
  String toTimecode(double seconds) {
    final h = (seconds ~/ 3600).toString().padLeft(2, '0');
    final m = ((seconds % 3600) ~/ 60).toString().padLeft(2, '0');
    final s = (seconds % 60).toStringAsFixed(3).padLeft(6, '0');
    return '$h:$m:$s';
  }

  final start = toTimecode(job.startSeconds);
  final duration = job.endSeconds - job.startSeconds;
  final durationStr = toTimecode(duration);

  final command =
      '-y -ss $start -i "${job.inputPath}" -t $durationStr -c copy "${job.outputPath}"';

  final session = await FFmpegKit.execute(command);
  final returnCode = await session.getReturnCode();

  if (ReturnCode.isSuccess(returnCode)) {
    return job.outputPath;
  } else {
    final logs = await session.getOutput();
    throw Exception('FFmpeg trim failed.\n$logs');
  }
}
