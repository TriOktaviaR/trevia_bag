import 'package:flutter/material.dart';
import '../model/product.dart';
import '../model/products.dart';
import 'login_page.dart';


// Data pesanan disimpan selama aplikasi berjalan.
class OrderRecord {
  final String id;
  final DateTime tanggal;
  final Map<Product, int> produk;
  final String nama;
  final String telepon;
  final String alamat;
  final String kurir;
  final String pembayaran;
  final String catatan;
  final String voucher;
  final double subtotal;
  final double ongkir;
  final double diskon;
  final double total;
  String status;

  OrderRecord({
    required this.id,
    required this.tanggal,
    required this.produk,
    required this.nama,
    required this.telepon,
    required this.alamat,
    required this.kurir,
    required this.pembayaran,
    required this.catatan,
    required this.voucher,
    required this.subtotal,
    required this.ongkir,
    required this.diskon,
    required this.total,
    this.status = 'Pesanan dikonfirmasi',
  });
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0;
  int warnaIndex = 0;

  final TextEditingController searchController =
      TextEditingController();

  String selectedCategory = 'Semua';
  final Set<int> favoriteProducts = {};
  final List<Product> cartProducts = [];
  final List<OrderRecord> riwayatPesanan = [];

  final List<List<Color>> daftarWarna = [
    [const Color(0xff536DFE), const Color(0xff7C4DFF)],
    [const Color(0xffEC407A), const Color(0xffFF7043)],
    [const Color(0xff26A69A), const Color(0xff43A047)],
    [const Color(0xffFF8F00), const Color(0xffF4511E)],
  ];

  Color get warnaUtama => daftarWarna[warnaIndex][0];
  Color get warnaKedua => daftarWarna[warnaIndex][1];

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void gantiWarna() {
    setState(() {
      warnaIndex = (warnaIndex + 1) % daftarWarna.length;
    });
  }

  List<String> get categories {
    final Set<String> hasil = {'Semua'};
    for (final product in products) {
      hasil.add(product.category);
    }
    return hasil.toList();
  }

  List<Product> get filteredProducts {
    final keyword = searchController.text.trim().toLowerCase();

    return products.where((product) {
      final cocokKategori = selectedCategory == 'Semua' ||
          product.category == selectedCategory;

      final cocokSearch =
          product.name.toLowerCase().contains(keyword) ||
              product.category.toLowerCase().contains(keyword);

      return cocokKategori && cocokSearch;
    }).toList();
  }

