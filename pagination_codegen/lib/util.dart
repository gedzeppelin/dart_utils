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
    int count,
    this.next,
    this.previous,
    List<$inputClass> results,
  ) : super(results, count);

  final String next;
  final String previous;

  @override
  bool get haveNext => next != null;
  @override
  bool get havePrevious => previous != null;

  factory $paginatorClass.fromJson(Map<String, dynamic> json) {
    return $paginatorClass(
      json["count"] as int,
      json["next"] as String,
      json["previous"] as String,
      (json["results"] as List)
          ?.map(
            (item) => item == null 
                ? null 
                : $inputClass.fromJson(item as Map<String, dynamic>),
          )
          ?.toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      "count": this.totalCount,
      "next": this.next,
      "previous": this.previous,
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
    this.count,
    int total,
    this.page,
    this.pageCount,
  ) : super(data, total);

  final int count;
  final int page;
  final int pageCount;

  @override
  bool get haveNext => page < pageCount;
  @override
  bool get havePrevious => page > 1;

  factory $paginatorClass.fromJson(Map<String, dynamic> json) {
    return $paginatorClass(
      (json["data"] as List)
          ?.map(
            (item) => item == null 
                ? null 
                : $inputClass.fromJson(item as Map<String, dynamic>),
          )
          ?.toList(),
      json["count"] as int,
      json["total"] as int,
      json["page"] as int,
      json["pageCount"] as int,
    );
  }
  
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      "data": this.results?.map((e) => e?.toJson())?.toList(),
      "count": this.count,
      "total": this.totalCount,
      "page": this.page,
      "pageCount": this.pageCount,
    }; 
  }
}
""";
