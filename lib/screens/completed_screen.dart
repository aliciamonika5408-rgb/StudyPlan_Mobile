import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';
import '../services/storage_service.dart';
import '../models/task_model.dart';
import '../widgets/task_card.dart';
import '../widgets/empty_state.dart';

class CompletedScreen extends StatefulWidget {
  const CompletedScreen({super.key});

  @override
  State<CompletedScreen> createState() => CompletedScreenState();
}

class CompletedScreenState extends State<CompletedScreen> {
  List<Task> _completedTasks = [];

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  void _loadTasks() {
    setState(() {
      _completedTasks = StorageService.getCompletedTasks();
    });
  }

  void refresh() => _loadTasks();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        title: Text('Selesai', style: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: Colors.white)),
        automaticallyImplyLeading: false,
        actions: [
          if (_completedTasks.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(12)),
                  child: Text('${_completedTasks.length} tugas', style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white)),
                ),
              ),
            ),
        ],
      ),
      body: _completedTasks.isEmpty
          ? const EmptyState(
              icon: Icons.check_circle_outline_rounded,
              title: 'Belum ada tugas selesai',
              subtitle: 'Tugas yang sudah diselesaikan\nakan muncul di sini.',
            )
          : ListView.builder(
              padding: const EdgeInsets.all(20),
              physics: const BouncingScrollPhysics(),
              itemCount: _completedTasks.length,
              itemBuilder: (ctx, i) {
                return TaskCard(
                  task: _completedTasks[i],
                  onTap: () async {
                    final result = await Navigator.of(context).pushNamed('/detail', arguments: _completedTasks[i].id);
                    if (result == true) _loadTasks();
                  },
                );
              },
            ),
    );
  }
}