  void tambahKeKeranjang(Product product) {
    setState(() {
      cartProducts.add(product);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product.name} ditambahkan ke keranjang 🛒'),
        duration: const Duration(seconds: 1),
        action: SnackBarAction(
          label: 'LIHAT',
          textColor: Colors.white,
          onPressed: bukaKeranjang,
        ),
      ),
    );
  }

  void bukaKeranjang() {
    flutter runf(
      context,
      MaterialPageRoute(
        builder: (context) => CartPage(
          cartProducts: cartProducts,
          warnaUtama: warnaUtama,
          warnaKedua: warnaKedua,
          onCartChanged: () => setState(() {}),
          onOrderCreated: (pesanan) {
            setState(() => riwayatPesanan.insert(0, pesanan));
          },
        ),
      ),
    ).then((_) => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF6F7FB),
      body: selectedIndex == 0
          ? _homePage()
          : selectedIndex == 1
              ? _halamanRiwayat()
              : _aboutMe(),
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: (index) {
          setState(() => selectedIndex = index);
        },
        indicatorColor: warnaUtama.withOpacity(0.15),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.receipt_long_outlined),
            selectedIcon: Icon(Icons.receipt_long),
            label: 'Pesanan',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'About Me',
          ),
        ],
      ),
    );
  }

  Widget _homePage() {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Container(
            padding: const EdgeInsets.fromLTRB(22, 20, 22, 25),
            decoration: BoxDecoration(
              // Foto background pink hanya untuk bagian header Home.
              // Simpan gambar dengan nama assets/background_pink.png.
              color: const Color(0xFFF8C8DC),
              image: const DecorationImage(
                image: AssetImage('assets/background_pink.png'),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Color(0x33EC407A),
                  BlendMode.srcOver,
                ),
              ),
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(30),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 45,
                      height: 45,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.18),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(
                        Icons.shopping_bag_outlined,
                        color: Colors.white,
                        size: 25,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        'TREVIA BAG',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ),
                    _headerButton(Icons.palette_outlined, gantiWarna),
                    const SizedBox(width: 8),
                    _keranjangHeader(),
                    const SizedBox(width: 8),
                    InkWell(
                      onTap: () => setState(() => selectedIndex = 1),
                      borderRadius: BorderRadius.circular(30),
                      child: const CircleAvatar(
                        radius: 21,
                        backgroundColor: Colors.white,
                        child: CircleAvatar(
                          radius: 18,
                          backgroundImage: AssetImage('assets/profile.png'),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 27),

                // SAMBUTAN TREVIA BAG
                const Text(
                  'WELCOME TO',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 3,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'TREVIA BAG ✨',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Your Style, Your Story',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 21,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 7),
                Text(
                  'Temukan koleksi tas elegan dan stylish '
                  'untuk melengkapi penampilanmu setiap hari.',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 14,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 20),

                // PENCARIAN
                Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: TextField(
                    controller: searchController,
                    onChanged: (_) => setState(() {}),
                    decoration: const InputDecoration(
                      hintText: 'Cari tas favoritmu...',
                      prefixIcon: Icon(Icons.search),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // KATEGORI
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(22, 22, 22, 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Kategori',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 42,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: categories.length,
                    separatorBuilder: (_, __) =>
                        const SizedBox(width: 8),
                    itemBuilder: (context, index) {
                      final category = categories[index];
                      final selected = selectedCategory == category;

                      return GestureDetector(
                        onTap: () {
                          setState(() => selectedCategory = category);
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 17,
                          ),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: selected ? warnaUtama : Colors.white,
                            borderRadius: BorderRadius.circular(22),
                            border: Border.all(
                              color: selected
                                  ? warnaUtama
                                  : Colors.grey.shade200,
                            ),
                          ),
                          child: Text(
                            category,
                            style: TextStyle(
                              color: selected
                                  ? Colors.white
                                  : Colors.black87,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),

        // JUDUL PRODUK
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(22, 25, 22, 15),
            child: Row(
              children: [
                const Expanded(
                  child: Text(
                    'Koleksi Tas ✨',
                    style: TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  '${filteredProducts.length} Produk',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ),

        // GRID PRODUK
        filteredProducts.isEmpty
            ? const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(50),
                  child: Center(
                    child: Column(
                      children: [
                        Icon(
                          Icons.search_off,
                          size: 55,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Produk tidak ditemukan',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            : SliverPadding(
                padding: const EdgeInsets.fromLTRB(18, 0, 18, 30),
                sliver: SliverLayoutBuilder(
                  builder: (context, constraints) {
                    final lebar = constraints.crossAxisExtent;
                    final jumlahKolom = lebar >= 1200
                        ? 4
                        : lebar >= 800
                            ? 3
                            : 2;

                    return SliverGrid(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) => _productCard(
                          filteredProducts[index],
                          index,
                        ),
                        childCount: filteredProducts.length,
                      ),
                      gridDelegate:
                          SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: jumlahKolom,
                        crossAxisSpacing: 14,
                        mainAxisSpacing: 14,
                        childAspectRatio: jumlahKolom == 4
                            ? 0.78
                            : jumlahKolom == 3
                                ? 0.75
                                : 0.70,
                      ),
                    );
                  },
                ),
              ),
      ],
    );
  }

  Widget _headerButton(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30),
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.18),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white, size: 22),
      ),
    );
  }

  Widget _keranjangHeader() {
    return InkWell(
      onTap: bukaKeranjang,
      borderRadius: BorderRadius.circular(30),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.18),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.shopping_cart_outlined,
              color: Colors.white,
              size: 22,
            ),
          ),
          if (cartProducts.isNotEmpty)
            Positioned(
              right: -3,
              top: -3,
              child: Container(
                width: 19,
                height: 19,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '${cartProducts.length}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _productCard(Product product, int index) {
    final isFavorite = favoriteProducts.contains(index);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ProductDetailPage(
              product: product,
              warnaUtama: warnaUtama,
              warnaKedua: warnaKedua,
              onAddToCart: () => tambahKeKeranjang(product),
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 6,
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xffF3F3F5),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Image.asset(
                          product.imageUrl,
                          fit: BoxFit.contain,
                          errorBuilder: (_, __, ___) =>
                              const Center(
                            child: Icon(
                              Icons.image_not_supported_outlined,
                              size: 40,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 14,
                    right: 14,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          if (isFavorite) {
                            favoriteProducts.remove(index);
                          } else {
                            favoriteProducts.add(index);
                          }
                        });
                      },
                      child: Container(
                        width: 34,
                        height: 34,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          isFavorite
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: isFavorite ? Colors.red : Colors.grey,
                          size: 19,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(11, 1, 11, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.category,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: warnaUtama,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      product.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        height: 1.2,
                      ),
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        if (product.rating > 0) ...[
                          const Icon(
                            Icons.star,
                            color: Colors.amber,
                            size: 14,
                          ),
                          const SizedBox(width: 3),
                          Text(
                            product.rating.toStringAsFixed(1),
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                        const Spacer(),
                        Flexible(
                          child: Text(
                            product.price,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: warnaUtama,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        GestureDetector(
                          onTap: () => tambahKeKeranjang(product),
                          child: Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [warnaUtama, warnaKedua],
                              ),
                              borderRadius: BorderRadius.circular(9),
                            ),
                            child: const Icon(
                              Icons.shopping_cart_outlined,
                              color: Colors.white,
                              size: 17,
                            ),
                          ),
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
    );
  }

  Widget _halamanRiwayat() {
    return OrderHistoryPage(
      pesanan: riwayatPesanan,
      warnaUtama: warnaUtama,
      warnaKedua: warnaKedua,
      onStatusChanged: () => setState(() {}),
    );
  }

  Widget _aboutMe() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 35, 20, 30),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [warnaUtama, warnaKedua],
              ),
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(30),
              ),
            ),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 58,
                  backgroundColor: Colors.white,
                  child: ClipOval(
                    child: Image.asset(
                      'assets/profile.png',
                      width: 112,
                      height: 112,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Icon(
                        Icons.person,
                        size: 60,
                        color: warnaUtama,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                const Text(
                  '✨ Tri Oktavia Ramadhani ✨',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Teknik Informatika 2025 H',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              children: [
                _card(
                  title: '✨ Tentang Saya',
                  child: const Text(
                    'Halo! Saya Tri Oktavia Ramadhani, mahasiswa Teknik Informatika Universitas Negeri Surabaya. Saya sedang belajar membuat aplikasi menggunakan Flutter dan terus mengembangkan kemampuan saya di bidang teknologi.',
                    style: TextStyle(fontSize: 14, height: 1.7),
                  ),
                ),
                _card(
                  title: '👤 Biodata Saya',
                  child: Column(
                    children: [
                      _info('Nama', 'Tri Oktavia Ramadhani'),
                      _info('NIM', '25051204413'),
                      _info('Program Studi', 'Teknik Informatika'),
                      _info('Kelas', 'Teknik Informatika 2025 H'),
                      _info(
                        'Universitas',
                        'Universitas Negeri Surabaya',
                      ),
                    ],
                  ),
                ),
                _card(
                  title: '🎨 Hobi Saya',
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _hobi('Melukis'),
                      _hobi('Membaca'),
                      _hobi('Menggambar'),
                    ],
                  ),
                ),
                _card(
                  title: '💬 Motto',
                  child: Text(
                    '“Salah jurusan bukan berarti salah masa depan; '
                    'tidak ada ilmu yang sia-sia jika dipelajari '
                    'dengan niat ikhlas.”',
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.7,
                      fontStyle: FontStyle.italic,
                      color: warnaText(),
                    ),
                  ),
                ),

                // TOMBOL LOGOUT
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _konfirmasiLogout,
                    icon: const Icon(Icons.logout),
                    label: const Text(
                      'Logout dari Akun',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _konfirmasiLogout() {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text('Konfirmasi Logout'),
        content: const Text(
          'Apakah kamu yakin ingin keluar dari Trevia Bag?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Batal'),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(dialogContext);
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (_) => const LoginPage(),
                ),
                (route) => false,
              );
            },
            icon: const Icon(Icons.logout),
            label: const Text('Ya, Logout'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _card({
    required String title,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: warnaUtama,
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 13),
          child,
        ],
      ),
    );
  }

  Widget _info(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ),
          const Text(': '),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }

  Widget _hobi(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 9,
      ),
      decoration: BoxDecoration(
        color: warnaUtama.withOpacity(0.1),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: warnaUtama,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Color warnaText() => const Color(0xff252A40);
}

