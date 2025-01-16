import 'package:asset_tree/app/models/node.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AssetTreeWidget extends StatelessWidget {
  final List<TreeNode> tree;

  AssetTreeWidget({required this.tree});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
        child: Theme(
          data: Theme.of(context).copyWith(
            dividerColor: Colors.transparent,
          ),
          child: ListView(
            children: tree.map((node) => _buildTreeNode(node, 0)).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildTreeNode(TreeNode node, int depth) {
    final EdgeInsets margin = EdgeInsets.only(left: depth * 16.0);
    final bool hasChildren = node.children.isNotEmpty;

    return Container(
      margin: margin,
      child: hasChildren
          ? ExpansionTile(
              leading: _getImageForNode(node),
              title: _buildNodeTitle(node),
              children: node.children
                  .map((child) => _buildTreeNode(child, depth + 1))
                  .toList(),
            )
          : ListTile(
              leading: _getImageForNode(node),
              title: _buildNodeTitle(node),
            ),
    );
  }

  Widget _buildNodeTitle(TreeNode node) {
    return Container(
      constraints: BoxConstraints(maxWidth: 200.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              node.name,
            ),
          ),
          if (node.status == 'alert')
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Container(
                width: 10.0,
                height: 10.0,
                decoration: BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          if (node.sensorType == 'energy')
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Icon(
                Icons.bolt,
                color: Colors.green,
                size: 27.0,
              ),
            ),
        ],
      ),
    );
  }

  Widget _getImageForNode(TreeNode node) {
    switch (node.type) {
      case 'location':
        return SvgPicture.asset(
          'assets/images/location.svg',
        );
      case 'asset':
        return SvgPicture.asset(
          'assets/images/asset.svg',
        );
      default:
        return Image.asset('assets/images/component.png');
    }
  }
}
