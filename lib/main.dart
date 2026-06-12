import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

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
            _label('LinkedIn'), _field(linkedinCtrl, 'https://linkedin.com/in/...'),
            _label('GitHub'), _field(githubCtrl, 'https://github.com/...'),
            _label('Summary'), _field(summaryCtrl, 'Write about yourself...', lines: 3),
            _label('Experience'), _field(experienceCtrl, 'Job Title at Company (Year)\n- Achievement 1', lines: 5),
            _label('Education'), _field(educationCtrl, 'Degree - University (Year)', lines: 3),
            _label('Skills (comma separated)'), _field(skillsCtrl, 'Flutter, Python, SQL...'),
            _label('Languages'), _field(languagesCtrl, 'Urdu, English'),
            _label('Projects'), _field(projectsCtrl, 'Project Name\n- Description', lines: 4),
            _label('Achievements'), _field(achievementsCtrl, '- Achievement 1', lines: 3),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFc9a84c), padding: const EdgeInsets.symmetric(vertical: 16)),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => CVPreviewPage(
                    name: nameCtrl.text, title: titleCtrl.text, phone: phoneCtrl.text,
                    email: emailCtrl.text, linkedin: linkedinCtrl.text, github: githubCtrl.text,
                    summary: summaryCtrl.text, experience: experienceCtrl.text,
                    education: educationCtrl.text, skills: skillsCtrl.text,
                    languages: languagesCtrl.text, projects: projectsCtrl.text,
                    achievements: achievementsCtrl.text, photo: _photo,
                  )));
                },
                child: const Text('Preview My CV', style: TextStyle(color: Color(0xFF1a2744), fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _label(String text) => Padding(
    padding: const EdgeInsets.only(top: 16, bottom: 6),
    child: Text(text, style: const TextStyle(color: Color(0xFFc9a84c), fontWeight: FontWeight.bold, fontSize: 13)),
  );

  Widget _field(TextEditingController ctrl, String hint, {int lines = 1}) => TextField(
    controller: ctrl, maxLines: lines,
    style: const TextStyle(color: Colors.white),
    decoration: InputDecoration(
      hintText: hint, hintStyle: const TextStyle(color: Colors.grey),
      filled: true, fillColor: const Color(0xFF1a2744),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
    ),
  );
}

class CVPreviewPage extends StatelessWidget {
  final String name, title, phone, email, linkedin, github, summary, experience, education, skills, languages, projects, achievements;
  final File? photo;
  const CVPreviewPage({super.key, required this.name, required this.title, required this.phone, required this.email,