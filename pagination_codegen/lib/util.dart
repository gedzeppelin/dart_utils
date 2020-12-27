import "package:pagination_annotation/pagination_annotation.dart";

String makePaginatorSuffix(Style style, String inputClass) {
  switch (style) {
    case Style.enigmapi:
      return "${inputClass}PaginatorEnigmapi";
    case Style.django:
      return "${inputClass}PaginatorDjango";
    case Style.nest:
      return "${inputClass}PaginatorNest";
    default:
      throw Error();
  }
}

String makePaginatorClass(Style style, String inputClass, String paginatorClass) {
  switch (style) {
    case Style.enigmapi:
      return makePaginatorEnigmapi(inputClass, paginatorClass);
    case Style.django:
      return makePaginatorDjango(inputClass, paginatorClass);
    case Style.nest:
      return makePaginatorNest(inputClass, paginatorClass);
    default:
      throw Error();
  }
}

String makePaginatorDjango(String inputClass, String paginatorClass) => """
class $paginatorClass extends Paginated<$inputClass>  {
  const $paginatorClass(
    List<$inputClass> results,
    int count,
    String previous,
    String next,
  ) : super(results, count, previous, next);

  factory $paginatorClass.fromJson(Map<String, dynamic> json) {
    return $paginatorClass(
      (json["results"] as List)
          ?.map(
            (item) => item == null 
                ? null 
                : $inputClass.fromJson(item as Map<String, dynamic>),
          )
          ?.toList(),
      json["count"] as int,
      json["previous"] as String,
      json["next"] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      "count": this.totalCount,
      "next": this.nextUrl,
      "previous": this.previousUrl,
      "results": this.results?.map((e) => e?.toJson())?.toList(),
    }; 
  }
}
""";

String makePaginatorEnigmapi(String inputClass, String paginatorClass) => """
TODO
""";

String makePaginatorNest(String inputClass, String paginatorClass) => """
class $paginatorClass extends Paginated<$inputClass>  {
  const $paginatorClass(
    List<$inputClass> data,
    int total,
    String previousUrl,
    String nextUrl,
    this.count,
    this.page,
    this.pageCount,
  ) : super(data, total, previousUrl, nextUrl);

  factory $paginatorClass.fromJson(Map<String, dynamic> json) {
    final currentUrl = json[injectedUrlKey] as String;

    final page0 = json["page"] as int;
    final pageCount0 = json["pageCount"] as int;

    String previousUrl;
    String nextUrl;

    if (currentUrl != null && page0 != null && pageCount0 != null) {
      if (page0 > 1) {
        previousUrl = makeUrl(url: currentUrl, page: page0 - 1);
      }
      if (page0 < pageCount0) {
        nextUrl = makeUrl(url: currentUrl, page: page0 + 1);
      }
    }

    return $paginatorClass(
      (json["data"] as List)
          ?.map(
            (item) => item == null 
                ? null 
                : $inputClass.fromJson(item as Map<String, dynamic>),
          )
          ?.toList(),
      json["total"] as int,
      previousUrl,
      nextUrl,
      json["count"] as int,
      page0,
      pageCount0,
    );
  }

  final int count;
  final int page;
  final int pageCount;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      "count": this.count,
      "total": this.totalCount,
      "page": this.page,
      "pageCount": this.pageCount,
      "data": this.results?.map((e) => e?.toJson())?.toList(),
    }; 
  }
}
""";
