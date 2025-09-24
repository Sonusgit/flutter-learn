import 'package:get/get.dart';
import '../controllers/topic_controller.dart';
import '../services/api_service.dart';

class AppBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(ApiService(), permanent: true);
    // Get.put(TranslationController(), permanent: true);
    Get.put(TopicController());
  }
}
