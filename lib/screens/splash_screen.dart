import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import '../theme/app_colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _lottieController;
  double _textOpacity = 0.0;

  @override
  void initState() {
    super.initState();
    _lottieController = AnimationController(vsync: this);

    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) setState(() => _textOpacity = 1.0);
    });

    Future.delayed(const Duration(milliseconds: 3500), () {
      if (mounted) Navigator.of(context).pushReplacementNamed('/main');
    });
  }

  @override
  void dispose() {
    _lottieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF5FF),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFFDF5FF),
              Color(0xFFF8ECFF),
              Color(0xFFFFF0F5),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(flex: 2),
              Lottie.asset(
                'assets/reading_cat.json',
                controller: _lottieController,
                width: 220,
                height: 220,
                fit: BoxFit.contain,
                onLoaded: (composition) {
                  _lottieController
                    ..duration = composition.duration
                    ..repeat();
                },
              ),
              const SizedBox(height: 28),
              AnimatedOpacity(
                opacity: _textOpacity,
                duration: const Duration(milliseconds: 800),
                curve: Curves.easeIn,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Study', style: GoogleFonts.poppins(fontSize: 32, fontWeight: FontWeight.w800, color: AppColors.primary)),
                        Text('Plan', style: GoogleFonts.poppins(fontSize: 32, fontWeight: FontWeight.w400, color: AppColors.accent)),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Catatan Tugas Sekolah',
                      style: GoogleFonts.poppins(fontSize: 14, color: AppColors.textSecondary, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
              const Spacer(flex: 2),
              AnimatedOpacity(
                opacity: _textOpacity,
                duration: const Duration(milliseconds: 1000),
                child: Column(
                  children: [
                    Text('Atur Tugasmu,', style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.primary, fontStyle: FontStyle.italic)),
                    Text('Raih Prestasimu!', style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.accent, fontStyle: FontStyle.italic)),
                  ],
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
