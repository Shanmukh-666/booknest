import 'package:material_ui/material_ui.dart';

/// Represents a browseable book category with visual identity.
class BookCategory {
  final String id;
  final String name;
  final String description;
  final IconData icon;
  final Color color;
  final Color accentColor;

  const BookCategory({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.color,
    required this.accentColor,
  });
}
