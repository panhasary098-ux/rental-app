import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class PostPropertyController extends GetxController {
  final RxnInt selectIndex = RxnInt();
  final RxInt currentStep = 1.obs;
}
