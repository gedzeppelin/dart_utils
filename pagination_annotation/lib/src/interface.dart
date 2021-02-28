abstract class Paginated<T> {
  const Paginated(this.results, this.totalCount);

  final List<T> results;
  final int totalCount;

  bool get havePrevious;
  bool get haveNext;

  bool get isEmpty => results.length <= 0;
  bool get isNotEmpty => results.length > 0;

  int get resultCount => results.length;
}
