import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../theme/app_colors.dart';
import '../models/task_model.dart';
import '../services/storage_service.dart';
import '../services/notification_service.dart';
import '../widgets/priority_badge.dart';

class DetailTaskScreen extends StatefulWidget {
  final String taskId;
  const DetailTaskScreen({super.key, required this.taskId});

  @override
  State<DetailTaskScreen> createState() => _DetailTaskScreenState();
}

class _DetailTaskScreenState extends State<DetailTaskScreen> {
  Task? _task;

  @override
  void initState() {
    super.initState();
    _loadTask();
  }

  void _loadTask() {
    setState(() {
      _task = StorageService.getTask(widget.taskId);
    });
  }

  IconData get _subjectIcon {
    switch (_task!.subject.toLowerCase()) {
      case 'matematika': return Icons.calculate_rounded;
      case 'bahasa indonesia': return Icons.menu_book_rounded;
      case 'bahasa inggris': return Icons.translate_rounded;
      case 'ipa': return Icons.science_rounded;
      case 'ips': return Icons.public_rounded;
      case 'fisika': return Icons.bolt_rounded;
      case 'kimia': return Icons.biotech_rounded;
      case 'biologi': return Icons.eco_rounded;
      default: return Icons.book_rounded;
    }
  }

  Color get _subjectColor {
    switch (_task!.subject.toLowerCase()) {
      case 'matematika': return AppColors.primary;
      case 'bahasa indonesia': return const Color(0xFF2ECC71);
      case 'bahasa inggris': return const Color(0xFF3498DB);
      case 'ipa': return const Color(0xFFE67E22);
      default: return AppColors.accent;
    }
  }

  Future<void> _toggleComplete() async {
    if (_task!.isCompleted) {
      await StorageService.markIncomplete(_task!.id);
      _loadTask();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(children: [
              const Icon(Icons.undo, color: Colors.white, size: 20),
              const SizedBox(width: 8),
              Text('Tugas dikembalikan ke daftar', style: GoogleFonts.poppins(color: Colors.white)),
            ]),
            backgroundColor: AppColors.primary,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
      }
    } else {
      await StorageService.markComplete(_task!.id);
      await NotificationService.cancelTaskNotification(_task!.id);
      _loadTask();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(children: [
              const Icon(Icons.check_circle, color: Colors.white, size: 20),
              const SizedBox(width: 8),
              Text('Tugas selesai! 🎉', style: GoogleFonts.poppins(color: Colors.white)),
            ]),
            backgroundColor: AppColors.completed,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
      }
    }
  }

  Future<void> _deleteTask() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Hapus Tugas?', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        content: Text('Tugas "${_task!.title}" akan dihapus permanen.', style: GoogleFonts.poppins()),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text('Batal', style: GoogleFonts.poppins(color: AppColors.textSecondary))),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: Text('Hapus', style: GoogleFonts.poppins(color: AppColors.urgent, fontWeight: FontWeight.w600))),
        ],
      ),
    );
    if (confirm == true) {
      await StorageService.deleteTask(_task!.id);
      await NotificationService.cancelTaskNotification(_task!.id);
      if (mounted) Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_task == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Detail Tugas')),
        body: const Center(child: Text('Tugas tidak ditemukan')),
      );
    }
    final task = _task!;
    final dateFormat = DateFormat('d MMM yyyy, HH:mm', 'id_ID');

    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        // Always return true so parent screens refresh
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: AppColors.primary,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
            onPressed: () => Navigator.pop(context, true),
          ),
          title: Text('Detail Tugas', style: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: Colors.white, fontSize: 18)),
          actions: [
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert_rounded, color: Colors.white),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              onSelected: (v) {
                if (v == 'delete') _deleteTask();
              },
              itemBuilder: (ctx) => [
                PopupMenuItem(value: 'delete', child: Row(children: [
                  const Icon(Icons.delete_rounded, color: AppColors.urgent, size: 20),
                  const SizedBox(width: 8),
                  Text('Hapus', style: GoogleFonts.poppins(color: AppColors.urgent)),
                ])),
              ],
            ),
          ],
        ),
        body: ListView(
          padding: const EdgeInsets.all(20),
          physics: const BouncingScrollPhysics(),
          children: [
            // Header card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(children: [
                Container(
                  width: 56, height: 56,
                  decoration: BoxDecoration(
                    color: _subjectColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(_subjectIcon, color: _subjectColor, size: 28),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(task.title, style: GoogleFonts.poppins(fontSize: 17, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                    const SizedBox(height: 2),
                    if (task.description.isNotEmpty)
                      Text(task.description, style: GoogleFonts.poppins(fontSize: 13, color: AppColors.textSecondary), maxLines: 2, overflow: TextOverflow.ellipsis),
                  ]),
                ),
                const SizedBox(width: 8),
                PriorityBadge(priority: task.priority),
              ]),
            ),

            const SizedBox(height: 24),

            // Info list
            _infoItem(Icons.school_rounded, 'Mata Pelajaran', task.subject),
            _infoItem(Icons.event_rounded, 'Deadline', dateFormat.format(task.deadline)),
            _infoItem(Icons.calendar_today_rounded, 'Dibuat Pada', dateFormat.format(task.createdAt)),
            if (task.description.isNotEmpty)
              _infoItem(Icons.description_rounded, 'Deskripsi', task.description),

            const SizedBox(height: 24),

            // Status section
            Text('Status', style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
            const SizedBox(height: 12),
            Row(children: [
              _buildStatusRadio('Belum Selesai', !task.isCompleted, () async {
                if (task.isCompleted) await _toggleComplete();
              }),
              const SizedBox(width: 16),
              _buildStatusRadio('Selesai', task.isCompleted, () async {
                if (!task.isCompleted) await _toggleComplete();
              }),
            ]),

            const SizedBox(height: 32),

            // Action buttons - fixed text overflow
            Row(children: [
              Expanded(
                child: SizedBox(
                  height: 50,
                  child: OutlinedButton.icon(
                    onPressed: _deleteTask,
                    icon: const Icon(Icons.delete_rounded, size: 18),
                    label: Text('Hapus', style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600)),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.urgent,
                      side: const BorderSide(color: AppColors.urgent, width: 1.5),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: SizedBox(
                  height: 50,
                  child: ElevatedButton.icon(
                    onPressed: _toggleComplete,
                    icon: Icon(task.isCompleted ? Icons.undo_rounded : Icons.check_circle_rounded, size: 18),
                    label: Text(
                      task.isCompleted ? 'Batal Selesai' : 'Tandai Selesai',
                      style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: task.isCompleted ? AppColors.primary : AppColors.completed,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                  ),
                ),
              ),
            ]),
          ],
        ),
      ),
    );
  }

  Widget _infoItem(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 18, color: AppColors.primary),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(label, style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textSecondary, fontWeight: FontWeight.w500)),
            const SizedBox(height: 2),
            Text(value, style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.textPrimary)),
          ]),
        ),
      ]),
    );
  }

  Widget _buildStatusRadio(String label, bool selected, VoidCallback onTap) {
    final isSelesai = label == 'Selesai';
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Row(children: [
          Icon(
            selected
                ? (isSelesai ? Icons.check_circle_rounded : Icons.radio_button_checked_rounded)
                : Icons.radio_button_unchecked_rounded,
            color: selected
                ? (isSelesai ? AppColors.completed : AppColors.primary)
                : AppColors.textSecondary,
            size: 22,
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
              color: selected
                  ? (isSelesai ? AppColors.completed : AppColors.textPrimary)
                  : AppColors.textSecondary,
            ),
          ),
        ]),
      ),
    );
  }
}
