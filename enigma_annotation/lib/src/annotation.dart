enum PaginationStyle {
  django,
  enigmapi,
  nest,
}

class JsonPagination {
  const JsonPagination({
    this.styles = const <PaginationStyle>[PaginationStyle.django],
    this.createFromJson = true,
    this.createToJson = false,
  });

  final List<PaginationStyle> styles;
  final bool createFromJson;
  final bool createToJson;
}
