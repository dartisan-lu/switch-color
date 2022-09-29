class WeightColor implements Comparable<WeightColor> {
  int color;
  int count;

  WeightColor(this.color, this.count);

  void inc() {
    count++;
  }

  @override
  int compareTo(WeightColor other) {
    return other.count.compareTo(count);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is WeightColor && runtimeType == other.runtimeType && color == other.color;

  @override
  int get hashCode => color.hashCode;
}
