import "package:enigma_core/src/response/response.dart";
import "package:dio/dio.dart";

class ResponseDefaults {
  int attempts = 3;
  Dio client = Dio();
  NotifyKind notifyKind = NotifyKind.ifErr;
  NotifyType notifyType = NotifyType.success;

  String Function() successLabel = () => "Success";
  String Function() errorLabel = () => "Error";
  String Function() successMessage = () => "Action completed successfully";
  String Function() errorMessage =
      () => "An unexpected error has occurred, please try again";
}
