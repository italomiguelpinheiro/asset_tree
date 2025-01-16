import 'package:asset_tree/app/database/database_repository.dart';
import 'package:asset_tree/app/models/asset.dart';
import 'package:asset_tree/app/models/company.dart';
import 'package:asset_tree/app/models/location.dart';
import 'package:asset_tree/constants/base_url.dart';
import 'package:asset_tree/constants/conection.dart';
import 'package:dio/dio.dart';

class CompanyService {
  final Dio dio;
  final DatabaseRepository db;

  CompanyService({required this.dio, required this.db});

  Future<List<Company>> getAll() async {
    bool hasInternet = await isOnline();
    if (!hasInternet) {
      return await db.getCompanies();
    }

    final response = await dio.get('$baseUrl/companies');
    if (response.statusCode != 200) {
      throw Exception('Failed to load companies');
    }

    List<Company> companies = (response.data as List<dynamic>).map((dynamic e) {
      return Company.fromJson(e);
    }).toList();

    for (var company in companies) {
      await db.insertCompany(company);
    }

    return companies;
  }

  Future<List<Location>> getAllLocations({required String companyId}) async {
    bool hasInternet = await isOnline();
    if (!hasInternet) {
      return await db.getLocations(companyId);
    }
    final response = await dio.get('$baseUrl/companies/$companyId/locations');
    if (response.statusCode != 200) {
      throw Exception('Failed to load locations');
    }

    List<Location> locations = (response.data as List<dynamic>)
        .map((e) => Location.fromJson(e))
        .toList();

    await db.insertLocations(locations, companyId);
    return locations;
  }

  Future<List<Asset>> getAllAssets({required String companyId}) async {
    bool hasInternet = await isOnline();
    if (!hasInternet) {
      return await db.getAssets(companyId);
    }
    final response = await dio.get('$baseUrl/companies/$companyId/assets');
    if (response.statusCode != 200) {
      throw Exception('Failed to load assets');
    }

    List<Asset> assets =
        (response.data as List<dynamic>).map((e) => Asset.fromJson(e)).toList();

    await db.insertAssets(assets, companyId);
    return assets;
  }
}
