class TreeNode {
  final String id;
  final String name;
  final String type;
  final String? status;
  final String? sensorType;
  final List<TreeNode> children;

  TreeNode({
    required this.id,
    required this.name,
    required this.type,
    this.sensorType,
    this.status,
    this.children = const [],
  });

  void addChild(TreeNode child) {
    children.add(child);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'children': children.map((child) => child.toJson()).toList(),
    };
  }
}
