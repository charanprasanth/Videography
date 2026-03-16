class TrimJob {
  final String inputPath;
  final String outputPath;
  final double startSeconds;
  final double endSeconds;

  const TrimJob({
    required this.inputPath,
    required this.outputPath,
    required this.startSeconds,
    required this.endSeconds,
  });

  @override
  String toString() {
    return 'TrimJob(input: $inputPath, output: $outputPath, '
        'start: ${startSeconds}s, end: ${endSeconds}s)';
  }
}
