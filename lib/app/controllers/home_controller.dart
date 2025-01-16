import 'package:asset_tree/app/models/company.dart';
import 'package:asset_tree/app/services/company_service.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  final CompanyService companyService;
  HomeController({required this.companyService});

  final List<Company> _companies = <Company>[].obs;
  List<Company> get companies => _companies;

  final RxBool _isLoadingCompanies = false.obs;
  RxBool get isLoadingCompanies => _isLoadingCompanies;

  Future<void> findAllCompanies() async {
    try {
      _isLoadingCompanies.value = true;

      List<Company> allCompanies = await companyService.getAll();
      _companies.addAll(allCompanies);
      isLoadingCompanies.value = false;
    } catch (e) {
      isLoadingCompanies.value = false;
      rethrow;
    }
  }
}
