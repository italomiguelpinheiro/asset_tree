import 'package:asset_tree/app/controllers/asset_controller.dart';
import 'package:asset_tree/app/database/database_repository.dart';
import 'package:asset_tree/app/services/company_service.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';

setUpAsset() {
  Get.put<AssetController>(AssetController(
    companyService: CompanyService(dio: Dio(), db: DatabaseRepository()),
  ));
}
