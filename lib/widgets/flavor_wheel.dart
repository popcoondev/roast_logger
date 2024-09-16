// widgets/flavor_wheel.dart

import 'package:flutter/material.dart';
import '../data/flavor_wheel_data.dart';

class FlavorWheel extends StatefulWidget {
  final Function(List<String>) onSelectionChanged;

  const FlavorWheel({Key? key, required this.onSelectionChanged}) : super(key: key);

  @override
  _FlavorWheelState createState() => _FlavorWheelState();
}

class _FlavorWheelState extends State<FlavorWheel> {
  List<String> _selectedFlavors = [];

  void _onFlavorTapped(String flavor) {
    setState(() {
      if (_selectedFlavors.contains(flavor)) {
        _selectedFlavors.remove(flavor);
      } else {
        _selectedFlavors.add(flavor);
      }
    });
    widget.onSelectionChanged(_selectedFlavors);
  }

  Widget _buildFlavorNode(FlavorNode node, {int level = 0}) {
    bool isSelected = _selectedFlavors.contains(node.name);
    return ListTile(
      leading: SizedBox(
        width: level * 16.0,
      ),
      title: Text(node.name),
      trailing: isSelected ? const Icon(Icons.check, color: Colors.green) : null,
      onTap: () {
        if (node.children.isEmpty) {
          _onFlavorTapped(node.name);
        }
      },
    );
  }

  Widget _buildFlavorList(List<FlavorNode> nodes, {int level = 0}) {
    return Column(
      children: nodes.map((node) {
        if (node.children.isEmpty) {
          return _buildFlavorNode(node, level: level);
        } else {
          return ExpansionTile(
            leading: SizedBox(
              width: level * 16.0,
            ),
            title: Text(node.name),
            children: node.children
                .map((child) => _buildFlavorList([child], level: level + 1))
                .toList(),
          );
        }
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildFlavorList(flavorWheelData);
  }
}
