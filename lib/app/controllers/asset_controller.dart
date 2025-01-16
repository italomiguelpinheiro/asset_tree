import 'package:get/get.dart';
import 'package:asset_tree/app/models/asset.dart';
import 'package:asset_tree/app/models/location.dart';
import 'package:asset_tree/app/models/node.dart';
import 'package:asset_tree/app/models/tree.dart';
import 'package:asset_tree/app/services/company_service.dart';

class AssetController extends GetxController {
  RxBool isEnergySensorSelected = false.obs;
  RxBool isCriticalSelected = false.obs;
  RxBool isLoadingData = false.obs;
  RxList<TreeNode> filteredTree = <TreeNode>[].obs;
  late List<Location> locations;
  late List<Asset> assets;
  late Tree treeBuilder;

  final CompanyService companyService;

  AssetController({required this.companyService});

  Future<void> fetchLocationsAndAssets(String companyId) async {
    try {
      isLoadingData.value = true;
      Future<List<Location>> locationsFuture =
          companyService.getAllLocations(companyId: companyId);
      Future<List<Asset>> assetsFuture =
          companyService.getAllAssets(companyId: companyId);

      final results = await Future.wait([locationsFuture, assetsFuture]);
      locations = results[0] as List<Location>;
      assets = results[1] as List<Asset>;

      treeBuilder = Tree(locations: locations, assets: assets);
      treeBuilder.buildTree();

      filteredTree.value = treeBuilder.tree;
      isLoadingData.value = false;
    } catch (e) {
      isLoadingData.value = false;
      rethrow;
    }
  }

  void applyFilters(String query) {
    List<TreeNode> newTree = treeBuilder.tree;

    if (query.isNotEmpty) {
      newTree = _filterBySearch(query, newTree);
    }

    if (isEnergySensorSelected.value) {
      newTree = _filterBySensorType("energy", newTree);
    }

    if (isCriticalSelected.value) {
      newTree = _filterByStatus("alert", newTree);
    }

    filteredTree.value = newTree;
  }

  List<TreeNode> _filterTree(
    List<TreeNode> nodes,
    bool Function(TreeNode node) predicate,
  ) {
    return nodes
        .map((node) {
          final filteredChildren = predicate(node)
              ? node.children
              : _filterTree(node.children, predicate);

          if (predicate(node) || filteredChildren.isNotEmpty) {
            return TreeNode(
              id: node.id,
              name: node.name,
              type: node.type,
              sensorType: node.sensorType,
              status: node.status,
              children: filteredChildren,
            );
          }
          return null;
        })
        .whereType<TreeNode>()
        .toList();
  }

  List<TreeNode> _filterBySearch(String query, List<TreeNode> nodes) {
    return _filterTree(
        nodes, (node) => node.name.toLowerCase().contains(query.toLowerCase()));
  }

  List<TreeNode> _filterBySensorType(String sensorType, List<TreeNode> nodes) {
    return _filterTree(nodes, (node) => node.sensorType == sensorType);
  }

  List<TreeNode> _filterByStatus(String status, List<TreeNode> nodes) {
    return _filterTree(nodes, (node) => node.status == status);
  }
}
