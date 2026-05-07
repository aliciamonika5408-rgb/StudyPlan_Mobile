import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';
import '../models/task_model.dart';

class PriorityBadge extends StatelessWidget {
  final TaskPriority priority;
  final bool small;

  const PriorityBadge({
    super.key,
    required this.priority,
    this.small = false,
  });

  Color get _color {
    switch (priority) {
      case TaskPriority.tinggi:
        return AppColors.urgent;
      case TaskPriority.sedang:
        return AppColors.sedang;
      case TaskPriority.rendah:
        return AppColors.rendah;
    }
  }

  String get _label {
    switch (priority) {
      case TaskPriority.tinggi:
        return 'Urgent';
      case TaskPriority.sedang:
        return 'Sedang';
      case TaskPriority.rendah:
        return 'Rendah';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: small ? 8 : 12,
        vertical: small ? 3 : 5,
      ),
      decoration: BoxDecoration(
        color: _color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _color.withValues(alpha: 0.3), width: 1),
      ),
      child: Text(
        _label,
        style: GoogleFonts.poppins(
          color: _color,
          fontSize: small ? 10 : 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
