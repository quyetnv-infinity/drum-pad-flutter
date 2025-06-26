class CalculateFunc {
  CalculateFunc._();

  static double sumScore(List<double> values) {
    double totalScore = 0;
    for (var value in values) {
      totalScore += value;
    }
    return totalScore;
  }

  static double avgStar(List<double> values) {
    int count = 0;
    double sum = 0;

    for (var value in values) {
      if (value > 0) {
        count++;
        sum += value;
      }
    }

    if (count == 0) return 0;

    return (sum / count) * (100 / 3);
  }

}