// =======================================================
// DETAIL PRODUK
// =======================================================

class ProductDetailPage extends StatelessWidget {
  final Product product;
  final Color warnaUtama;
  final Color warnaKedua;
  final VoidCallback onAddToCart;

  const ProductDetailPage({
    super.key,
    required this.product,
    required this.warnaUtama,
    required this.warnaKedua,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F7FF),
      appBar: AppBar(
        title: const Text(
          'Detail Produk',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: warnaUtama,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: 330,
              color: Colors.white,
              child: Image.asset(
                product.imageUrl,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => const Center(
                  child: Icon(
                    Icons.image_not_supported_outlined,
                    size: 65,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.category,
                    style: TextStyle(
                      color: warnaUtama,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    product.price,
                    style: TextStyle(
                      color: warnaKedua,
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (product.rating > 0) ...[
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber),
                        const SizedBox(width: 5),
                        Text(
                          '${product.rating.toStringAsFixed(1)} / 5.0',
                        ),
                      ],
                    ),
                  ],
                  const SizedBox(height: 22),
                  const Divider(),
                  const SizedBox(height: 18),
                  const Text(
                    'Deskripsi Produk',
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    product.description,
                    style: const TextStyle(
                      fontSize: 14,
                      height: 1.7,
                    ),
                  ),
                  const SizedBox(height: 25),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        onAddToCart();
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.shopping_cart_outlined,
                      ),
                      label: const Text(
                        'Tambah ke Keranjang',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: warnaUtama,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =======================================================
// HALAMAN KERANJANG
// =======================================================

class CartPage extends StatefulWidget {
  final List<Product> cartProducts;
  final Color warnaUtama;
  final Color warnaKedua;
  final VoidCallback onCartChanged;
  final ValueChanged<OrderRecord> onOrderCreated;

  const CartPage({
    super.key,
    required this.cartProducts,
    required this.warnaUtama,
    required this.warnaKedua,
    required this.onCartChanged,
    required this.onOrderCreated,
  });

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final Map<Product, int> jumlahProduk = {};

  @override
  void initState() {
    super.initState();
    for (final product in widget.cartProducts) {
      jumlahProduk[product] = (jumlahProduk[product] ?? 0) + 1;
    }
  }

  double hargaProduk(Product product) {
    final harga = product.price
        .replaceAll('Rp', '')
        .replaceAll('.', '')
        .replaceAll(',', '')
        .trim();

    return double.tryParse(harga) ?? 0;
  }

  String formatRupiah(double angka) {
    final value = angka.toInt().toString();
    final buffer = StringBuffer();

    for (int i = 0; i < value.length; i++) {
      if (i > 0 && (value.length - i) % 3 == 0) {
        buffer.write('.');
      }
      buffer.write(value[i]);
    }

    return 'Rp ${buffer.toString()}';
  }

  double get total {
    double hasil = 0;
    jumlahProduk.forEach((product, jumlah) {
      hasil += hargaProduk(product) * jumlah;
    });
    return hasil;
  }

  int get totalBarang {
    int hasil = 0;
    jumlahProduk.forEach((product, jumlah) {
      hasil += jumlah;
    });
    return hasil;
  }

  void checkout() {
    if (jumlahProduk.isEmpty) return;
    final itemPesanan = Map<Product, int>.from(jumlahProduk);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CheckoutPage(
          produk: itemPesanan,
          subtotal: total,
          warnaUtama: widget.warnaUtama,
          warnaKedua: widget.warnaKedua,
          onOrderCreated: (pesanan) {
            widget.onOrderCreated(pesanan);
            setState(() {
              jumlahProduk.clear();
              widget.cartProducts.clear();
            });
            widget.onCartChanged();
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final daftarProduk = jumlahProduk.keys.toList();

    return Scaffold(
      backgroundColor: const Color(0xffF6F7FB),
      appBar: AppBar(
        title: const Text('Keranjang Saya 🛒'),
        backgroundColor: widget.warnaUtama,
        foregroundColor: Colors.white,
      ),
      body: jumlahProduk.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.shopping_cart_outlined,
                    size: 80,
                    color: widget.warnaUtama.withOpacity(0.35),
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    'Keranjang masih kosong',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Yuk pilih tas favoritmu!',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(15),
                    itemCount: daftarProduk.length,
                    itemBuilder: (context, index) {
                      final product = daftarProduk[index];
                      final jumlah = jumlahProduk[product] ?? 1;
                      return _itemKeranjang(product, jumlah);
                    },
                  ),
                ),
                _bagianCheckout(),
              ],
            ),
    );
  }

  Widget _itemKeranjang(Product product, int jumlah) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 75,
            height: 75,
            decoration: BoxDecoration(
              color: const Color(0xffF5F7FF),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Padding(
              padding: const EdgeInsets.all(7),
              child: Image.asset(
                product.imageUrl,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => const Icon(
                  Icons.image_not_supported_outlined,
                  color: Colors.grey,
                ),
              ),
            ),
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  product.price,
                  style: TextStyle(
                    color: widget.warnaUtama,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 7),
                Row(
                  children: [
                    _tombolJumlah(Icons.remove, () {
                      setState(() {
                        if (jumlah > 1) {
                          jumlahProduk[product] = jumlah - 1;
                        } else {
                          jumlahProduk.remove(product);
                        }
                        _sinkronkanKeranjang();
                      });
                    }),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 11),
                      child: Text(
                        '$jumlah',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    _tombolJumlah(Icons.add, () {
                      setState(() {
                        jumlahProduk[product] = jumlah + 1;
                        _sinkronkanKeranjang();
                      });
                    }),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              setState(() {
                jumlahProduk.remove(product);
                _sinkronkanKeranjang();
              });
            },
            icon: const Icon(
              Icons.delete_outline,
              color: Colors.red,
            ),
          ),
        ],
      ),
    );
  }

  void _sinkronkanKeranjang() {
    widget.cartProducts
      ..clear()
      ..addAll(
        jumlahProduk.entries.expand(
          (entry) => List<Product>.filled(entry.value, entry.key),
        ),
      );
    widget.onCartChanged();
  }

  Widget _tombolJumlah(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: widget.warnaUtama.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          size: 16,
          color: widget.warnaUtama,
        ),
      ),
    );
  }

  Widget _bagianCheckout() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total Pembayaran',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 13,
                ),
              ),
              Text(
                formatRupiah(total),
                style: TextStyle(
                  color: widget.warnaUtama,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton.icon(
              onPressed: checkout,
              icon: const Icon(Icons.shopping_bag),
              label: const Text(
                'CHECKOUT SEKARANG',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: widget.warnaUtama,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// =======================================================
// CHECKOUT LENGKAP
// =======================================================
class CheckoutPage extends StatefulWidget {
  final Map<Product, int> produk;
  final double subtotal;
  final Color warnaUtama;
  final Color warnaKedua;
  final ValueChanged<OrderRecord> onOrderCreated;

  const CheckoutPage({
    super.key,
    required this.produk,
    required this.subtotal,
    required this.warnaUtama,
    required this.warnaKedua,
    required this.onOrderCreated,
  });

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final _formKey = GlobalKey<FormState>();
  final _nama = TextEditingController();
  final _telepon = TextEditingController();
  final _alamat = TextEditingController();
  final _catatan = TextEditingController();
  final _voucher = TextEditingController();

  String kurir = 'Reguler (Rp10.000)';
  String pembayaran = 'Transfer Bank';
  bool voucherValid = false;
  bool sedangMemproses = false;

  double get ongkir => kurir == 'Express (Rp20.000)' ? 20000 : 10000;
  double get diskon => voucherValid ? widget.subtotal * 0.10 : 0;
  double get total => (widget.subtotal + ongkir - diskon)
      .clamp(0, double.infinity).toDouble();

  String formatRupiah(num angka) {
    final value = angka.round().toString();
    final buffer = StringBuffer();
    for (int i = 0; i < value.length; i++) {
      if (i > 0 && (value.length - i) % 3 == 0) buffer.write('.');
      buffer.write(value[i]);
    }
    return 'Rp ${buffer.toString()}';
  }

  @override
  void dispose() {
    _nama.dispose();
    _telepon.dispose();
    _alamat.dispose();
    _catatan.dispose();
    _voucher.dispose();
    super.dispose();
  }

  void terapkanVoucher() {
    setState(() {
      voucherValid = _voucher.text.trim().toUpperCase() == 'TREVIA10';
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(voucherValid
            ? 'Voucher TREVIA10 berhasil! Diskon 10%.'
            : 'Voucher tidak valid. Coba kode TREVIA10.'),
      ),
    );
  }

  void buatPesanan() {
    if (!_formKey.currentState!.validate()) return;
    setState(() => sedangMemproses = true);
    final pesanan = OrderRecord(
      id: 'TV${DateTime.now().millisecondsSinceEpoch}',
      tanggal: DateTime.now(),
      produk: Map<Product, int>.from(widget.produk),
      nama: _nama.text.trim(),
      telepon: _telepon.text.trim(),
      alamat: _alamat.text.trim(),
      kurir: kurir,
      pembayaran: pembayaran,
      catatan: _catatan.text.trim().isEmpty ? '-' : _catatan.text.trim(),
      voucher: voucherValid ? 'TREVIA10' : '-', 
      subtotal: widget.subtotal,
      ongkir: ongkir,
      diskon: diskon,
      total: total,
    );
    widget.onOrderCreated(pesanan);
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        icon: Icon(Icons.check_circle, color: widget.warnaUtama, size: 52),
        title: const Text('Pesanan berhasil dibuat!'),
        content: const Text(
          'Pesananmu tersimpan di Riwayat Pesanan. Kamu dapat melihat detail atau membatalkannya dari halaman Pesanan.',
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: widget.warnaUtama,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(dialogContext);
              Navigator.pop(context);
            },
            child: const Text('Lihat Keranjang'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF6F7FB),
      appBar: AppBar(
        title: const Text('Checkout Pesanan'),
        backgroundColor: widget.warnaUtama,
        foregroundColor: Colors.white,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _judulBagian('Data Pembeli', Icons.person_outline),
            _input(_nama, 'Nama lengkap', Icons.person, 'Masukkan nama lengkap'),
            const SizedBox(height: 12),
            _input(_telepon, 'Nomor telepon', Icons.phone, 'Masukkan nomor telepon',
                keyboardType: TextInputType.phone),
            const SizedBox(height: 12),
            _input(_alamat, 'Alamat lengkap', Icons.location_on,
                'Nama jalan, nomor rumah, desa, kecamatan, kota/kabupaten',
                maxLines: 3),
            const SizedBox(height: 12),
            _input(_catatan, 'Catatan (opsional)', Icons.note_alt_outlined,
                'Contoh: rumah pagar putih', requiredField: false),
            const SizedBox(height: 20),
            _judulBagian('Pengiriman', Icons.local_shipping_outlined),
            _dropdown<String>(
              value: kurir,
              label: 'Pilih kurir',
              items: const ['Reguler (Rp10.000)', 'Express (Rp20.000)'],
              onChanged: (v) => setState(() => kurir = v!),
            ),
            const SizedBox(height: 20),
            _judulBagian('Metode Pembayaran', Icons.account_balance_wallet_outlined),
            _dropdown<String>(
              value: pembayaran,
              label: 'Metode pembayaran',
              items: const [
                'Transfer Bank',
                'COD (Bayar di Tempat)',
                'E-Wallet',
                'Virtual Account',
              ],
              onChanged: (v) => setState(() => pembayaran = v!),
            ),
            const SizedBox(height: 20),
            _judulBagian('Voucher Diskon', Icons.local_offer_outlined),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _voucher,
                    textCapitalization: TextCapitalization.characters,
                    decoration: InputDecoration(
                      hintText: 'Masukkan kode voucher',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: terapkanVoucher,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: widget.warnaUtama,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 14),
                  ),
                  child: const Text('Pakai'),
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.only(top: 7),
              child: Text('Gunakan TREVIA10 untuk diskon 10%.',
                  style: TextStyle(color: Colors.grey, fontSize: 12)),
            ),
            const SizedBox(height: 20),
            _judulBagian('Ringkasan Pembayaran', Icons.receipt_long),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  ...widget.produk.entries.map((e) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: Text('${e.key.name} × ${e.value}')),
                        Text(formatRupiah(_harga(e.key.price) * e.value)),
                      ],
                    ),
                  )),
                  const Divider(height: 22),
                  _barisHarga('Subtotal', widget.subtotal),
                  const SizedBox(height: 8),
                  _barisHarga('Ongkos kirim', ongkir),
                  const SizedBox(height: 8),
                  _barisHarga('Diskon voucher', -diskon,
                      warna: voucherValid ? Colors.green : null),
                  const Divider(height: 22),
                  _barisHarga('Total pembayaran', total,
                      tebal: true, warna: widget.warnaUtama),
                ],
              ),
            ),
            const SizedBox(height: 18),
            SizedBox(
              height: 52,
              child: ElevatedButton.icon(
                onPressed: sedangMemproses ? null : buatPesanan,
                icon: const Icon(Icons.shopping_bag_outlined),
                label: const Text('BUAT PESANAN',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: widget.warnaUtama,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  double _harga(String harga) => double.tryParse(
      harga.replaceAll('Rp', '').replaceAll('.', '').replaceAll(',', '').trim()) ?? 0;

  Widget _judulBagian(String judul, IconData icon) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Row(children: [
      Icon(icon, color: widget.warnaUtama),
      const SizedBox(width: 8),
      Text(judul, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
    ]),
  );

  Widget _input(TextEditingController controller, String label, IconData icon,
      String hint, {int maxLines = 1, TextInputType? keyboardType, bool requiredField = true}) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      validator: (value) {
        if (requiredField && (value == null || value.trim().isEmpty)) {
          return '$label wajib diisi';
        }
        if (label == 'Nomor telepon' && value != null &&
            value.trim().isNotEmpty && value.trim().length < 8) {
          return 'Nomor telepon minimal 8 digit';
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _dropdown<T>({
    required T value,
    required String label,
    required List<T> items,
    required ValueChanged<T?> onChanged,
  }) => DropdownButtonFormField<T>(
    value: value,
    decoration: InputDecoration(
      labelText: label,
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    ),
    items: items.map((item) => DropdownMenuItem<T>(
      value: item,
      child: Text(item.toString()),
    )).toList(),
    onChanged: onChanged,
  );

  Widget _barisHarga(String label, double nilai, {bool tebal = false, Color? warna}) =>
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(label, style: TextStyle(
              fontWeight: tebal ? FontWeight.bold : FontWeight.normal,
              color: warna,
            )),
          ),
          Text('${nilai < 0 ? '- ' : ''}${formatRupiah(nilai.abs())}',
            style: TextStyle(
              fontWeight: tebal ? FontWeight.bold : FontWeight.normal,
              color: warna,
            )),
        ],
      );
}

// =======================================================
// RIWAYAT PESANAN + PEMBATALAN
// =======================================================
class OrderHistoryPage extends StatefulWidget {
  final List<OrderRecord> pesanan;
  final Color warnaUtama;
  final Color warnaKedua;
  final VoidCallback onStatusChanged;

  const OrderHistoryPage({
    super.key,
    required this.pesanan,
    required this.warnaUtama,
    required this.warnaKedua,
    required this.onStatusChanged,
  });

  @override
  State<OrderHistoryPage> createState() => _OrderHistoryPageState();
}

class _OrderHistoryPageState extends State<OrderHistoryPage> {
  String formatRupiah(num angka) {
    final value = angka.round().toString();
    final buffer = StringBuffer();
    for (int i = 0; i < value.length; i++) {
      if (i > 0 && (value.length - i) % 3 == 0) buffer.write('.');
      buffer.write(value[i]);
    }
    return 'Rp ${buffer.toString()}';
  }

  String formatTanggal(DateTime tanggal) {
    final t = tanggal;
    return '${t.day.toString().padLeft(2, '0')}/${t.month.toString().padLeft(2, '0')}/${t.year} '
        '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';
  }

  void konfirmasiPembatalan(OrderRecord pesanan) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: const Text('Batalkan Pesanan?'),
        content: Text('Pesanan ${pesanan.id} akan dibatalkan. Pesanan tetap tersimpan di riwayat. Lanjutkan?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Tidak'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              setState(() => pesanan.status = 'Pesanan dibatalkan');
              widget.onStatusChanged();
              Navigator.pop(dialogContext);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Pesanan berhasil dibatalkan. Riwayat tetap tersimpan.')),
              );
            },
            child: const Text('Ya, Batalkan'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF6F7FB),
      appBar: AppBar(
        title: const Text('Riwayat Pesanan'),
        backgroundColor: widget.warnaUtama,
        foregroundColor: Colors.white,
      ),
      body: widget.pesanan.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.receipt_long_outlined, size: 76,
                      color: widget.warnaUtama.withOpacity(0.4)),
                  const SizedBox(height: 12),
                  const Text('Belum ada riwayat pesanan',
                      style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  const Text('Pesanan yang kamu buat akan tampil di sini.',
                      style: TextStyle(color: Colors.grey)),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(14),
              itemCount: widget.pesanan.length,
              itemBuilder: (context, index) {
                final p = widget.pesanan[index];
                final dibatalkan = p.status == 'Pesanan dibatalkan';
                return Card(
                  margin: const EdgeInsets.only(bottom: 14),
                  elevation: 2,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text('Pesanan ${p.id}',
                                  style: const TextStyle(fontWeight: FontWeight.bold)),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
                              decoration: BoxDecoration(
                                color: dibatalkan ? Colors.red.withOpacity(0.1) : Colors.green.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(p.status, style: TextStyle(
                                color: dibatalkan ? Colors.red : Colors.green.shade700,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              )),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(formatTanggal(p.tanggal),
                            style: const TextStyle(color: Colors.grey, fontSize: 12)),
                        const Divider(height: 22),
                        ...p.produk.entries.map((e) => Padding(
                          padding: const EdgeInsets.only(bottom: 7),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(child: Text('${e.key.name} × ${e.value}')),
                              Text(formatRupiah(_harga(e.key.price) * e.value)),
                            ],
                          ),
                        )),
                        const Divider(height: 18),
                        _baris('Nama pembeli', p.nama),
                        _baris('Telepon', p.telepon),
                        _baris('Alamat', p.alamat),
                        _baris('Kurir', p.kurir),
                        _baris('Pembayaran', p.pembayaran),
                        _baris('Catatan', p.catatan),
                        _baris('Voucher', p.voucher),
                        _baris('Subtotal', formatRupiah(p.subtotal)),
                        _baris('Ongkir', formatRupiah(p.ongkir)),
                        _baris('Diskon', '- ${formatRupiah(p.diskon)}'),
                        const Divider(height: 18),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Total', style: TextStyle(fontWeight: FontWeight.bold)),
                            Text(formatRupiah(p.total), style: TextStyle(
                              color: widget.warnaUtama,
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                            )),
                          ],
                        ),
                        if (!dibatalkan) ...[
                          const SizedBox(height: 14),
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton.icon(
                              onPressed: () => konfirmasiPembatalan(p),
                              icon: const Icon(Icons.cancel_outlined, color: Colors.red),
                              label: const Text('Batalkan Pesanan',
                                  style: TextStyle(color: Colors.red)),
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: Colors.redAccent),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  double _harga(String harga) => double.tryParse(
      harga.replaceAll('Rp', '').replaceAll('.', '').replaceAll(',', '').trim()) ?? 0;

  Widget _baris(String label, String value) => Padding(
    padding: const EdgeInsets.only(bottom: 7),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(width: 105, child: Text(label,
            style: const TextStyle(color: Colors.grey, fontSize: 12))),
        const Text(': '),
        Expanded(child: Text(value, style: const TextStyle(fontSize: 12))),
      ],
    ),
  );
}