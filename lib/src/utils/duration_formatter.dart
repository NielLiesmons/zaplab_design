/// A utility class for formatting durations into human-readable strings.
class LabDurationFormatter {
  /// Formats a duration into a string representation (e.g., "1:23" or "12:34").
  ///
  /// The format follows these rules:
  /// - Minutes are not padded with zeros unless over 9:59
  /// - Seconds are always padded with zeros
  /// - Examples: "0:05", "1:23", "12:34"
  static String format(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds.remainder(60);

    // Only pad minutes with zero if over 9:59
    final minutesStr = minutes > 9 ? minutes.toString() : minutes.toString();
    final secondsStr = seconds.toString().padLeft(2, '0');

    return '$minutesStr:$secondsStr';
  }
}
