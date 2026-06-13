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
  const CVPreviewPage({super.key, required this.name, required this.title, required this.phone, required this.email, required this.linkedin, required this.github, required this.summary, required this.experience, required this.education, required this.skills, required this.languages, required this.projects, required this.achievements, this.photo});

  Future<void> _downloadPDF(BuildContext context) async {
    final pdf = pw.Document();
    pw.MemoryImage? photoImage;
    if (photo != null) {
      final bytes = await photo!.readAsBytes();
      photoImage = pw.MemoryImage(bytes);
    }
    pdf.addPage(pw.Page(
      pageFormat: PdfPageFormat.a4,
      build: (pw.Context ctx) {
        return pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Container(
              width: 160,
              color: const PdfColor.fromInt(0xFF1a2744),
              padding: const pw.EdgeInsets.all(12),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  if (photoImage != null)
                    pw.Center(child: pw.ClipOval(child: pw.Image(photoImage, width: 80, height: 80))),
                  pw.SizedBox(height: 12),
                  pw.Text('Contact', style: pw.TextStyle(color: const PdfColor.fromInt(0xFFc9a84c), fontWeight: pw.FontWeight.bold, fontSize: 11)),
                  pw.SizedBox(height: 4),
                  pw.Text(phone, style: const pw.TextStyle(color: PdfColors.white, fontSize: 9)),
                  pw.Text(email, style: const pw.TextStyle(color: PdfColors.white, fontSize: 9)),
                  if (linkedin.isNotEmpty) pw.Text('LinkedIn', style: const pw.TextStyle(color: PdfColors.white, fontSize: 9)),
                  if (github.isNotEmpty) pw.Text('GitHub', style: const pw.TextStyle(color: PdfColors.white, fontSize: 9)),
                  pw.SizedBox(height: 12),
                  if (skills.isNotEmpty) ...[
                    pw.Text('Skills', style: pw.TextStyle(color: const PdfColor.fromInt(0xFFc9a84c), fontWeight: pw.FontWeight.bold, fontSize: 11)),
                    pw.SizedBox(height: 4),
                    ...skills.split(',').map((s) => pw.Text('• ${s.trim()}', style: const pw.TextStyle(color: PdfColors.white, fontSize: 9))),
                  ],
                  pw.SizedBox(height: 12),
                  if (languages.isNotEmpty) ...[
                    pw.Text('Languages', style: pw.TextStyle(color: const PdfColor.fromInt(0xFFc9a84c), fontWeight: pw.FontWeight.bold, fontSize: 11)),
                    pw.SizedBox(height: 4),
                    ...languages.split(',').map((l) => pw.Text('• ${l.trim()}', style: const pw.TextStyle(color: PdfColors.white, fontSize: 9))),
                  ],
                ],
              ),
            ),
            pw.Expanded(
              child: pw.Padding(
                padding: const pw.EdgeInsets.all(16),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(name.toUpperCase(), style: pw.TextStyle(fontSize: 22, fontWeight: pw.FontWeight.bold, color: const PdfColor.fromInt(0xFF1a2744))),
                    pw.Text(title, style: pw.TextStyle(fontSize: 13, color: const PdfColor.fromInt(0xFFc9a84c), fontWeight: pw.FontWeight.bold)),
                    pw.Divider(color: const PdfColor.fromInt(0xFFc9a84c), thickness: 2),
                    if (summary.isNotEmpty) ...[_pdfSection('Summary'), pw.Text(summary, style: const pw.TextStyle(fontSize: 10))],
                    if (experience.isNotEmpty) ...[_pdfSection('Experience'), pw.Text(experience, style: const pw.TextStyle(fontSize: 10))],
                    if (education.isNotEmpty) ...[_pdfSection('Education'), pw.Text(education, style: const pw.TextStyle(fontSize: 10))],
                    if (projects.isNotEmpty) ...[_pdfSection('Projects'), pw.Text(projects, style: const pw.TextStyle(fontSize: 10))],
                    if (achievements.isNotEmpty) ...[_pdfSection('Achievements'), pw.Text(achievements, style: const pw.TextStyle(fontSize: 10))],
                  ],
                ),
              ),
            ),
          ],
        );
      },
    ));
    await Printing.layoutPdf(onLayout: (format) async => pdf.save());
  }

  pw.Widget _pdfSection(String t) => pw.Padding(
    padding: const pw.EdgeInsets.only(top: 10, bottom: 3),
    child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
      pw.Text(t.toUpperCase(), style: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: const PdfColor.fromInt(0xFF1a2744), fontSize: 11)),
      pw.Divider(color: const PdfColor.fromInt(0xFFc9a84c), height: 6),
    ]),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF1a2744),
        centerTitle: true,
        title: const Text('CV Preview', style: TextStyle(color: Color(0xFFc9a84c))),
        actions: [
          IconButton(
            icon: const Icon(Icons.download, color: Color(0xFFc9a84c)),
            onPressed: () => _downloadPDF(context),
            tooltip: 'Download PDF',
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 140,
              color: const Color(0xFF1a2744),
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  if (photo != null) CircleAvatar(radius: 45, backgroundImage: FileImage(photo!)),
                  const SizedBox(height: 12),
                  _sideSection('Contact'),
                  _sideItem(Icons.phone, phone),
                  _sideItem(Icons.email, email),
                  if (linkedin.isNotEmpty) _sideItem(Icons.link, 'LinkedIn'),
                  if (github.isNotEmpty) _sideItem(Icons.code, 'GitHub'),
                  const SizedBox(height: 12),
                  if (skills.isNotEmpty) ...[
                    _sideSection('Skills'),
                    ...skills.split(',').map((s) => _chip(s.trim())),
                  ],
                  const SizedBox(height: 12),
                  if (languages.isNotEmpty) ...[
                    _sideSection('Languages'),
                    ...languages.split(',').map((l) => _chip(l.trim())),
                  ],
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name.toUpperCase(), style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF1a2744))),
                    Text(title, style: const TextStyle(fontSize: 13, color: Color(0xFFc9a84c), fontWeight: FontWeight.bold)),
                    const Divider(color: Color(0xFFc9a84c), thickness: 2),
                    if (summary.isNotEmpty) ...[_mainSection('Summary'), Text(summary, style: const TextStyle(fontSize: 12))],
                    if (experience.isNotEmpty) ...[_mainSection('Experience'), Text(experience, style: const TextStyle(fontSize: 12))],
                    if (education.isNotEmpty) ...[_mainSection('Education'), Text(education, style: const TextStyle(fontSize: 12))],
                    if (projects.isNotEmpty) ...[_mainSection('Projects'), Text(projects, style: const TextStyle(fontSize: 12))],
                    if (achievements.isNotEmpty) ...[_mainSection('Achievements'), Text(achievements, style: const TextStyle(fontSize: 12))],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sideSection(String t) => Padding(
    padding: const EdgeInsets.only(bottom: 4, top: 4),
    child: Text(t, style: const TextStyle(color: Color(0xFFc9a84c), fontWeight: FontWeight.bold, fontSize: 11)),
  );

  Widget _sideItem(IconData icon, String text) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 2),
    child: Row(children: [Icon(icon, color: const Color(0xFFc9a84c), size: 12), const SizedBox(width: 4), Expanded(child: Text(text, style: const TextStyle(color: Colors.white, fontSize: 10), overflow: TextOverflow.ellipsis))]),
  );

  Widget _chip(String text) => Container(
    margin: const EdgeInsets.only(bottom: 4),
    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
    decoration: BoxDecoration(color: const Color(0xFFc9a84c).withOpacity(0.2), borderRadius: BorderRadius.circular(4)),
    child: Text(text, style: const TextStyle(color: Colors.white, fontSize: 10)),
  );

  Widget _mainSection(String t) => Padding(
    padding: const EdgeInsets.only(top: 12, bottom: 4),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(t.toUpperCase(), style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1a2744), fontSize: 13)),
      const Divider(color: Color(0xFFc9a84c), height: 8),
    ]),
  );
}