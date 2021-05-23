enum PaginationStyle {
  django,
  enigmapi,
  nest,
}

class JsonPagination {
  const JsonPagination({
    this.styles = const <PaginationStyle>[PaginationStyle.django],
  });

  final List<PaginationStyle> styles;
}
