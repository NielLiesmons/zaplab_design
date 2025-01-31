class TimestampFormatter {
  static String format(DateTime timestamp,
      {TimestampFormat format = TimestampFormat.auto}) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    // Show "Now" for timestamps within last 2 minutes
    if (difference.inMinutes < 2) {
      return 'Now';
    }

    switch (format) {
      case TimestampFormat.time:
        return '${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')}';

      case TimestampFormat.relative:
        if (difference.inMinutes < 60) {
          return '${difference.inMinutes}m';
        } else if (difference.inHours < 24) {
          return '${difference.inHours}h';
        } else {
          return '${difference.inDays}d';
        }

      case TimestampFormat.auto:
        // Use time format if timestamp is from today
        if (timestamp.day == now.day &&
            timestamp.month == now.month &&
            timestamp.year == now.year) {
          return TimestampFormatter.format(timestamp,
              format: TimestampFormat.time);
        } else {
          return TimestampFormatter.format(timestamp,
              format: TimestampFormat.relative);
        }
    }
  }
}

enum TimestampFormat {
  /// Shows HH:mm for today's timestamps, relative format otherwise
  auto,

  /// Shows as HH:mm
  time,

  /// Shows as Xm, Xh or Xd
  relative,
}
