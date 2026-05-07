import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../theme/app_colors.dart';
import '../models/task_model.dart';
import 'priority_badge.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback? onTap;
  final VoidCallback? onComplete;

  const TaskCard({
    super.key,
    required this.task,
    this.onTap,
    this.onComplete,
  });

  IconData get _subjectIcon {
    switch (task.subject.toLowerCase()) {
      case 'matematika': return Icons.calculate_rounded;
      case 'bahasa indonesia': return Icons.menu_book_rounded;
      case 'bahasa inggris': return Icons.translate_rounded;
      case 'ipa': return Icons.science_rounded;
      case 'ips': return Icons.public_rounded;
      case 'fisika': return Icons.bolt_rounded;
      case 'kimia': return Icons.biotech_rounded;
      case 'biologi': return Icons.eco_rounded;
      case 'sejarah': return Icons.history_edu_rounded;
      case 'seni budaya': return Icons.palette_rounded;
      case 'pjok': return Icons.sports_soccer_rounded;
      case 'informatika': return Icons.computer_rounded;
      default: return Icons.book_rounded;
    }
  }

  Color get _subjectColor {
    switch (task.subject.toLowerCase()) {
      case 'matematika': return AppColors.primary;
      case 'bahasa indonesia': return const Color(0xFF5CD6A0);
      case 'bahasa inggris': return const Color(0xFF7EC8E3);
      case 'ipa': return const Color(0xFFFFB347);
      case 'ips': return const Color(0xFF5CD6A0);
      case 'fisika': return const Color(0xFFFF6B8A);
      case 'kimia': return AppColors.primary;
      case 'biologi': return const Color(0xFF5CD6A0);
      default: return AppColors.accent;
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('d MMM yyyy', 'id_ID');
    final isOverdue = task.isOverdue;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: isOverdue
              ? Border.all(color: AppColors.urgent.withValues(alpha: 0.3), width: 1.5)
              : Border.all(color: Colors.grey.shade100),
          boxShadow: [
            BoxShadow(
              color: _subjectColor.withValues(alpha: 0.06),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Container(
                width: 46, height: 46,
                decoration: BoxDecoration(
                  color: _subjectColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(_subjectIcon, color: _subjectColor, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.title,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: task.isCompleted ? AppColors.textSecondary : AppColors.textPrimary,
                        decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(children: [
                      Icon(Icons.schedule_rounded, size: 12,
                        color: isOverdue ? AppColors.urgent : AppColors.textSecondary),
                      const SizedBox(width: 4),
                      Text(
                        dateFormat.format(task.deadline),
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          color: isOverdue ? AppColors.urgent : AppColors.textSecondary,
                          fontWeight: isOverdue ? FontWeight.w600 : FontWeight.w400,
                        ),
                      ),
                      if (task.subject.isNotEmpty) ...[
                        const SizedBox(width: 8),
                        Container(
                          width: 3, height: 3,
                          decoration: BoxDecoration(color: AppColors.textSecondary, shape: BoxShape.circle),
                        ),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            task.subject,
                            style: GoogleFonts.poppins(fontSize: 11, color: AppColors.textSecondary),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ]),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              if (task.isCompleted)
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: AppColors.completed.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.check_circle_rounded, color: AppColors.completed, size: 18),
                )
              else
                PriorityBadge(priority: task.priority, small: true),
            ],
          ),
        ),
      ),
    );
  }
}
