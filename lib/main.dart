import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(const CVBuilderApp());
}

class CVBuilderApp extends StatelessWidget {
  const CVBuilderApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SmartCV Builder',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1a2744)), useMaterial3: true),
      home: const CVFormPage(),
    );
  }
}

class CVFormPage extends StatefulWidget {
  const CVFormPage({super.key});
  @override
  State<CVFormPage> createState() => _CVFormPageState();
}

class _CVFormPageState extends State<CVFormPage> {
  final nameCtrl = TextEditingController();
  final titleCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final linkedinCtrl = TextEditingController();
  final githubCtrl = TextEditingController();
  final summaryCtrl = TextEditingController();
  final experienceCtrl = TextEditingController();
  final educationCtrl = TextEditingController();
  final skillsCtrl = TextEditingController();
  final languagesCtrl = TextEditingController();
  final projectsCtrl = TextEditingController();
  final achievementsCtrl = TextEditingController();
  File? _photo;

  Future<void> _pickPhoto() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) setState(() => _photo = File(picked.path));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0d1117),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1a2744),
        title: const Text('SmartCV Builder', style: TextStyle(color: Color(0xFFc9a84c), fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: GestureDetector(
                onTap: _pickPhoto,
                child: CircleAvatar(
                  radius: 55,
                  backgroundColor: const Color(0xFF1a2744),
                  backgroundImage: _photo != null ? FileImage(_photo!) : null,
                  child: _photo == null ? const Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.camera_alt, color: Color(0xFFc9a84c), size: 30), Text('Add Photo', style: TextStyle(color: Color(0xFFc9a84c), fontSize: 11))]) : null,
                ),
              ),
            ),
            const SizedBox(height: 16),
            _label('Full Name'), _field(nameCtrl, 'e.g. Muhammad Ali'),
            _label('Job Title'), _field(titleCtrl, 'e.g. Flutter Developer'),
            _label('Phone'), _field(phoneCtrl, '+92 300 1234567'),
            _label('Email'), _field(emailCtrl, 'email@gmail.com'),
            