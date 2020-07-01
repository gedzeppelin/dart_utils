import 'package:meta/meta.dart';

enum PaginatedType {
  django,
  enigmapi,
  nest,
}

class Paginated {
  const Paginated({@required this.type});

  final PaginatedType type;
}
