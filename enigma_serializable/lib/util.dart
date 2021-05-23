import "package:enigma_annotation/enigma_annotation.dart";

String makePaginatorSuffix(PaginationStyle style, String inputClass) {
  switch (style) {
    case PaginationStyle.enigmapi:
      return "${inputClass}PaginatorEnigmapi";
    case PaginationStyle.django:
      return "${inputClass}PaginatorDjango";
    case PaginationStyle.nest:
      return "${inputClass}PaginatorNest";
    default:
      throw AssertionError("Unrecognized pagination style");
  }
}

String generatePaginator(
  PaginationStyle style,
  String inputClass,
  bool fromJson,
  bool toJson,
) {
  switch (style) {
    case PaginationStyle.enigmapi:
      return generateEnigmapi(inputClass, fromJson, toJson);
    case PaginationStyle.django:
      return generateDjango(inputClass, fromJson, toJson);
    case PaginationStyle.nest:
      return generateNest(inputClass, fromJson, toJson);
    default:
      throw AssertionError("Unrecognized pagination style");
  }
}

String generateDjango(String inputClass, bool fromJson, bool toJson) {
  String result = "";

  if (fromJson) {
    result += """
Paginator<$inputClass> _\$Pg${inputClass}FromJson(Map<String, dynamic> json) {
  return Paginator<$inputClass>(
    json["count"] as int,
    json["next"] as String?,
    json["previous"] as String?,
    (json["results"] as List)
        .map(
          (item) => $inputClass.fromJson(item as Map<String, dynamic>),
        )
        .toList(),
  );
}    
""";
  }

  if (toJson) {
    result += """
Map<String, dynamic> _\$Pg${inputClass}ToJson(Paginator<$inputClass> instance) {
  return <String, dynamic>{
    "count": instance.count,
    "next": instance.next,
    "previous": instance.previous,
    "results": instance.results.map((e) => e.toJson()).toList(),
  }; 
}
""";
  }

  return result;
}

String generateEnigmapi(String inputClass, bool fromJson, bool toJson) => """
// TODO
""";

String generateNest(String inputClass, bool fromJson, bool toJson) => """
// TODO
""";
