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

  // =========================
  // WARNA
  // =========================
  static const Color biru = Color(0xFF3B82F6);
  static const Color biruMuda = Color(0xFF60A5FA);
  static const Color ungu = Color(0xFF6366F1);
  static const Color background = Color(0xFFEAF4FF);
  static const Color textDark = Color(0xFF173B73);

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: LayoutBuilder(
        builder: (context, constraints) {
          // ============================================
          // TAMPILAN DESKTOP / CHROME
          // ============================================
          if (constraints.maxWidth >= 800) {
            return Row(
              children: [
                // =========================
                // BAGIAN KIRI
                // =========================
                Expanded(
                  flex: 5,
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFFDCEEFF),
                          Color(0xFFEFF7FF),
                          Color(0xFFC9E1FF),
                        ],
                      ),
                    ),
                    child: Stack(
                      children: [
                        // Lingkaran dekorasi
                        Positioned(
                          top: -100,
                          left: -80,
                          child: _circle(
                            280,
                            const Color(0x553B82F6),
                          ),
                        ),

                        Positioned(
                          bottom: -120,
                          left: 100,
                          child: _circle(
                            330,
                            const Color(0x4460A5FA),
                          ),
                        ),

                        Positioned(
                          top: 100,
                          right: 30,
                          child: _circle(
                            90,
                            const Color(0x336366F1),
                          ),
                        ),

                        // Isi kiri
                        Center(
                          child: SingleChildScrollView(
                            padding: const EdgeInsets.all(50),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Logo
                                Container(
                                  width: 90,
                                  height: 90,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: const LinearGradient(
                                      colors: [
                                        biruMuda,
                                        biru,
                                        ungu,
                                      ],
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color:
                                            biru.withOpacity(0.25),
                                        blurRadius: 25,
                                        spreadRadius: 5,
                                      ),
                                    ],
                                  ),
                                  child: const Icon(
                                    Icons.person,
                                    color: Colors.white,
                                    size: 48,
                                  ),
                                ),

                                const SizedBox(height: 35),

                                // Welcome
                                const Text(
                                  'Hallo,',
                                  style: TextStyle(
                                    fontSize: 32,
                                    fontStyle: FontStyle.italic,
                                    color: textDark,
                                  ),
                                ),

                                const SizedBox(height: 2),

                                const Text(
                                  'Tri Oktavia! ✨',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 42,
                                    fontWeight: FontWeight.bold,
                                    color: biru,
                                  ),
                                ),

                                const SizedBox(height: 18),

                                const Text(
                                  'Selamat datang kembali di\naplikasi kami!',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Color(0xFF55729E),
                                    height: 1.5,
                                  ),
                                ),

                                const SizedBox(height: 28),

                                Container(
                                  width: 70,
                                  height: 4,
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.circular(20),
                                    gradient: const LinearGradient(
                                      colors: [
                                        biru,
                                        ungu,
                                      ],
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 25),

                                const Text(
                                  '"Langkah kecil hari ini,\nbisa menjadi cerita besar\ndi masa depan."',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontStyle: FontStyle.italic,
                                    color: Color(0xFF607DAD),
                                    height: 1.5,
                                  ),
                                ),

                                const SizedBox(height: 40),

                                // Fitur
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.center,
                                  children: [
                                    _feature(
                                      Icons.rocket_launch,
                                      'Mudah',
                                      'Akses cepat',
                                    ),
                                    _feature(
                                      Icons.security,
                                      'Aman',
                                      'Data terlindungi',
                                    ),
                                    _feature(
                                      Icons.auto_awesome,
                                      'Modern',
                                      'Desain elegan',
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // =========================
                // BAGIAN KANAN
                // =========================
                Expanded(
                  flex: 4,
                  child: Container(
                    color: Colors.white,
                    child: Center(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(45),
                        child: _loginCard(),
                      ),
                    ),
                  ),
                ),
              ],
            );
          }

          // ============================================
          // TAMPILAN HP / LAYAR KECIL
          // ============================================
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
                padding: const EdgeInsets.all(25),
                child: _loginCard(),
              ),
            ),
          );
        },
      ),
    );
  }

  // ==================================================
  // LOGIN CARD
  // ==================================================

  Widget _loginCard() {
    return Container(
      constraints: const BoxConstraints(
        maxWidth: 520,
      ),
      padding: const EdgeInsets.all(38),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.97),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.12),
            blurRadius: 35,
            spreadRadius: 5,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Logo kecil
          Center(
            child: Container(
              width: 82,
              height: 82,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [
                    biruMuda,
                    biru,
                    ungu,
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: biru.withOpacity(0.2),
                    blurRadius: 20,
                  ),
                ],
              ),
              child: const Icon(
                Icons.person,
                color: Colors.white,
                size: 45,
              ),
            ),
          ),

          const SizedBox(height: 25),

          const Center(
            child: Text(
              'Masuk ke Akun Anda',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: textDark,
              ),
            ),
          ),

          const SizedBox(height: 10),

          const Center(
            child: Text(
              'Silakan masukkan username dan password\nuntuk melanjutkan',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: Color(0xFF7185A5),
                height: 1.5,
              ),
            ),
          ),

          const SizedBox(height: 35),

          // USERNAME
          const Text(
            'Username',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: textDark,
            ),
          ),

          const SizedBox(height: 9),

          TextField(
            controller: usernameController,
            decoration: InputDecoration(
              hintText: 'Masukkan username kamu',
              prefixIcon: const Icon(
                Icons.person_outline,
                color: biru,
              ),
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
                borderSide: const BorderSide(
                  color: biru,
                  width: 2,
                ),
              ),
            ),
          ),

          const SizedBox(height: 22),

          // PASSWORD
          const Text(
            'Password',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: textDark,
            ),
          ),

          const SizedBox(height: 9),

          TextField(
            controller: passwordController,
            obscureText: !passwordVisible,
            decoration: InputDecoration(
              hintText: 'Masukkan password kamu',
              prefixIcon: const Icon(
                Icons.lock_outline,
                color: biru,
              ),
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
                  color: Colors.grey,
                ),
              ),
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
                borderSide: const BorderSide(
                  color: biru,
                  width: 2,
                ),
              ),
            ),
          ),

          const SizedBox(height: 15),

          // INGAT SAYA
          Row(
            children: [
              Checkbox(
                value: rememberMe,
                activeColor: biru,
                onChanged: (value) {
                  setState(() {
                    rememberMe = value ?? false;
                  });
                },
              ),
              const Text(
                'Ingat saya',
                style: TextStyle(
                  color: Color(0xFF61799E),
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: () {},
                child: const Text(
                  'Lupa password?',
                  style: TextStyle(
                    color: biru,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 15),

          // TOMBOL MASUK
          SizedBox(
            width: double.infinity,
            height: 58,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    biruMuda,
                    biru,
                    ungu,
                  ],
                ),
                borderRadius: BorderRadius.circular(17),
                boxShadow: [
                  BoxShadow(
                    color: biru.withOpacity(0.28),
                    blurRadius: 18,
                    offset: const Offset(0, 8),
                  ),
                ],
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
                    Icon(
                      Icons.login,
                      color: Colors.white,
                    ),
                    SizedBox(width: 12),
                    Text(
                      'MASUK',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 28),

          // GANTI TEMA
          Center(
            child: TextButton.icon(
              onPressed: () {},
              icon: const Icon(
                Icons.palette_outlined,
                color: biru,
              ),
              label: const Text(
                'Ganti Warna Tema',
                style: TextStyle(
                  color: biru,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==================================================
  // CIRCLE DEKORASI
  // ==================================================

  Widget _circle(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
    );
  }

  // ==================================================
  // FITUR
  // ==================================================

  Widget _feature(
    IconData icon,
    String title,
    String subtitle,
  ) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 6),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.7),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.white,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: biru,
              size: 30,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: textDark,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 11,
                color: Color(0xFF7185A5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}