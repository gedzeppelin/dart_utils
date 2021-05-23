import "dart:async";

import "package:enigma_annotation/enigma_annotation.dart";
import "package:source_gen/source_gen.dart";

import "util.dart";

class PaginationGenerator extends GeneratorForAnnotation<JsonPagination> {
  @override
  FutureOr<String> generateForAnnotatedElement(element, annotation, buildStep) {
    final styles = annotation.read("styles").listValue.map(
          (object) => PaginationStyle.values.firstWhere(
            (backend) {
              final backendString = backend.toString().split(".")[1];
              return object.getField(backendString) != null;
            },
          ),
        );

    final fromJson = annotation.read("createFromJson").boolValue;
    final toJson = annotation.read("createToJson").boolValue;

    final String? inputClass = element.name;

    if (inputClass == null) {
      throw new Error();
    }

    if (styles.length == 0) {
      throw AssertionError("At least one pagination style");
    } else if (styles.length == 1) {
      return generatePaginator(styles.single, inputClass, fromJson, toJson);
    } else {
      return styles
          .map((s) => generatePaginator(s, inputClass, fromJson, toJson))
          .join("\n");
    }
  }
}
