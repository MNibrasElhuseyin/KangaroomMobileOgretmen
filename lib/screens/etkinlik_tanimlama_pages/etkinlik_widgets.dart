import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'etkinlik_controller.dart';

class EtkinlikWidgets {
  static Widget buildDatePicker(
    EtkinlikController controller,
    BuildContext context,
  ) {
    return GestureDetector(
      onTap: () async {
        final DateTime? picked = await showDatePicker(
          context: context,
          initialDate: controller.selectedDate ?? DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
        );
        if (picked != null) {
          controller.selectedDate = picked;
          controller.notifyListeners();
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFFCF7FA),
          border: Border.all(color: Colors.deepPurple),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Icon(Icons.calendar_today, color: Colors.deepPurple),
              const SizedBox(width: 8),
              Text(
                controller.selectedDate == null
                    ? 'Tarih Seç'
                    : '${controller.selectedDate!.day}/${controller.selectedDate!.month}/${controller.selectedDate!.year}',
                style: const TextStyle(color: Colors.black, fontSize: 16),
              ),
              const Icon(Icons.arrow_drop_down, color: Colors.deepPurple),
            ],
          ),
        ),
      ),
    );
  }

  static Widget buildTimePicker(
    EtkinlikController controller,
    BuildContext context,
  ) {
    return GestureDetector(
      onTap: () async {
        final TimeOfDay? picked = await showTimePicker(
          context: context,
          initialTime: controller.selectedTime ?? TimeOfDay.now(),
        );
        if (picked != null) {
          controller.selectedTime = picked;
          controller.notifyListeners();
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFFCF7FA),
          border: Border.all(color: Colors.deepPurple),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Icon(Icons.access_time, color: Colors.deepPurple),
              const SizedBox(width: 8),
              Text(
                controller.selectedTime == null
                    ? 'Saat Seç'
                    : controller.selectedTime!.format(context),
                style: const TextStyle(color: Colors.black, fontSize: 16),
              ),
              const Icon(Icons.arrow_drop_down, color: Colors.deepPurple),
            ],
          ),
        ),
      ),
    );
  }

  static Widget buildNameField(EtkinlikController controller) {
    return TextField(
      controller: controller.nameController,
      decoration: const InputDecoration(
        labelText: 'İsim',
        labelStyle: TextStyle(color: Colors.deepPurple),
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.symmetric(horizontal: 12),
      ),
    );
  }

  static Widget buildFeeField(EtkinlikController controller) {
    return TextField(
      controller: controller.feeController,
      decoration: const InputDecoration(
        labelText: 'Ücret',
        labelStyle: TextStyle(color: Colors.deepPurple),
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.symmetric(horizontal: 12),
      ),
      keyboardType: TextInputType.number,
    );
  }

  static Widget buildFileUploadField(
    EtkinlikController controller,
    BuildContext context,
  ) {
    final ImagePicker _picker = ImagePicker();

    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF9F6FF),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          ElevatedButton.icon(
            onPressed: () async {
              final XFile? pickedFile = await _picker.pickImage(
                source: ImageSource.gallery, // sadece galeri
                maxWidth: 2000,
                maxHeight: 2000,
              );
              if (pickedFile != null) {
                controller.selectedFile = File(pickedFile.path);
                controller.notifyListeners();
              }
            },
            icon: const Icon(Icons.photo_library),
            label: const Text("Resim Seç"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.deepPurple,
              side: const BorderSide(color: Colors.deepPurple),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: controller.descriptionController,
              decoration: const InputDecoration(
                hintText: "Açıklama ekle (isteğe bağlı)",
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Widget buildSaveButton(
    EtkinlikController controller,
    BuildContext context, [
    VoidCallback? onSaved,
  ]) {
    return _SaveButton(controller: controller, onSaved: onSaved);
  }
}

class _SaveButton extends StatefulWidget {
  final EtkinlikController controller;
  final VoidCallback? onSaved;

  const _SaveButton({required this.controller, this.onSaved, Key? key})
      : super(key: key);

  @override
  State<_SaveButton> createState() => _SaveButtonState();
}

class _SaveButtonState extends State<_SaveButton> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.controller,
      builder: (context, child) {
        return SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: widget.controller.isFormValid && !isLoading
                ? () async {
                    setState(() => isLoading = true);
                    bool success =
                        await widget.controller.saveEvent(context);
                    setState(() => isLoading = false);

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          success
                              ? 'Etkinlik başarıyla kaydedildi!'
                              : 'Kayıt başarısız!',
                        ),
                        backgroundColor: success ? Colors.green : Colors.red,
                      ),
                    );
                    if (success && widget.onSaved != null) {
                      widget.onSaved!();
                    }
                  }
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: widget.controller.isFormValid && !isLoading
                  ? Colors.deepPurple
                  : Colors.grey,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(vertical: 18),
              textStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            child: isLoading
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 3,
                    ),
                  )
                : const Text("Kaydet"),
          ),
        );
      },
    );
  }
}
