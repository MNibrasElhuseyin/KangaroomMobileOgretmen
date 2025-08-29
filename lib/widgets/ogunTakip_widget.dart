import 'package:flutter/material.dart';

class OgunDropdown extends StatelessWidget {
  final String? seciliOgun;
  final Function(String)? onOgunChanged;

  const OgunDropdown({
    super.key,
    this.seciliOgun,
    this.onOgunChanged,
  });

  @override
  Widget build(BuildContext context) {
    final List<String> ogunler = ["Sabah", "Öğle", "İkindi"];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Öğün",
          style: TextStyle(
            color: Colors.deepPurple,
            fontSize: 12, // Reduced font size
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4), // Reduced spacing
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8), // Reduced horizontal padding
          decoration: BoxDecoration(
            color: const Color(0xFFFCF7FA),
            border: Border.all(color: Colors.deepPurple.shade100),
            borderRadius: BorderRadius.circular(4), // Slightly smaller border radius
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: seciliOgun ?? "Sabah",
              icon: const Icon(
                Icons.arrow_drop_down,
                color: Colors.deepPurple,
                size: 20, // Smaller icon size
              ),
              dropdownColor: const Color(0xFFFCF7FA),
              isExpanded: true,
              style: const TextStyle(
                color: Colors.deepPurple,
                fontSize: 14, // Reduced font size
                fontWeight: FontWeight.w500,
              ),
              items: ogunler.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    style: const TextStyle(
                      color: Colors.deepPurple,
                      fontSize: 14, // Reduced font size
                    ),
                  ),
                );
              }).toList(),
              onChanged: (newValue) {
                if (newValue != null && onOgunChanged != null) {
                  onOgunChanged!(newValue);
                }
              },
            ),
          ),
        ),
      ],
    );
  }
}

// Standalone test widget (isteğe bağlı olarak kullanılabilir)
class OgunTakipTestApp extends StatelessWidget {
  const OgunTakipTestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Öğün Seç',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        fontFamily: 'Roboto',
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String selectedOgun = "Sabah";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Öğün Seç"),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Slightly reduced padding
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            OgunDropdown(
              seciliOgun: selectedOgun,
              onOgunChanged: (newOgun) {
                setState(() {
                  selectedOgun = newOgun;
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Seçilen öğün: $newOgun'),
                    duration: const Duration(seconds: 1),
                  ),
                );
              },
            ),
            const SizedBox(height: 16), // Reduced spacing
            Container(
              padding: const EdgeInsets.all(12), // Reduced padding
              decoration: BoxDecoration(
                color: Colors.deepPurple.shade50,
                borderRadius: BorderRadius.circular(6), // Smaller border radius
                border: Border.all(color: Colors.deepPurple.shade200),
              ),
              child: Text(
                'Seçilen öğün: $selectedOgun',
                style: TextStyle(
                  fontSize: 16, // Reduced font size
                  fontWeight: FontWeight.w600,
                  color: Colors.deepPurple.shade700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}