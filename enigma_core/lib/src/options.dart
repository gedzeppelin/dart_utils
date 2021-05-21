import "package:enigma_core/src/response/response.dart";
import "package:http/http.dart";

class ResponseDefaults {
  int attempts = 3;
  Client client = Client();
  NotifyKinds notifyKind = NotifyKinds.ifErr;
  NotifyType notifyType = NotifyType.success;

  String Function() successLabel = () => "Success";
  String Function() errorLabel = () => "Error";
  String Function() successMessage = () => "Action completed successfully";
  String Function() errorMessage =
      () => "An unexpected error has occurred, please try again";
}
