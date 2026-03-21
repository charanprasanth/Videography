# Flutter Videography

A clean, minimal video trimming app for iOS and Android built with Flutter. Pick a video, drag the trim handles, preview your clip and export it straight to your gallery — all powered by FFmpegKit under the hood.

---

## Features

- 🎬 **Pick any video** from your device library
- 🎚️ **Dual-handle trim slider** — drag start and end points independently
- ▶️ **Live preview** — playback is clamped to your selected trim region
- ⚡ **Frame-accurate cuts** — FFmpeg `-c copy` for fast, lossless trimming
- 📁 **Export to gallery** — saved directly to Photos / Gallery via `gal`
- 🌑 **Dark UI** — Material 3 dark theme throughout

---

## Screenshots

<img src="screenshots/1000000488.png" width="250" /> <img src="https://github.com/user-attachments/assets/753a6230-9115-4fc4-908e-f2b1cb0440de" width="250" />


---

## Tech Stack

| Layer | Package |
|---|---|
| Video playback | `video_player` |
| FFmpeg execution | `ffmpeg_kit_flutter_new_min` |
| File picking | `file_picker` |
| Gallery export | `gal` |
| Path resolution | `path_provider` |

---

## Getting Started

### Prerequisites

- Flutter 3.x+
- Dart 3.x+
- Xcode (iOS) / Android Studio (Android)

### Installation

```bash
git clone https://github.com/charanprasanth/Videography.git
cd Videography
flutter pub get
flutter run
```

---

## How It Works

1. User picks a video — loaded into `VideoPlayerController` for preview
2. Dual-handle slider sets `startSeconds` and `endSeconds`
3. On render, a `TrimJob` is built with the input path, output path, and trim values
4. FFmpegKit executes the trim command on a **native background thread** (no isolate needed — FFmpegKit handles its own threading via platform channels)
5. Output is saved to the gallery via `gal`

### FFmpeg command used

```
ffmpeg -y -ss <start> -i <input> -t <duration> -c copy <output>
```

`-ss` before `-i` enables fast seek. `-c copy` avoids re-encoding for instant, lossless output.

---

## Project Structure

```
lib/
├── components/                       # Small, focused UI components
│   ├── action_button.dart
│   ├── duration_badge.dart
│   ├── empty_state.dart
│   ├── filmstrip_bar.dart
│   ├── outline_button.dart
│   ├── play_pause_button.dart
│   ├── render_button.dart
│   ├── render_overlay.dart
│   ├── seek_button.dart
│   ├── time_chip.dart
│   ├── top_bar.dart
│   └── trim_handle.dart
├── models/
│   └── trim_job.dart               # Data class: input, output, start, end
├── screens/
│   ├── video_editor_screen.dart    # Main UI + playback + render logic
│   └── video_preview_screen.dart   # Fullscreen preview of trimmed output
├── services/
│   └── video_trimmer_service.dart  # FFmpegKit execution
├── widgets/
│   └── video_trim_slider.dart      # Custom dual-handle range slider
└── main.dart
```

---

## License

MIT
