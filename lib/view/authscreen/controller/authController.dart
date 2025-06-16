import 'package:fidelityride/api/api_repository.dart';
import 'package:get/get.dart';

import '../../../route/routePath.dart';

class LoginController extends GetxController {
  late APIRepository apiRepository;

  var phone = "";
  @override
  void onInit() {
    super.onInit();
    apiRepository = APIRepository.instance;
  }  

  Future<void> login() async {
    Map data = {"username": phone};
    apiRepository.login(data).then((value) async {
      var response = value.responseBody;
      if (response != null) {
        // Get.toNamed(RoutePath.otpVerification);
      }
    });
  }
}
