import 'package:flutter/material.dart';
import '../screens/login_pages/login_screen.dart';

class ProfilePage extends StatelessWidget {
  final VoidCallback onProfileTap;

  const ProfilePage({
    required this.onProfileTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: const Icon(Icons.person),
          onPressed: onProfileTap,
          tooltip: 'Profil',
        ),
        SizedBox(width: MediaQuery.of(context).size.width * 0.02),
        IconButton(
          icon: const Icon(Icons.door_back_door),
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Çıkış Yap'),
                content: const Text('Çıkış yapmak istiyor musunuz?'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context); // Diyalogu kapat
                    },
                    child: const Text('Hayır'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context); // Diyalogu kapat
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>  LoginScreen()),
                            (Route<dynamic> route) => false, // Geri dönülemez
                      );
                    },
                    child: const Text('Evet'),
                  ),
                ],
              ),
            );
          },
          tooltip: 'Çıkış',
        ),
      ],
    );
  }
}
