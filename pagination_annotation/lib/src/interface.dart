import "package:meta/meta.dart";

const String injectedUrlKey = "INJECTED_URL";

String makeUrl({
  @required String url,
  @required int page,
  String queryKey = "page",
}) {
  final Uri uri = Uri.parse(url);

  final Map<String, String> query = Map.from(uri.queryParameters);
  query[queryKey] = page.toString();

  return uri.replace(queryParameters: query).toString();
}

abstract class Paginated<T> {
  const Paginated(this._results, this.totalCount, this.previousUrl, this.nextUrl);

  List<T> get results  => _results.toList();

  final List<T> _results;
  final int totalCount;

  final String previousUrl;
  final String nextUrl;

  bool get isEmpty => _results.length <= 0;
  bool get isNotEmpty => _results.length > 0;

  int get resultCount => _results.length;

  bool get havePrevious => previousUrl != null;
  bool get haveNext => nextUrl != null;
}
