
import 'package:flutter/material.dart';
import 'home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController usernameController =
      TextEditingController();
  final TextEditingController passwordController =
      TextEditingController();

  bool passwordVisible = false;
  bool rememberMe = true;

  Color warnaTema = const Color(0xFF3B82F6);

  final List<Color> daftarWarna = [
    const Color(0xFF3B82F6),
    const Color(0xFF8B5CF6),
    const Color(0xFFEC4899),
    const Color(0xFF10B981),
    const Color(0xFFF59E0B),
    const Color(0xFFEF4444),
  ];

  Color get warnaKedua =>
      Color.lerp(warnaTema, Colors.deepPurple, 0.4)!;

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void login() {
    if (usernameController.text.trim().isEmpty ||
        passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Username dan password harus diisi!'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const HomePage(),
      ),
    );
  }

  void pilihWarnaTema() {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Pilih Warna Tema'),
          content: Wrap(
            spacing: 14,
            runSpacing: 14,
            children: daftarWarna.map((warna) {
              final terpilih = warnaTema == warna;

              return InkWell(
                onTap: () {
                  setState(() {
                    warnaTema = warna;
                  });
                  Navigator.pop(dialogContext);
                },
                borderRadius: BorderRadius.circular(30),
                child: CircleAvatar(
                  radius: 23,
                  backgroundColor: warna,
                  child: terpilih
                      ? const Icon(
                          Icons.check,
                          color: Colors.white,
                        )
                      : null,
                ),
              );
            }).toList(),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Tutup'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEAF4FF),
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth >= 800) {
            return Row(
              children: [
                Expanded(
                  flex: 5,
                  child: _bagianSambutan(),
                ),
                Expanded(
                  flex: 4,
                  child: Container(
                    color: Colors.white,
                    child: Center(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(35),
                        child: _kartuLogin(),
                      ),
                    ),
                  ),
                ),
              ],
            );
          }

          return Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFFEAF4FF),
                  Colors.white,
                ],
              ),
            ),
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(22),
                child: _kartuLogin(),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _bagianSambutan() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            warnaTema.withOpacity(0.18),
            const Color(0xFFEFF7FF),
            warnaTema.withOpacity(0.28),
          ],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -100,
            left: -80,
            child: _lingkaran(
              280,
              warnaTema.withOpacity(0.25),
            ),
          ),
          Positioned(
            bottom: -120,
            left: 100,
            child: _lingkaran(
              330,
              warnaTema.withOpacity(0.16),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(35),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 95,
                    height: 95,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [warnaTema, warnaKedua],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: warnaTema.withOpacity(0.25),
                          blurRadius: 25,
                          spreadRadius: 4,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.shopping_bag_rounded,
                      color: Colors.white,
                      size: 48,
                    ),
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    'Selamat Datang di',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      color: Color(0xFF173B73),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Trevia Bag! ✨',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 42,
                      fontWeight: FontWeight.bold,
                      color: warnaTema,
                    ),
                  ),
                  const SizedBox(height: 18),
                  const Text(
                    'Temukan tas favoritmu\n'
                    'untuk melengkapi gayamu!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      height: 1.6,
                      color: Color(0xFF55729E),
                    ),
                  ),
                  const SizedBox(height: 28),
                  Container(
                    width: 70,
                    height: 4,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: warnaTema,
                    ),
                  ),
                  const SizedBox(height: 25),
                  const Text(
                    '"Tampil percaya diri,\n'
                    'mulai dari pilihan tas\n'
                    'yang tepat."',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 17,
                      fontStyle: FontStyle.italic,
                      color: Color(0xFF607DAD),
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 35),
                  Row(
                    children: [
                      _fitur(
                        Icons.shopping_bag_outlined,
                        'Pilihan',
                        'Tas stylish',
                      ),
                      _fitur(
                        Icons.favorite_outline,
                        'Menarik',
                        'Model elegan',
                      ),
                      _fitur(
                        Icons.auto_awesome,
                        'Modern',
                        'Tampil trendi',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _kartuLogin() {
    return Container(
      constraints: const BoxConstraints(maxWidth: 520),
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: warnaTema.withOpacity(0.10),
            blurRadius: 30,
            spreadRadius: 3,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 82,
              height: 82,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [warnaTema, warnaKedua],
                ),
              ),
              child: const Icon(
                Icons.shopping_bag_rounded,
                color: Colors.white,
                size: 42,
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Center(
            child: Text(
              'Masuk ke Trevia Bag',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 27,
                fontWeight: FontWeight.bold,
                color: Color(0xFF173B73),
              ),
            ),
          ),
          const SizedBox(height: 10),
          const Center(
            child: Text(
              'Silakan masukkan username dan password\n'
              'untuk melanjutkan',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                height: 1.5,
                color: Color(0xFF7185A5),
              ),
            ),
          ),
          const SizedBox(height: 30),
          const Text(
            'Username',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF173B73),
            ),
          ),
          const SizedBox(height: 9),
          TextField(
            controller: usernameController,
            decoration: _dekorasiInput(
              'Masukkan username kamu',
              Icons.person_outline,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Password',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF173B73),
            ),
          ),
          const SizedBox(height: 9),
          TextField(
            controller: passwordController,
            obscureText: !passwordVisible,
            onSubmitted: (_) => login(),
            decoration: _dekorasiInput(
              'Masukkan password kamu',
              Icons.lock_outline,
            ).copyWith(
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    passwordVisible = !passwordVisible;
                  });
                },
                icon: Icon(
                  passwordVisible
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Checkbox(
                value: rememberMe,
                activeColor: warnaTema,
                onChanged: (value) {
                  setState(() {
                    rememberMe = value ?? false;
                  });
                },
              ),
              const Flexible(
                child: Text(
                  'Ingat saya',
                  style: TextStyle(
                    color: Color(0xFF61799E),
                  ),
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Silakan hubungi pengelola untuk '
                        'bantuan password.',
                      ),
                    ),
                  );
                },
                child: Text(
                  'Lupa password?',
                  style: TextStyle(
                    color: warnaTema,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [warnaTema, warnaKedua],
                ),
                borderRadius: BorderRadius.circular(17),
              ),
              child: ElevatedButton(
                onPressed: login,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(17),
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.login, color: Colors.white),
                    SizedBox(width: 12),
                    Text(
                      'MASUK',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 22),
          Center(
            child: TextButton.icon(
              onPressed: pilihWarnaTema,
              icon: Icon(
                Icons.palette_outlined,
                color: warnaTema,
              ),
              label: Text(
                'Ganti Warna Tema',
                style: TextStyle(
                  color: warnaTema,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _dekorasiInput(
    String hint,
    IconData ikon,
  ) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(ikon, color: warnaTema),
      filled: true,
      fillColor: const Color(0xFFF4F8FF),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(17),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(17),
        borderSide: const BorderSide(
          color: Color(0xFFD6E6FF),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(17),
        borderSide: BorderSide(
          color: warnaTema,
          width: 2,
        ),
      ),
    );
  }

  Widget _lingkaran(double ukuran, Color warna) {
    return Container(
      width: ukuran,
      height: ukuran,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: warna,
      ),
    );
  }

  Widget _fitur(
    IconData ikon,
    String judul,
    String subjudul,
  ) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 5),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.7),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.white),
        ),
        child: Column(
          children: [
            Icon(ikon, color: warnaTema, size: 28),
            const SizedBox(height: 8),
            Text(
              judul,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFF173B73),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subjudul,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 10,
                color: Color(0xFF7185A5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
