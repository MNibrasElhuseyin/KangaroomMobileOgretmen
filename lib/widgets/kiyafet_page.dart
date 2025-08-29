import 'package:flutter/material.dart';

class MyScreen extends StatefulWidget {
  const MyScreen({super.key});

  @override
  State<MyScreen> createState() => _MyScreenState();
}

class _MyScreenState extends State<MyScreen> {
  List<bool> isChecked = [false, false, false, false];

  final List<String> labels = [
    'Üst Çamaşır',
    'Alt Çamaşır',
    'Üst Kıyafet',
    'Alt Kıyafet',
  ];

  Widget buildBox(int index) {
    return Row(
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              isChecked[index] = !isChecked[index];
            });
          },
          child: Container(
            width: 40,
            height: 50,
            margin: const EdgeInsets.only(right: 4),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Center(
              child: Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4.0),
                ),
                child: isChecked[index]
                    ? Icon(Icons.check, size: 16, color: Theme.of(context).primaryColor)
                    : null,
              ),
            ),
          ),
        ),
        Container(
          width: 150,
          height: 50,
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 3,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Text(
            labels[index],
            style: TextStyle(
              color: Colors.grey[800],
              fontSize: 16.0,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Wrap(
              spacing: 16,
              runSpacing: 12,
              children: List.generate(4, (index) => buildBox(index)),
            ),
          ],
        ),
      ),
    );
  }
}