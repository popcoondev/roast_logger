// data/flavor_wheel_data.dart

class FlavorNode {
  final String name;
  final List<FlavorNode> children;

  FlavorNode({required this.name, this.children = const []});
}

// フレーバーホイールのデータ
final List<FlavorNode> flavorWheelData = [
  FlavorNode(
    name: 'Fruity',
    children: [
      FlavorNode(
        name: 'Citrus Fruit',
        children: [
          FlavorNode(name: 'Lemon'),
          FlavorNode(name: 'Lime'),
          FlavorNode(name: 'Grapefruit'),
        ],
      ),
      FlavorNode(
        name: 'Berry',
        children: [
          FlavorNode(name: 'Strawberry'),
          FlavorNode(name: 'Blueberry'),
          FlavorNode(name: 'Raspberry'),
        ],
      ),
    ],
  ),
  FlavorNode(
    name: 'Floral',
    children: [
      FlavorNode(name: 'Jasmine'),
      FlavorNode(name: 'Rose'),
      FlavorNode(name: 'Lavender'),
    ],
  ),
  FlavorNode(name: 'Herbaceous', children: [
    FlavorNode(name: 'Mint'),
    FlavorNode(name: 'Basil'),
    FlavorNode(name: 'Cilantro'),
  ]),
];
