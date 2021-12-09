extension TimeCalc on num {
  int millisToSec() => (this / 1000.0).round();

  int secToMin() => (this / 60.0).round();

  int secToMillis() => (this * 1000).round();

  int minToSec() => (this * 60.0).round();
}
