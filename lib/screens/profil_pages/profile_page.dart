import 'package:flutter/material.dart';
import '../../widgets/custom_appbar.dart';
import '../../widgets/custom_text_field.dart';
import 'profile_controller.dart';
import '../../models/profil/post_profil.dart';
import 'package:kangaroom_mobile/config/global_config.dart';

class ProfilPage extends StatefulWidget {
  const ProfilPage({super.key});

  @override
  _ProfilPageState createState() => _ProfilPageState();
}

class _ProfilPageState extends State<ProfilPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _surnameController = TextEditingController();
  final _contactController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordRepeatController = TextEditingController();

  bool _isLoading = false;
  final _controller = ProfileController();

  @override
  void initState() {
    super.initState();
    _fetchProfileData();
  }

  Future<void> _fetchProfileData() async {
    setState(() => _isLoading = true);
    await _controller.fetchProfil();
    final profil = _controller.firstProfil;
    if (profil != null) {
      _nameController.text = profil.modelAd;
      _surnameController.text = profil.modelSoyad;
      _contactController.text = profil.modelIletisim;
    }
    setState(() => _isLoading = false);
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    if (_passwordController.text != _passwordRepeatController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Şifreler eşleşmiyor!')),
      );
      return;
    }

    final profil = _controller.firstProfil;
    if (profil == null) return;

    final postModel = PostProfilModel(
      id: GlobalConfig.personelID, // hazır GET modelden id al
      ad: _nameController.text,
      soyad: _surnameController.text,
      sifre: _passwordController.text,
    );

    setState(() => _isLoading = true);
    final success = await _controller.updateProfil(postModel);
    setState(() => _isLoading = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          success ? 'Profil başarıyla güncellendi!' : 'Profil güncelleme başarısız!',
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _surnameController.dispose();
    _contactController.dispose();
    _passwordController.dispose();
    _passwordRepeatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Profil"),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    CustomTextField(
                      labelText: 'Ad',
                      controller: _nameController,
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Ad giriniz';
                        return null;
                      },
                    ),
                    CustomTextField(
                      labelText: 'Soyad',
                      controller: _surnameController,
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Soyad giriniz';
                        return null;
                      },
                    ),
                    CustomTextField(
                      labelText: 'İletişim (Kullanıcı Adı)',
                      controller: _contactController,
                      keyboardType: TextInputType.phone,
                      readOnly: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'İletişim bilgisi giriniz';
                        return null;
                      },
                    ),
                    CustomTextField(
                      labelText: 'Şifre',
                      controller: _passwordController,
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Şifre giriniz';
                        return null;
                      },
                    ),
                    CustomTextField(
                      labelText: 'Şifre Tekrar',
                      controller: _passwordRepeatController,
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Şifre tekrar giriniz';
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _saveProfile,
                      child: const Text('Kaydet'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}