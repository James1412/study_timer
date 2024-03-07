String twoDigits(int n) => n.toString().padLeft(2, '0');
Duration roundSeconds(Duration duration) {
  int seconds = duration.inSeconds;
  if (seconds % 60 < 30) {
    seconds = seconds ~/ 60;
  } else {
    seconds = (seconds ~/ 60) + 1;
  }
  return Duration(minutes: seconds);
}
