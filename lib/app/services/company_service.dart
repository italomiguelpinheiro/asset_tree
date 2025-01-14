import 'package:asset_tree/app/models/asset.dart';
import 'package:asset_tree/app/models/company.dart';
import 'package:asset_tree/app/models/location.dart';
import 'package:dio/dio.dart';

final String baseUrl = "https://fake-api.tractian.com";

class CompanyService {
  final Dio dio;

  CompanyService({required this.dio});

  Future<List<Company>> getAll() async {
    final response = await dio.get('$baseUrl/companies');
    if (response.statusCode == 200) {
      List<Company> companies =
          (response.data as List<dynamic>).map((dynamic e) {
        return Company.fromJson(e);
      }).toList();

      return companies;
    } else {
      throw Exception('Failed to load companies');
    }
  }

  Future<List<Location>> getAllLocations({required int companyId}) async {
    final response = await dio.get('$baseUrl/companies/$companyId/locations');
    if (response.statusCode == 200) {
      List<Location> locations =
          (response.data as List<dynamic>).map((dynamic e) {
        return Location.fromJson(e);
      }).toList();

      return locations;
    } else {
      throw Exception('Failed to load locations');
    }
  }

  Future<List<Asset>> getAllAssets({required int companyId}) async {
    final response = await dio.get('$baseUrl/companies/$companyId/assets');
    if (response.statusCode == 200) {
      List<Asset> assets = (response.data as List<dynamic>).map((dynamic e) {
        return Asset.fromJson(e);
      }).toList();

      return assets;
    } else {
      throw Exception('Failed to load assets');
    }
  }
}
