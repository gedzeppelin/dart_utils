library enigma_core;

import "package:enigma_core/src/options.dart";
import "package:enigma_core/src/response/response.dart";

// ANCHOR Enigma dart core.

export "src/response/response.dart";

// ANCHOR Enigma dart core utilities.

export "src/util.dart";

final defaults = EgOptions._internal();

class EgOptions {
  EgOptions._internal();

  final ResponseDefaults response = ResponseDefaults();

  Notifier? notifier;

  factory EgOptions() {
    return defaults;
  }
}
