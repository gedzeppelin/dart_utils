enum PaginationType {
  django,
  enigmapi,
  nest,
}

class Pagination {
  const Pagination({this.type = PaginationType.enigmapi});

  final PaginationType type;
}
