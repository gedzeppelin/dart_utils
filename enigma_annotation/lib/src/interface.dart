class Paginator<T> {
  const Paginator(this.count, this.next, this.previous, this.results);

  final int count;
  final String? next;
  final String? previous;
  final List<T> results;

  bool get haveNext => next != null;
  bool get havePrevious => previous != null;

  bool get isEmpty => results.length <= 0;
  bool get isNotEmpty => results.length > 0;

  int get resultCount => results.length;
}
