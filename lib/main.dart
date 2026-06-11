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
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1a2744),
        ),
        useMaterial3: true,
      ),
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
  final summaryCtrl = TextEditingController();
  File? _photo;

  Future<void> _pickPhoto() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _photo = File(picked.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0d1117),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1a2744),
        title: const Text(
          'SmartCV Builder',
          style: TextStyle(
            color: Color(0xFFc9a84c),
            fontWeight: FontWeight.bold,
          ),
        ),
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
                  backgroundImage:
                      _photo != null ? FileImage(_photo!) : null,
                  child: _photo == null
                      ? const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.camera_alt,
                                color: Color(0xFFc9a84c), size: 30),
                            Text(
                              'Add Photo',
                              style: TextStyle(
                                  color: Color(0xFFc9a84c), fontSize: 11),
                            ),
                          ],
                        )
                      : null,
                ),
              ),
            ),
            const SizedBox(height: 16),
            _label('Full Name'),
            _field(nameCtrl, 'e.g. Rukun Ddin'),
            _label('Job Title'),
            _field(titleCtrl, 'e.g. Flutter Developer'),
            _label('Phone'),
            _field(phoneCtrl, '+92 300 1234567'),
            _label('Email'),
            _field(emailCtrl, 'email@gmail.com'),
            _label('Summary'),
            _field(summaryCtrl, 'Write about yourself...', lines: 4),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFc9a84c),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CVPreviewPage(
                        name: nameCtrl.text,
                        title: titleCtrl.text,
                        phone: phoneCtrl.text,
                        email: emailCtrl.text,
                        summary: summaryCtrl.text,
                        photo: _photo,
                      ),
                    ),
                  );
                },
                child: const Text(
                  'Preview My CV',
                  style: TextStyle(
                    color: Color(0xFF1a2744),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 6),
      child: Text(
        text,
        style: const TextStyle(
          color: Color(0xFFc9a84c),
          fontWeight: FontWeight.bold,
          fontSize: 13,
        ),
      ),
    );
  }

  Widget _field(TextEditingController ctrl, String hint, {int lines = 1}) {
    return TextField(
      controller: ctrl,
      maxLines: lines,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.grey),
        filled: true,
        fillColor: const Color(0xFF1a2744),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

class CVPreviewPage extends StatelessWidget {
  final String name, title, phone, email, summary;
  final File? photo;
  const CVPreviewPage({
    super.key,
    required this.name,
    required this.title,
    required this.phone,
    required this.email,
    required this.summary,
    this.photo,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF1a2744),
        title: const Text(
          'CV Preview',
          style: TextStyle(color: Color(0xFFc9a84c)),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1a2744),
                        ),
                      ),
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 15,
                          color: Color(0xFFc9a84c),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                if (photo != null)
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: FileImage(photo!),
                  ),
              ],
            ),
            const Divider(color: Color(0xFFc9a84c), thickness: 2),
            const SizedBox(height: 10),
            _row(Icons.phone, phone),
            _row(Icons.email, email),
            const SizedBox(height: 16),
            const Text(
              'SUMMARY',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFF1a2744),
                fontSize: 16,
              ),
            ),
            const Divider(color: Color(0xFFc9a84c)),
            Text(summary),
          ],
        ),
      ),
    );
  }

  Widget _row(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFFc9a84c), size: 18),
          const SizedBox(width: 8),
          Text(text),
        ],
      ),
    );
  }
}