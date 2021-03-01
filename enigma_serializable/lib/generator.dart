import "dart:async";

import "package:analyzer/dart/element/element.dart";
import "package:build/build.dart";
import "package:enigma_annotation/enigma_annotation.dart";
import "package:source_gen/source_gen.dart";

import "util.dart";

class PaginationGenerator extends GeneratorForAnnotation<JsonPagination> {
  @override
  FutureOr<String> generateForAnnotatedElement(
    Element element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) {
    final styles = annotation.read("styles").listValue.map(
          (object) => Style.values.firstWhere(
            (backend) {
              final backendString = backend.toString().split(".")[1];
              return object.getField(backendString) != null;
            },
          ),
        );

    final String inputClass = element.name;

    if (styles.length == 0) {
      throw AssertionError("Must specify at least one backend");
    } else if (styles.length == 1) {
      final String paginatorClass = "${inputClass}Paginator";
      return makePaginatorClass(styles.single, inputClass, paginatorClass);
    } else {
      return styles
          .map((style) => makePaginatorClass(
                style,
                inputClass,
                makePaginatorSuffix(style, inputClass),
              ))
          .join("\n");
    }
  }
}
