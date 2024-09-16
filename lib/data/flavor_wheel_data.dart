// lib/data/flavor_wheel_data.dart

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class FlavorNode {
  final String name;
  final List<FlavorNode> children;
  final Color color;
  final IconData icon;

  FlavorNode({
    required this.name,
    this.children = const [],
    required this.color,
    required this.icon,
  });
}

// フレーバーホイールのデータ
final List<FlavorNode> flavorWheelData = [
  FlavorNode(
    name: 'Floral',
    color: Colors.pinkAccent,
    icon: FontAwesomeIcons.seedling,
    children: [
      FlavorNode(
        name: 'Black Tea',
        color: Colors.pink[200]!,
        icon: FontAwesomeIcons.mugHot,
      ),
      FlavorNode(
        name: 'Chamomile',
        color: Colors.pink[300]!,
        icon: FontAwesomeIcons.spa,
      ),
      FlavorNode(
        name: 'Rose',
        color: Colors.pink[400]!,
        icon: FontAwesomeIcons.spa,
      ),
      FlavorNode(
        name: 'Jasmine',
        color: Colors.pink[500]!,
        icon: FontAwesomeIcons.pagelines,
      ),
      FlavorNode(
        name: 'Honeysuckle',
        color: Colors.pink[600]!,
        icon: FontAwesomeIcons.seedling,
      ),
      FlavorNode(
        name: 'Lavender',
        color: Colors.pink[700]!,
        icon: FontAwesomeIcons.pagelines,
      ),
    ],
  ),
  FlavorNode(
    name: 'Fruity',
    color: Colors.redAccent,
    icon: FontAwesomeIcons.apple,
    children: [
      FlavorNode(
        name: 'Berry',
        color: Colors.red[300]!,
        icon: FontAwesomeIcons.seedling,
        children: [
          FlavorNode(
            name: 'Blackberry',
            color: Colors.red[200]!,
            icon: FontAwesomeIcons.seedling,
          ),
          FlavorNode(
            name: 'Raspberry',
            color: Colors.red[300]!,
            icon: FontAwesomeIcons.seedling,
          ),
          FlavorNode(
            name: 'Blueberry',
            color: Colors.red[400]!,
            icon: FontAwesomeIcons.seedling,
          ),
          FlavorNode(
            name: 'Strawberry',
            color: Colors.red[500]!,
            icon: FontAwesomeIcons.seedling,
          ),
          FlavorNode(
            name: 'Cranberry',
            color: Colors.red[600]!,
            icon: FontAwesomeIcons.seedling,
          ),
          FlavorNode(
            name: 'Gooseberry',
            color: Colors.red[700]!,
            icon: FontAwesomeIcons.seedling,
          ),
          FlavorNode(
            name: 'Red Currant',
            color: Colors.red[800]!,
            icon: FontAwesomeIcons.seedling,
          ),
        ],
      ),
      FlavorNode(
        name: 'Dried Fruit',
        color: Colors.orangeAccent,
        icon: FontAwesomeIcons.apple,
        children: [
          FlavorNode(
            name: 'Raisin',
            color: Colors.orange[200]!,
            icon: FontAwesomeIcons.apple,
          ),
          FlavorNode(
            name: 'Prune',
            color: Colors.orange[300]!,
            icon: FontAwesomeIcons.apple,
          ),
          FlavorNode(
            name: 'Date',
            color: Colors.orange[400]!,
            icon: FontAwesomeIcons.apple,
          ),
          FlavorNode(
            name: 'Fig',
            color: Colors.orange[500]!,
            icon: FontAwesomeIcons.apple,
          ),
        ],
      ),
      FlavorNode(
        name: 'Other Fruit',
        color: Colors.yellowAccent,
        icon: FontAwesomeIcons.lemon,
        children: [
          FlavorNode(
            name: 'Coconut',
            color: Colors.yellow[200]!,
            icon: FontAwesomeIcons.lemon,
          ),
          FlavorNode(
            name: 'Cherry',
            color: Colors.yellow[300]!,
            icon: FontAwesomeIcons.lemon,
          ),
          FlavorNode(
            name: 'Pomegranate',
            color: Colors.yellow[400]!,
            icon: FontAwesomeIcons.lemon,
          ),
          FlavorNode(
            name: 'Pineapple',
            color: Colors.yellow[500]!,
            icon: FontAwesomeIcons.lemon,
          ),
          FlavorNode(
            name: 'Grape',
            color: Colors.yellow[600]!,
            icon: FontAwesomeIcons.lemon,
          ),
          FlavorNode(
            name: 'Apple',
            color: Colors.yellow[700]!,
            icon: FontAwesomeIcons.appleAlt,
          ),
          FlavorNode(
            name: 'Peach',
            color: Colors.yellow[800]!,
            icon: FontAwesomeIcons.lemon,
          ),
          FlavorNode(
            name: 'Pear',
            color: Colors.yellow[900]!,
            icon: FontAwesomeIcons.lemon,
          ),
          FlavorNode(
            name: 'Apricot',
            color: Colors.amber[300]!,
            icon: FontAwesomeIcons.lemon,
          ),
          FlavorNode(
            name: 'Blackcurrant',
            color: Colors.amber[400]!,
            icon: FontAwesomeIcons.lemon,
          ),
        ],
      ),
      FlavorNode(
        name: 'Citrus Fruit',
        color: Colors.orangeAccent,
        icon: FontAwesomeIcons.lemon,
        children: [
          FlavorNode(
            name: 'Grapefruit',
            color: Colors.orange[200]!,
            icon: FontAwesomeIcons.lemon,
          ),
          FlavorNode(
            name: 'Orange',
            color: Colors.orange[300]!,
            icon: FontAwesomeIcons.lemon,
          ),
          FlavorNode(
            name: 'Lemon',
            color: Colors.orange[400]!,
            icon: FontAwesomeIcons.lemon,
          ),
          FlavorNode(
            name: 'Lime',
            color: Colors.orange[500]!,
            icon: FontAwesomeIcons.lemon,
          ),
          FlavorNode(
            name: 'Tangerine',
            color: Colors.orange[600]!,
            icon: FontAwesomeIcons.lemon,
          ),
          FlavorNode(
            name: 'Mandarin',
            color: Colors.orange[700]!,
            icon: FontAwesomeIcons.lemon,
          ),
        ],
      ),
      FlavorNode(
        name: 'Stone Fruit',
        color: Colors.deepOrangeAccent,
        icon: FontAwesomeIcons.lemon,
        children: [
          FlavorNode(
            name: 'Peach',
            color: Colors.deepOrange[200]!,
            icon: FontAwesomeIcons.lemon,
          ),
          FlavorNode(
            name: 'Plum',
            color: Colors.deepOrange[300]!,
            icon: FontAwesomeIcons.lemon,
          ),
          FlavorNode(
            name: 'Nectarine',
            color: Colors.deepOrange[400]!,
            icon: FontAwesomeIcons.lemon,
          ),
        ],
      ),
      FlavorNode(
        name: 'Tropical Fruit',
        color: Colors.lightGreenAccent,
        icon: FontAwesomeIcons.lemon,
        children: [
          FlavorNode(
            name: 'Lychee',
            color: Colors.lightGreen[200]!,
            icon: FontAwesomeIcons.lemon,
          ),
          FlavorNode(
            name: 'Mango',
            color: Colors.lightGreen[300]!,
            icon: FontAwesomeIcons.lemon,
          ),
          FlavorNode(
            name: 'Papaya',
            color: Colors.lightGreen[400]!,
            icon: FontAwesomeIcons.lemon,
          ),
          FlavorNode(
            name: 'Passion Fruit',
            color: Colors.lightGreen[500]!,
            icon: FontAwesomeIcons.lemon,
          ),
          FlavorNode(
            name: 'Pineapple',
            color: Colors.lightGreen[600]!,
            icon: FontAwesomeIcons.lemon,
          ),
        ],
      ),
      FlavorNode(
        name: 'Melon',
        color: Colors.greenAccent,
        icon: FontAwesomeIcons.lemon,
        children: [
          FlavorNode(
            name: 'Watermelon',
            color: Colors.green[200]!,
            icon: FontAwesomeIcons.lemon,
          ),
          FlavorNode(
            name: 'Cantaloupe',
            color: Colors.green[300]!,
            icon: FontAwesomeIcons.lemon,
          ),
          FlavorNode(
            name: 'Honeydew',
            color: Colors.green[400]!,
            icon: FontAwesomeIcons.lemon,
          ),
        ],
      ),
    ],
  ),
  FlavorNode(
    name: 'Sour/Fermented',
    color: Colors.purpleAccent,
    icon: FontAwesomeIcons.wineGlass,
    children: [
      FlavorNode(
        name: 'Sour',
        color: Colors.purple[300]!,
        icon: FontAwesomeIcons.wineGlass,
        children: [
          FlavorNode(
            name: 'Sour Aromatics',
            color: Colors.purple[200]!,
            icon: FontAwesomeIcons.wineGlass,
          ),
          FlavorNode(
            name: 'Acetic Acid',
            color: Colors.purple[300]!,
            icon: FontAwesomeIcons.wineGlass,
          ),
          FlavorNode(
            name: 'Butyric Acid',
            color: Colors.purple[400]!,
            icon: FontAwesomeIcons.wineGlass,
          ),
          FlavorNode(
            name: 'Isovaleric Acid',
            color: Colors.purple[500]!,
            icon: FontAwesomeIcons.wineGlass,
          ),
          FlavorNode(
            name: 'Citric Acid',
            color: Colors.purple[600]!,
            icon: FontAwesomeIcons.wineGlass,
          ),
          FlavorNode(
            name: 'Malic Acid',
            color: Colors.purple[700]!,
            icon: FontAwesomeIcons.wineGlass,
          ),
          FlavorNode(
            name: 'Tartaric Acid',
            color: Colors.purple[800]!,
            icon: FontAwesomeIcons.wineGlass,
          ),
        ],
      ),
      FlavorNode(
        name: 'Alcohol/Fermented',
        color: Colors.deepPurpleAccent,
        icon: FontAwesomeIcons.wineBottle,
        children: [
          FlavorNode(
            name: 'Winey',
            color: Colors.deepPurple[300]!,
            icon: FontAwesomeIcons.wineBottle,
          ),
          FlavorNode(
            name: 'Whiskey',
            color: Colors.deepPurple[400]!,
            icon: FontAwesomeIcons.wineBottle,
          ),
          FlavorNode(
            name: 'Fermented',
            color: Colors.deepPurple[500]!,
            icon: FontAwesomeIcons.wineBottle,
          ),
          FlavorNode(
            name: 'Overripe',
            color: Colors.deepPurple[600]!,
            icon: FontAwesomeIcons.wineBottle,
          ),
        ],
      ),
    ],
  ),
  FlavorNode(
    name: 'Green/Vegetative',
    color: Colors.lightGreen,
    icon: FontAwesomeIcons.leaf,
    children: [
      FlavorNode(
        name: 'Olive Oil',
        color: Colors.lightGreen[200]!,
        icon: FontAwesomeIcons.leaf,
      ),
      FlavorNode(
        name: 'Raw',
        color: Colors.lightGreen[300]!,
        icon: FontAwesomeIcons.leaf,
      ),
      FlavorNode(
        name: 'Green Vegetables',
        color: Colors.lightGreen[400]!,
        icon: FontAwesomeIcons.leaf,
        children: [
          FlavorNode(
            name: 'Under-ripe',
            color: Colors.lightGreen[500]!,
            icon: FontAwesomeIcons.leaf,
          ),
          FlavorNode(
            name: 'Peapod',
            color: Colors.lightGreen[600]!,
            icon: FontAwesomeIcons.leaf,
          ),
          FlavorNode(
            name: 'Fresh',
            color: Colors.lightGreen[700]!,
            icon: FontAwesomeIcons.leaf,
          ),
          FlavorNode(
            name: 'Dark Green',
            color: Colors.lightGreen[800]!,
            icon: FontAwesomeIcons.leaf,
          ),
          FlavorNode(
            name: 'Vegetative',
            color: Colors.lightGreen[900]!,
            icon: FontAwesomeIcons.leaf,
          ),
          FlavorNode(
            name: 'Hay-like',
            color: Colors.green[300]!,
            icon: FontAwesomeIcons.leaf,
          ),
          FlavorNode(
            name: 'Herb-like',
            color: Colors.green[400]!,
            icon: FontAwesomeIcons.leaf,
          ),
        ],
      ),
      FlavorNode(
        name: 'Beany',
        color: Colors.lightGreen[500]!,
        icon: FontAwesomeIcons.leaf,
      ),
      FlavorNode(
        name: 'Vegetal',
        color: Colors.lightGreen[600]!,
        icon: FontAwesomeIcons.leaf,
      ),
    ],
  ),
  FlavorNode(
    name: 'Other',
    color: Colors.grey,
    icon: FontAwesomeIcons.questionCircle,
    children: [
      FlavorNode(
        name: 'Papery/Musty',
        color: Colors.grey[400]!,
        icon: FontAwesomeIcons.paperPlane,
        children: [
          FlavorNode(
            name: 'Stale',
            color: Colors.grey[500]!,
            icon: FontAwesomeIcons.paperPlane,
          ),
          FlavorNode(
            name: 'Cardboard',
            color: Colors.grey[600]!,
            icon: FontAwesomeIcons.paperPlane,
          ),
          FlavorNode(
            name: 'Papery',
            color: Colors.grey[700]!,
            icon: FontAwesomeIcons.paperPlane,
          ),
          FlavorNode(
            name: 'Woody',
            color: Colors.grey[800]!,
            icon: FontAwesomeIcons.tree,
          ),
          FlavorNode(
            name: 'Corky',
            color: Colors.grey[900]!,
            icon: FontAwesomeIcons.paperPlane,
          ),
          FlavorNode(
            name: 'Moldy/Damp', 
            color: Colors.brown[300]!,
            icon: FontAwesomeIcons.paperPlane,
          ),
          FlavorNode(
            name: 'Musty/Dusty', //日本語で「カビっぽい」
            color: Colors.brown[400]!,
            icon: FontAwesomeIcons.paperPlane,
          ),
          FlavorNode(
            name: 'Musty/Earthy', //日本語で「カビっぽい/土っぽい」
            color: Colors.brown[500]!,
            icon: FontAwesomeIcons.paperPlane,
          ),
          FlavorNode(
            name: 'Animalic',
            color: Colors.brown[600]!,
            icon: FontAwesomeIcons.paw,
          ),
          FlavorNode(
            name: 'Meaty Brothy',
            color: Colors.brown[700]!,
            icon: FontAwesomeIcons.drumstickBite,
          ),
          FlavorNode(
            name: 'Phenolic',
            color: Colors.brown[800]!,
            icon: FontAwesomeIcons.flask,
          ),
        ],
      ),
      FlavorNode(
        name: 'Chemical',
        color: Colors.blueGrey,
        icon: FontAwesomeIcons.flask,
        children: [
          FlavorNode(
            name: 'Bitter',
            color: Colors.blueGrey[300]!,
            icon: FontAwesomeIcons.flask,
          ),
          FlavorNode(
            name: 'Salty',
            color: Colors.blueGrey[400]!,
            icon: FontAwesomeIcons.flask,
          ),
          FlavorNode(
            name: 'Medicinal',
            color: Colors.blueGrey[500]!,
            icon: FontAwesomeIcons.pills,
          ),
          FlavorNode(
            name: 'Petroleum',
            color: Colors.blueGrey[600]!,
            icon: FontAwesomeIcons.oilCan,
          ),
          FlavorNode(
            name: 'Skunky',
            color: Colors.blueGrey[700]!,
            icon: FontAwesomeIcons.skullCrossbones,
          ),
          FlavorNode(
            name: 'Rubber',
            color: Colors.blueGrey[800]!,
            icon: FontAwesomeIcons.shoePrints,
          ),
          FlavorNode(
            name: 'Garlic/Onion',
            color: Colors.blueGrey[900]!,
            icon: FontAwesomeIcons.utensils,
          ),
          FlavorNode(
            name: 'Green/Grassy',
            color: Colors.green[300]!,
            icon: FontAwesomeIcons.leaf,
          ),
        ],
      ),
    ],
  ),
  FlavorNode(
    name: 'Sweet',
    color: Colors.amber,
    icon: FontAwesomeIcons.candyCane,
    children: [
      FlavorNode(
        name: 'Brown Sugar',
        color: Colors.amber[200]!,
        icon: FontAwesomeIcons.cookie,
      ),
      FlavorNode(
        name: 'Molasses',
        color: Colors.amber[300]!,
        icon: FontAwesomeIcons.cookie,
      ),
      FlavorNode(
        name: 'Maple Syrup',
        color: Colors.amber[400]!,
        icon: FontAwesomeIcons.cookie,
      ),
      FlavorNode(
        name: 'Caramelized',
        color: Colors.amber[500]!,
        icon: FontAwesomeIcons.cookie,
      ),
      FlavorNode(
        name: 'Honey',
        color: Colors.amber[600]!,
        icon: FontAwesomeIcons.cookie,
      ),
      FlavorNode(
        name: 'Vanilla',
        color: Colors.amber[700]!,
        icon: FontAwesomeIcons.cookie,
      ),
    ],
  ),
  FlavorNode(
    name: 'Nutty/Cocoa',
    color: Colors.brown,
    icon: FontAwesomeIcons.nutritionix,
    children: [
      FlavorNode(
        name: 'Nutty',
        color: Colors.brown[300]!,
        icon: FontAwesomeIcons.nutritionix,
        children: [
          FlavorNode(
            name: 'Peanuts',
            color: Colors.brown[400]!,
            icon: FontAwesomeIcons.nutritionix,
          ),
          FlavorNode(
            name: 'Hazelnut',
            color: Colors.brown[500]!,
            icon: FontAwesomeIcons.nutritionix,
          ),
          FlavorNode(
            name: 'Almond',
            color: Colors.brown[600]!,
            icon: FontAwesomeIcons.nutritionix,
          ),
          FlavorNode(
            name: 'Walnut',
            color: Colors.brown[700]!,
            icon: FontAwesomeIcons.nutritionix,
          ),
        ],
      ),
      FlavorNode(
        name: 'Cocoa',
        color: Colors.brown[800]!,
        icon: FontAwesomeIcons.candyCane,
        children: [
          FlavorNode(
            name: 'Chocolate',
            color: Colors.brown[900]!,
            icon: FontAwesomeIcons.candyCane,
          ),
          FlavorNode(
            name: 'Dark Chocolate',
            color: Colors.brown[900]!,
            icon: FontAwesomeIcons.candyCane,
          ),
          FlavorNode(
            name: 'Milk Chocolate',
            color: Colors.brown[800]!,
            icon: FontAwesomeIcons.candyCane,
          ),
          FlavorNode(
            name: 'Cacao Nibs',
            color: Colors.brown[700]!,
            icon: FontAwesomeIcons.candyCane,
          ),
        ],
      ),
    ],
  ),
  FlavorNode(
    name: 'Spices',
    color: Colors.deepOrange,
    icon: FontAwesomeIcons.pepperHot,
    children: [
      FlavorNode(
        name: 'Pungent',
        color: Colors.deepOrange[300]!,
        icon: FontAwesomeIcons.pepperHot,
        children: [
          FlavorNode(
            name: 'Black Pepper',
            color: Colors.deepOrange[400]!,
            icon: FontAwesomeIcons.pepperHot,
          ),
          FlavorNode(
            name: 'White Pepper',
            color: Colors.deepOrange[500]!,
            icon: FontAwesomeIcons.pepperHot,
          ),
        ],
      ),
      FlavorNode(
        name: 'Brown Spice',
        color: Colors.deepOrange[600]!,
        icon: FontAwesomeIcons.pepperHot,
        children: [
          FlavorNode(
            name: 'Anise',
            color: Colors.deepOrange[700]!,
            icon: FontAwesomeIcons.pepperHot,
          ),
          FlavorNode(
            name: 'Nutmeg',
            color: Colors.deepOrange[800]!,
            icon: FontAwesomeIcons.pepperHot,
          ),
          FlavorNode(
            name: 'Cinnamon',
            color: Colors.deepOrange[900]!,
            icon: FontAwesomeIcons.pepperHot,
          ),
          FlavorNode(
            name: 'Clove',
            color: Colors.deepOrangeAccent,
            icon: FontAwesomeIcons.pepperHot,
          ),
          FlavorNode(
            name: 'Allspice',
            color: Colors.deepOrangeAccent[400]!,
            icon: FontAwesomeIcons.pepperHot,
          ),
        ],
      ),
    ],
  ),
  FlavorNode(
    name: 'Roasted',
    color: Colors.brown[800]!,
    icon: FontAwesomeIcons.fire,
    children: [
      FlavorNode(
        name: 'Pipe Tobacco',
        color: Colors.brown[700]!,
        icon: FontAwesomeIcons.fire,
      ),
      FlavorNode(
        name: 'Tobacco',
        color: Colors.brown[600]!,
        icon: FontAwesomeIcons.fire,
      ),
      FlavorNode(
        name: 'Burnt',
        color: Colors.brown[500]!,
        icon: FontAwesomeIcons.fire,
      ),
      FlavorNode(
        name: 'Smoky',
        color: Colors.brown[400]!,
        icon: FontAwesomeIcons.fire,
      ),
      FlavorNode(
        name: 'Acrid',
        color: Colors.brown[300]!,
        icon: FontAwesomeIcons.fire,
      ),
      FlavorNode(
        name: 'Ashy',
        color: Colors.brown[200]!,
        icon: FontAwesomeIcons.fire,
      ),
    ],
  ),
  FlavorNode(
    name: 'Cereal',
    color: Colors.yellow[700]!,
    icon: FontAwesomeIcons.breadSlice,
    children: [
      FlavorNode(
        name: 'Grain',
        color: Colors.yellow[600]!,
        icon: FontAwesomeIcons.breadSlice,
      ),
      FlavorNode(
        name: 'Malt',
        color: Colors.yellow[500]!,
        icon: FontAwesomeIcons.breadSlice,
      ),
      FlavorNode(
        name: 'Oats',
        color: Colors.yellow[400]!,
        icon: FontAwesomeIcons.breadSlice,
      ),
      FlavorNode(
        name: 'Wheat',
        color: Colors.yellow[300]!,
        icon: FontAwesomeIcons.breadSlice,
      ),
      FlavorNode(
        name: 'Rye',
        color: Colors.yellow[200]!,
        icon: FontAwesomeIcons.breadSlice,
      ),
    ],
  ),
  FlavorNode(
    name: 'Woody',
    color: Colors.brown[600]!,
    icon: FontAwesomeIcons.tree,
    children: [
      FlavorNode(
        name: 'Oak',
        color: Colors.brown[500]!,
        icon: FontAwesomeIcons.tree,
      ),
      FlavorNode(
        name: 'Cedar',
        color: Colors.brown[400]!,
        icon: FontAwesomeIcons.tree,
      ),
      FlavorNode(
        name: 'Pine',
        color: Colors.brown[300]!,
        icon: FontAwesomeIcons.tree,
      ),
    ],
  ),
  FlavorNode(
    name: 'Earthy',
    color: Colors.green[700]!,
    icon: FontAwesomeIcons.mountain,
    children: [
      FlavorNode(
        name: 'Mushroom',
        color: Colors.green[600]!,
        icon: FontAwesomeIcons.mountain,
      ),
      FlavorNode(
        name: 'Humus',
        color: Colors.green[500]!,
        icon: FontAwesomeIcons.mountain,
      ),
      FlavorNode(
        name: 'Wet Soil',
        color: Colors.green[400]!,
        icon: FontAwesomeIcons.mountain,
      ),
    ],
  ),
];

