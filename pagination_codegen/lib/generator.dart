import 'dart:async';

import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';
import 'package:pagination_annotation/pagination_annotation.dart';

import 'util.dart';

class PaginationGenerator extends GeneratorForAnnotation<Pagination> {
  @override
  FutureOr<String> generateForAnnotatedElement(
    Element element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) {
    final typeValue = PaginationType.values.singleWhere(
      (PaginationType element) =>
          annotation
              .read('type')
              .objectValue
              .getField(element.toString().split('.')[1]) !=
          null,
    );

    final String inputClass = element.toString().split(' ')[1];
    final String paginatorClass = inputClass + 'Paginator';

    switch (typeValue) {
      case PaginationType.nest:
        return generateForNest(inputClass, paginatorClass);

      default:
        return '''
        
        ''';
    }
  }
}
