import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';
import '../services/storage_service.dart';
import '../models/task_model.dart';
import '../widgets/summary_card.dart';
import '../widgets/task_card.dart';
import '../widgets/empty_state.dart';

class HomeScreen extends StatefulWidget {
  final VoidCallback? onAddTask;
  const HomeScreen({super.key, this.onAddTask});

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  List<Task> _tasks = [];

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  void _loadTasks() {
    setState(() {
      _tasks = StorageService.getAllTasks();
    });
  }

  void refresh() => _loadTasks();

  List<Task> get _pendingTasks =>
      _tasks.where((t) => !t.isCompleted).toList();

  @override
  Widget build(BuildContext context) {
    final total = _tasks.length;
    final pending = _pendingTasks.length;
    final completed = _tasks.where((t) => t.isCompleted).length;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(child: _buildHeader()),
          SliverToBoxAdapter(child: _buildSummary(total, pending, completed)),
          SliverToBoxAdapter(child: _buildTaskHeader(pending)),
          _buildTaskList(),
          SliverToBoxAdapter(child: _buildMotivation()),
          const SliverToBoxAdapter(child: SizedBox(height: 80)),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      decoration: const BoxDecoration(
        gradient: AppColors.headerGradient,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text('Study', style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.w800, color: Colors.white)),
                  Text('Plan', style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.w300, color: Colors.white.withValues(alpha: 0.9))),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 44, height: 44,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(Icons.waving_hand_rounded, color: Colors.white, size: 22),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Halo, Pelajar!',
                            style: GoogleFonts.poppins(fontSize: 17, fontWeight: FontWeight.w700, color: Colors.white),
                          ),
                          Text(
                            'Semangat mengerjakan tugas hari ini',
                            style: GoogleFonts.poppins(fontSize: 12, color: Colors.white.withValues(alpha: 0.85)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummary(int total, int pending, int completed) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Ringkasan', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
          const SizedBox(height: 12),
          Row(children: [
            SummaryCard(label: 'Total', count: total, icon: Icons.assignment_rounded, color: AppColors.primary),
            const SizedBox(width: 10),
            SummaryCard(label: 'Pending', count: pending, icon: Icons.pending_actions_rounded, color: AppColors.accent),
            const SizedBox(width: 10),
            SummaryCard(label: 'Selesai', count: completed, icon: Icons.check_circle_rounded, color: AppColors.completed),
          ]),
        ],
      ),
    );
  }

  Widget _buildTaskHeader(int pending) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Daftar Tugas', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
          if (pending > 0)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.accent.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text('$pending tugas', style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.accent)),
            ),
        ],
      ),
    );
  }

  Widget _buildTaskList() {
    if (_pendingTasks.isEmpty) {
      return SliverToBoxAdapter(
        child: EmptyState(
          icon: Icons.assignment_outlined,
          title: 'Belum ada tugas',
          subtitle: 'Yuk mulai catat tugasmu\nagar tidak lupa!',
          action: ElevatedButton.icon(
            onPressed: widget.onAddTask,
            icon: const Icon(Icons.add_rounded, size: 18),
            label: Text('Tambah Tugas', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.accent,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ),
      );
    }
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final task = _pendingTasks[index];
            return TaskCard(
              task: task,
              onTap: () async {
                final result = await Navigator.of(context).pushNamed('/detail', arguments: task.id);
                if (result == true) _loadTasks();
              },
            );
          },
          childCount: _pendingTasks.length,
        ),
      ),
    );
  }

  Widget _buildMotivation() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: AppColors.cuteCardGradient,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.accentLight.withValues(alpha: 0.2)),
        ),
        child: Row(children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.accent.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(Icons.auto_awesome_rounded, color: AppColors.accent, size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Kamu pasti bisa!', style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
              Text('Selesaikan tugas satu per satu', style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textSecondary)),
            ]),
          ),
        ]),
      ),
    );
  }
}
