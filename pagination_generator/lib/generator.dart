import 'dart:async';

import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:pagination_generator/util.dart';
import 'package:source_gen/source_gen.dart';

import 'annotation.dart';

class PaginationGenerator extends GeneratorForAnnotation<Paginated> {
  @override
  FutureOr<String> generateForAnnotatedElement(
    Element element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) {
    final typeValue = PaginatedType.values.singleWhere(
      (element) =>
          annotation
              .read('type')
              .objectValue
              .getField(element.toString().split('.')[1]) !=
          null,
    );

    final String inputClass = element.toString().split(' ')[1];
    final String paginatorClass = inputClass + 'Paginator';

    switch (typeValue) {
      case PaginatedType.nest:
        return generateForNest(inputClass, paginatorClass);

      default:
        return '''
        
        ''';
    }
  }
}
