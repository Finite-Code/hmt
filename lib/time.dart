String formatSeconds(num? seconds) {
  if (seconds == null || seconds <= 0) return "0h 0m";
  final int totalMins = (seconds / 60).round();
  final int hours = totalMins ~/ 60;
  final int mins = totalMins % 60;
  return "${hours}h ${mins}m";
}
