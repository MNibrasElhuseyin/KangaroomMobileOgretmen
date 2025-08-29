import 'package:flutter/material.dart';
import 'package:kangaroom_mobile/widgets/app_constant.dart';

class YoklamaAyDropdown extends StatelessWidget {
  const YoklamaAyDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text(
          'Ay:',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppConstants.primaryColor,
          ),
        ),
        const SizedBox(width: 10),
        DropdownButton<String>(
          value: 'Temmuz',
          items: const [
            DropdownMenuItem(value: 'Tümü', child: Text('Tümü')),
            DropdownMenuItem(value: 'Ocak', child: Text('Ocak')),
            DropdownMenuItem(value: 'Şubat', child: Text('Şubat')),
            DropdownMenuItem(value: 'Mart', child: Text('Mart')),
            DropdownMenuItem(value: 'Nisan', child: Text('Nisan')),
            DropdownMenuItem(value: 'Mayıs', child: Text('Mayıs')),
            DropdownMenuItem(value: 'Haziran', child: Text('Haziran')),
            DropdownMenuItem(value: 'Temmuz', child: Text('Temmuz')),
            DropdownMenuItem(value: 'Ağustos', child: Text('Ağustos')),
            DropdownMenuItem(value: 'Eylül', child: Text('Eylül')),
            DropdownMenuItem(value: 'Ekim', child: Text('Ekim')),
            DropdownMenuItem(value: 'Kasım', child: Text('Kasım')),
            DropdownMenuItem(value: 'Aralık', child: Text('Aralık')),
          ],
          onChanged: (value) {},
        ),
      ],
    );
  }
}
