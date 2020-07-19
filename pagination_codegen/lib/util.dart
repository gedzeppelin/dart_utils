String generateForDjango(String inputClass, String paginatorClass) => '''
TODO
''';

String generateForEnigmapi(String inputClass, String paginatorClass) => '''
TODO
''';

String generateForNest(String inputClass, String paginatorClass) => '''
class $paginatorClass implements Paginated<$inputClass>  {
  const $paginatorClass(
    this.count,
    this.total,
    this.page,
    this.pageCount,
    this.data,
  );

  factory $paginatorClass.withJson(Map<String, dynamic> json) {
    return $paginatorClass(
      json['count'] as int,
      json['total'] as int,
      json['page'] as int,
      json['pageCount'] as int,
      (json['data'] as List)
          ?.map(
            (item) => item == null 
                ? null 
                : $inputClass.fromJson(item as Map<String, dynamic>),
          )
          ?.toList(),
    );
  }

  final int count;
  final int total;
  final int page;
  final int pageCount;
  final List<$inputClass> data;

  List<$inputClass> get items => data;

  static $paginatorClass fromJson(Map<String, dynamic> json) {
    return $paginatorClass.withJson(json);
  }

  static List<$inputClass> listFromJson(Iterable json) {
    return json
        ?.map(
          (item) => item == null ? null : $inputClass.fromJson(item),
        )
        ?.toList();
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'count': this.count,
      'total': this.total,
      'page': this.page,
      'pageCount': this.pageCount,
      'data': this.data?.map((e) => e?.toJson())?.toList(),
    }; 
  }
}
''';
