enum Style {
  django,
  enigmapi,
  nest,
}

class JsonPagination {
  const JsonPagination({
    this.styles = const <Style>[Style.enigmapi],
  });

  final List<Style> styles;
}
