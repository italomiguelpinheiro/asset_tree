import 'package:asset_tree/app/controllers/asset_controller.dart';
import 'package:asset_tree/app/controllers/home_controller.dart';
import 'package:asset_tree/app/database/database_repository.dart';
import 'package:asset_tree/app/services/company_service.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';

setUpHome() {
  Get.put(HomeController(
      companyService: CompanyService(dio: Dio(), db: DatabaseRepository())));
}
