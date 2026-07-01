import 'package:flutter/material.dart';
import '../models/category.dart';

const categories = <Category>[
  Category(id: 'food', name: 'Lebensmittel', icon: Icons.shopping_cart, color: Color(0xFF4CAF50)),
  Category(id: 'transport', name: 'Transport', icon: Icons.directions_bus, color: Color(0xFF2196F3)),
  Category(id: 'housing', name: 'Wohnen', icon: Icons.home, color: Color(0xFF9C27B0)),
  Category(id: 'subs', name: 'Abos', icon: Icons.subscriptions, color: Color(0xFFFF9800)),
  Category(id: 'fun', name: 'Freizeit', icon: Icons.local_cafe, color: Color(0xFFE91E63)),
  Category(id: 'income', name: 'Einnahmen', icon: Icons.payments, color: Color(0xFF00BFA5)),
];