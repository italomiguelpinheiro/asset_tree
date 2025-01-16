import 'package:asset_tree/app/models/asset.dart';
import 'package:asset_tree/app/models/location.dart';
import 'package:asset_tree/app/models/node.dart';

class Tree {
  List<Location> locations;
  List<Asset> assets;
  List<TreeNode> tree = [];

  Tree({required this.locations, required this.assets});

  void buildTree() {
    Map<String, TreeNode> locationNodes = {};
    Map<String, TreeNode> assetNodes = {};
    List<Location> orphanLocations = [];
    List<Asset> orphanAssets = [];

    _processLocations(locationNodes, orphanLocations);
    _resolveOrphanLocations(locationNodes, orphanLocations);

    _processAssets(locationNodes, assetNodes, orphanAssets);
    _resolveOrphanAssets(locationNodes, assetNodes, orphanAssets);
  }

  void _processLocations(
      Map<String, TreeNode> locationNodes, List<Location> orphanLocations) {
    for (var location in locations) {
      TreeNode node = _createNode(location.id, location.name, 'location');
      locationNodes[location.id] = node;

      if (location.parentId != null) {
        if (!_attachToParent(node, location.parentId, locationNodes)) {
          orphanLocations.add(location);
        }
      } else {
        tree.add(node);
      }
    }
  }

  void _resolveOrphanLocations(
      Map<String, TreeNode> locationNodes, List<Location> orphanLocations) {
    for (var orphan in orphanLocations) {
      if (locationNodes.containsKey(orphan.parentId)) {
        TreeNode parentNode = locationNodes[orphan.parentId]!;
        TreeNode orphanNode = locationNodes[orphan.id]!;
        parentNode.addChild(orphanNode);
      }
    }
  }

  void _processAssets(Map<String, TreeNode> locationNodes,
      Map<String, TreeNode> assetNodes, List<Asset> orphanAssets) {
    for (var asset in assets) {
      TreeNode node = _createNode(
        asset.id,
        asset.name,
        asset.sensorType != null ? 'component' : 'asset',
        sensorType: asset.sensorType,
        status: asset.status,
      );
      assetNodes[asset.id] = node;

      if (asset.locationId != null) {
        if (!_attachToParent(node, asset.locationId, locationNodes)) {
          orphanAssets.add(asset);
        }
      } else if (asset.parentId != null) {
        if (!_attachToParent(node, asset.parentId, assetNodes)) {
          orphanAssets.add(asset);
        }
      } else {
        tree.add(node);
      }
    }
  }

  void _resolveOrphanAssets(Map<String, TreeNode> locationNodes,
      Map<String, TreeNode> assetNodes, List<Asset> orphanAssets) {
    for (var orphan in orphanAssets) {
      TreeNode? parentNode =
          assetNodes[orphan.parentId] ?? locationNodes[orphan.locationId];
      if (parentNode != null) {
        TreeNode node = _createNode(
          orphan.id,
          orphan.name,
          orphan.sensorType != null ? 'component' : 'asset',
          sensorType: orphan.sensorType,
          status: orphan.status,
        );
        parentNode.addChild(node);
      }
    }
  }

  TreeNode _createNode(
    String id,
    String name,
    String type, {
    String? sensorType,
    String? status,
  }) {
    return TreeNode(
      id: id,
      name: name,
      type: type,
      children: [],
      sensorType: sensorType,
      status: status,
    );
  }

  bool _attachToParent(
      TreeNode node, String? parentId, Map<String, TreeNode> parentMap) {
    if (parentId != null && parentMap.containsKey(parentId)) {
      parentMap[parentId]?.addChild(node);
      return true;
    }
    return false;
  }
}
