import 'package:flutter/material.dart';

class Category {
  const Category({
    required this.id,
    required this.name,
    required this.color,
    required this.icon,
  });
  final String id;
  final String name;
  final Color color;
  final IconData icon;
}