import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import '../theme/app_colors.dart';
import '../models/task_model.dart';
import '../services/storage_service.dart';
import '../services/notification_service.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descController = TextEditingController();

  String _selectedSubject = 'Matematika';
  DateTime _deadline = DateTime.now().add(const Duration(days: 1));
  TimeOfDay _deadlineTime = const TimeOfDay(hour: 23, minute: 59);
  TaskPriority _priority = TaskPriority.sedang;
  ReminderOption _reminder = ReminderOption.satuHari;
  bool _isSaving = false;

  final List<String> _subjects = [
    'Matematika', 'Bahasa Indonesia', 'Bahasa Inggris', 'IPA',
    'IPS', 'Fisika', 'Kimia', 'Biologi', 'Sejarah',
    'Seni Budaya', 'PJOK', 'Informatika', 'Lainnya',
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _deadline,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(primary: AppColors.primary, onPrimary: Colors.white),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) setState(() => _deadline = picked);
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _deadlineTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(colorScheme: const ColorScheme.light(primary: AppColors.primary)),
          child: child!,
        );
      },
    );
    if (picked != null) setState(() => _deadlineTime = picked);
  }

  Future<void> _saveTask() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSaving = true);

    final fullDeadline = DateTime(
      _deadline.year, _deadline.month, _deadline.day,
      _deadlineTime.hour, _deadlineTime.minute,
    );
    final task = Task(
      id: const Uuid().v4(),
      title: _titleController.text.trim(),
      subject: _selectedSubject,
      description: _descController.text.trim(),
      deadline: fullDeadline,
      priority: _priority,
      reminderOption: _reminder,
    );

    await StorageService.addTask(task);
    await NotificationService.scheduleTaskReminder(task);

    setState(() => _isSaving = false);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(children: [
            const Icon(Icons.check_circle, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Text('Tugas berhasil disimpan!', style: GoogleFonts.poppins(color: Colors.white)),
          ]),
          backgroundColor: AppColors.completed,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
      Navigator.of(context).pop(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Tambah Tugas', style: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: Colors.white, fontSize: 18)),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.check_rounded,
                  color: _isSaving ? Colors.white54 : Colors.white,
                  size: 20,
                ),
              ),
              onPressed: _isSaving ? null : _saveTask,
            ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          physics: const BouncingScrollPhysics(),
          children: [
            // Judul Tugas
            _buildLabel('Judul Tugas'),
            const SizedBox(height: 8),
            TextFormField(
              controller: _titleController,
              style: GoogleFonts.poppins(fontSize: 14),
              decoration: _inputDeco('Contoh: Kerjakan soal matematika'),
              validator: (v) => v == null || v.trim().isEmpty ? 'Judul tidak boleh kosong' : null,
            ),

            const SizedBox(height: 20),
            _buildLabel('Mata Pelajaran'),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              initialValue: _selectedSubject,
              decoration: _inputDeco('Pilih mata pelajaran'),
              style: GoogleFonts.poppins(fontSize: 14, color: AppColors.textPrimary),
              icon: const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.textSecondary),
              items: _subjects.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
              onChanged: (v) => setState(() => _selectedSubject = v!),
            ),

            const SizedBox(height: 20),
            _buildLabel('Deskripsi (Opsional)'),
            const SizedBox(height: 8),
            TextFormField(
              controller: _descController,
              style: GoogleFonts.poppins(fontSize: 14),
              maxLines: 3,
              decoration: _inputDeco('Tulis deskripsi tugas...'),
            ),

            const SizedBox(height: 20),
            _buildLabel('Deadline'),
            const SizedBox(height: 8),
            Row(children: [
              Expanded(
                flex: 3,
                child: GestureDetector(
                  onTap: _pickDate,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Row(children: [
                      const Icon(Icons.calendar_today_rounded, size: 18, color: AppColors.primary),
                      const SizedBox(width: 10),
                      Text(
                        DateFormat('d MMM yyyy').format(_deadline),
                        style: GoogleFonts.poppins(fontSize: 14, color: AppColors.textPrimary),
                      ),
                    ]),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                flex: 2,
                child: GestureDetector(
                  onTap: _pickTime,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Row(children: [
                      const Icon(Icons.access_time_rounded, size: 18, color: AppColors.primary),
                      const SizedBox(width: 10),
                      Text(
                        _deadlineTime.format(context),
                        style: GoogleFonts.poppins(fontSize: 14, color: AppColors.textPrimary),
                      ),
                    ]),
                  ),
                ),
              ),
            ]),

            const SizedBox(height: 20),
            _buildLabel('Prioritas'),
            const SizedBox(height: 8),
            Row(children: TaskPriority.values.map((p) => _buildPriorityChip(p)).toList()),

            const SizedBox(height: 20),
            _buildLabel('Pengingat'),
            const SizedBox(height: 8),
            DropdownButtonFormField<ReminderOption>(
              initialValue: _reminder,
              decoration: _inputDeco(''),
              style: GoogleFonts.poppins(fontSize: 14, color: AppColors.textPrimary),
              icon: const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.textSecondary),
              items: ReminderOption.values.map((r) {
                String label;
                switch (r) {
                  case ReminderOption.satujam: label = '1 jam sebelum deadline'; break;
                  case ReminderOption.satuHari: label = '1 hari sebelum deadline'; break;
                  case ReminderOption.tigaHari: label = '3 hari sebelum deadline'; break;
                  case ReminderOption.none: label = 'Tidak ada pengingat'; break;
                }
                return DropdownMenuItem(value: r, child: Text(label));
              }).toList(),
              onChanged: (v) => setState(() => _reminder = v!),
            ),

            const SizedBox(height: 32),
            // Simpan button matching mockup
            SizedBox(
              height: 54,
              child: ElevatedButton(
                onPressed: _isSaving ? null : _saveTask,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  elevation: 2,
                  shadowColor: AppColors.primary.withValues(alpha: 0.3),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: _isSaving
                    ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.white))
                    : Text('Simpan Tugas', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600)),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDeco(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: AppColors.background,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade200)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade200)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.primary, width: 2)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      hintStyle: GoogleFonts.poppins(color: AppColors.textSecondary, fontSize: 14),
    );
  }

  Widget _buildLabel(String text) {
    return Text(text, style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary));
  }

  Widget _buildPriorityChip(TaskPriority p) {
    final isSelected = _priority == p;
    Color color;
    String label;
    switch (p) {
      case TaskPriority.rendah: color = AppColors.rendah; label = 'Rendah'; break;
      case TaskPriority.sedang: color = AppColors.sedang; label = 'Sedang'; break;
      case TaskPriority.tinggi: color = AppColors.urgent; label = 'Tinggi'; break;
    }
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _priority = p),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: EdgeInsets.only(right: p != TaskPriority.tinggi ? 8 : 0),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? color : color.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: isSelected ? color : color.withValues(alpha: 0.3), width: 1.5),
          ),
          child: Center(
            child: Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : color,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
