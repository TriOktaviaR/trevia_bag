import 'package:flutter/material.dart';
import '../model/product.dart';
import '../model/products.dart';

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

  // =====================================================
  // KERANJANG
  // =====================================================

  final List<Product> cartProducts = [];

  // =====================================================
  // WARNA
  // =====================================================

  final List<List<Color>> daftarWarna = [
    [
      const Color(0xff536DFE),
      const Color(0xff7C4DFF),
    ],
    [
      const Color(0xffEC407A),
      const Color(0xffFF7043),
    ],
    [
      const Color(0xff26A69A),
      const Color(0xff43A047),
    ],
    [
      const Color(0xffFF8F00),
      const Color(0xffF4511E),
    ],
  ];

  Color get warnaUtama => daftarWarna[warnaIndex][0];
  Color get warnaKedua => daftarWarna[warnaIndex][1];

  // =====================================================
  // GANTI WARNA
  // =====================================================

  void gantiWarna() {
    setState(() {
      warnaIndex++;

      if (warnaIndex >= daftarWarna.length) {
        warnaIndex = 0;
      }
    });
  }

  // =====================================================
  // KATEGORI
  // =====================================================

  List<String> get categories {
    final Set<String> hasil = {'Semua'};

    for (final product in products) {
      hasil.add(product.category);
    }

    return hasil.toList();
  }

  // =====================================================
  // FILTER PRODUK
  // =====================================================

  List<Product> get filteredProducts {
    final keyword =
        searchController.text.trim().toLowerCase();

    return products.where((product) {
      final cocokKategori =
          selectedCategory == 'Semua' ||
              product.category == selectedCategory;

      final cocokSearch =
          product.name.toLowerCase().contains(keyword) ||
              product.category
                  .toLowerCase()
                  .contains(keyword);

      return cocokKategori && cocokSearch;
    }).toList();
  }

  // =====================================================
  // TAMBAH KERANJANG
  // =====================================================

  void tambahKeKeranjang(Product product) {
    setState(() {
      cartProducts.add(product);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${product.name} ditambahkan ke keranjang 🛒',
        ),
        duration: const Duration(seconds: 1),
        action: SnackBarAction(
          label: 'LIHAT',
          textColor: Colors.white,
          onPressed: bukaKeranjang,
        ),
      ),
    );
  }

  // =====================================================
  // BUKA KERANJANG
  // =====================================================

  void bukaKeranjang() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return CartPage(
            cartProducts: cartProducts,
            warnaUtama: warnaUtama,
            warnaKedua: warnaKedua,
            onCartChanged: () {
              setState(() {});
            },
          );
        },
      ),
    ).then((_) {
      setState(() {});
    });
  }

  // =====================================================
  // BUILD
  // =====================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF6F7FB),

      body: selectedIndex == 0
          ? _homePage()
          : _aboutMe(),

      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,

        onDestinationSelected: (index) {
          setState(() {
            selectedIndex = index;
          });
        },

        indicatorColor:
            warnaUtama.withOpacity(0.15),

        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
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

  // =====================================================
  // HOME
  // =====================================================

  Widget _homePage() {
    return CustomScrollView(
      slivers: [
        // =================================================
        // HEADER
        // =================================================

        SliverToBoxAdapter(
          child: Container(
            padding: const EdgeInsets.fromLTRB(
              22,
              20,
              22,
              25,
            ),

            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  warnaUtama,
                  warnaKedua,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),

              borderRadius:
                  const BorderRadius.vertical(
                bottom: Radius.circular(30),
              ),
            ),

            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [
                // =========================================
                // TOP BAR
                // =========================================

                Row(
                  children: [
                    Container(
                      width: 45,
                      height: 45,

                      decoration:
                          BoxDecoration(
                        color: Colors.white
                            .withOpacity(0.18),

                        borderRadius:
                            BorderRadius.circular(14),
                      ),

                      child: const Icon(
                        Icons
                            .shopping_bag_outlined,
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
                          fontWeight:
                              FontWeight.bold,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ),

                    // PALET WARNA

                    InkWell(
                      onTap: gantiWarna,

                      borderRadius:
                          BorderRadius.circular(30),

                      child: Container(
                        width: 42,
                        height: 42,

                        decoration:
                            BoxDecoration(
                          color: Colors.white
                              .withOpacity(0.18),
                          shape: BoxShape.circle,
                        ),

                        child: const Icon(
                          Icons.palette_outlined,
                          color: Colors.white,
                          size: 22,
                        ),
                      ),
                    ),

                    const SizedBox(width: 8),

                    // KERANJANG

                    InkWell(
                      onTap: bukaKeranjang,

                      borderRadius:
                          BorderRadius.circular(30),

                      child: Stack(
                        clipBehavior:
                            Clip.none,

                        children: [
                          Container(
                            width: 42,
                            height: 42,

                            decoration:
                                BoxDecoration(
                              color: Colors.white
                                  .withOpacity(0.18),
                              shape: BoxShape.circle,
                            ),

                            child: const Icon(
                              Icons
                                  .shopping_cart_outlined,
                              color:
                                  Colors.white,
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

                                alignment:
                                    Alignment.center,

                                decoration:
                                    const BoxDecoration(
                                  color: Colors.red,
                                  shape:
                                      BoxShape.circle,
                                ),

                                child: Text(
                                  '${cartProducts.length}',

                                  style:
                                      const TextStyle(
                                    color:
                                        Colors.white,
                                    fontSize: 9,
                                    fontWeight:
                                        FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 8),

                    // FOTO PROFIL

                    InkWell(
                      onTap: () {
                        setState(() {
                          selectedIndex = 1;
                        });
                      },

                      borderRadius:
                          BorderRadius.circular(30),

                      child: const CircleAvatar(
                        radius: 21,

                        backgroundColor:
                            Colors.white,

                        child: CircleAvatar(
                          radius: 18,

                          backgroundImage:
                              AssetImage(
                            'assets/profile.png',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 27),

                // =========================================
                // WELCOME
                // =========================================

                const Text(
                  'Welcome 👋',

                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 5),

                const Text(
                  'Tri Oktavia',

                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 7),

                Text(
                  'Temukan tas favoritmu dan tampil lebih stylish ✨',

                  style: TextStyle(
                    color:
                        Colors.white.withOpacity(0.88),
                    fontSize: 14,
                    height: 1.4,
                  ),
                ),

                const SizedBox(height: 20),

                // =========================================
                // SEARCH
                // =========================================

                Container(
                  height: 50,

                  decoration: BoxDecoration(
                    color: Colors.white,

                    borderRadius:
                        BorderRadius.circular(16),

                    boxShadow: [
                      BoxShadow(
                        color: Colors.black
                            .withOpacity(0.08),
                        blurRadius: 10,
                        offset:
                            const Offset(0, 4),
                      ),
                    ],
                  ),

                  child: TextField(
                    controller:
                        searchController,

                    onChanged: (value) {
                      setState(() {});
                    },

                    decoration:
                        const InputDecoration(
                      hintText:
                          'Cari tas favoritmu...',

                      prefixIcon:
                          Icon(Icons.search),

                      border:
                          InputBorder.none,

                      contentPadding:
                          EdgeInsets.symmetric(
                        vertical: 14,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // =================================================
        // KATEGORI
        // =================================================

        SliverToBoxAdapter(
          child: Padding(
            padding:
                const EdgeInsets.fromLTRB(
              22,
              22,
              22,
              5,
            ),

            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [
                const Text(
                  'Kategori',

                  style: TextStyle(
                    fontSize: 20,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 12),

                SizedBox(
                  height: 42,

                  child:
                      ListView.separated(
                    scrollDirection:
                        Axis.horizontal,

                    itemCount:
                        categories.length,

                    separatorBuilder:
                        (_, __) =>
                            const SizedBox(
                      width: 8,
                    ),

                    itemBuilder:
                        (context, index) {
                      final category =
                          categories[index];

                      final selected =
                          selectedCategory ==
                              category;

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedCategory =
                                category;
                          });
                        },

                        child:
                            AnimatedContainer(
                          duration:
                              const Duration(
                            milliseconds: 250,
                          ),

                          padding:
                              const EdgeInsets
                                  .symmetric(
                            horizontal: 17,
                          ),

                          alignment:
                              Alignment.center,

                          decoration:
                              BoxDecoration(
                            color: selected
                                ? warnaUtama
                                : Colors.white,

                            borderRadius:
                                BorderRadius
                                    .circular(22),

                            border: Border.all(
                              color: selected
                                  ? warnaUtama
                                  : Colors
                                      .grey
                                      .shade200,
                            ),
                          ),

                          child: Text(
                            category,

                            style:
                                TextStyle(
                              color: selected
                                  ? Colors.white
                                  : Colors.black87,

                              fontSize: 12,

                              fontWeight:
                                  FontWeight.w600,
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

        // =================================================
        // JUDUL PRODUK
        // =================================================

        SliverToBoxAdapter(
          child: Padding(
            padding:
                const EdgeInsets.fromLTRB(
              22,
              25,
              22,
              15,
            ),

            child: Row(
              children: [
                const Expanded(
                  child: Text(
                    'Koleksi Tas ✨',

                    style: TextStyle(
                      fontSize: 21,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),
                ),

                Text(
                  '${filteredProducts.length} Produk',

                  style: TextStyle(
                    color:
                        Colors.grey.shade600,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ),

        // =================================================
        // PRODUK RESPONSIVE
        // =================================================

        filteredProducts.isEmpty
            ? const SliverToBoxAdapter(
                child: Padding(
                  padding:
                      EdgeInsets.all(50),

                  child: Center(
                    child: Column(
                      children: [
                        Icon(
                          Icons.search_off,
                          size: 55,
                          color:
                              Colors.grey,
                        ),

                        SizedBox(
                          height: 10,
                        ),

                        Text(
                          'Produk tidak ditemukan',

                          style:
                              TextStyle(
                            color:
                                Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            : SliverPadding(
                padding:
                    const EdgeInsets.fromLTRB(
                  18,
                  0,
                  18,
                  30,
                ),

                sliver:
                    SliverLayoutBuilder(
                  builder:
                      (context, constraints) {
                    int jumlahKolom;

                    if (constraints
                            .crossAxisExtent >=
                        1200) {
                      jumlahKolom = 4;
                    } else if (constraints
                            .crossAxisExtent >=
                        800) {
                      jumlahKolom = 3;
                    } else {
                      jumlahKolom = 2;
                    }

                    return SliverGrid(
                      delegate:
                          SliverChildBuilderDelegate(
                        (context, index) {
                          final product =
                              filteredProducts[
                                  index];

                          return _productCard(
                            product,
                            index,
                          );
                        },

                        childCount:
                            filteredProducts
                                .length,
                      ),

                      gridDelegate:
                          SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount:
                            jumlahKolom,

                        crossAxisSpacing:
                            14,

                        mainAxisSpacing:
                            14,

                        childAspectRatio:
                            jumlahKolom == 4
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

  // =====================================================
  // PRODUCT CARD
  // =====================================================

  Widget _productCard(
    Product product,
    int index,
  ) {
    final isFavorite =
        favoriteProducts.contains(index);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return ProductDetailPage(
                product: product,
                warnaUtama: warnaUtama,
                warnaKedua: warnaKedua,
                onAddToCart: () {
                  tambahKeKeranjang(product);
                },
              );
            },
          ),
        );
      },

      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,

          borderRadius:
              BorderRadius.circular(18),

          boxShadow: [
            BoxShadow(
              color:
                  Colors.black.withOpacity(0.06),

              blurRadius: 10,

              offset:
                  const Offset(0, 4),
            ),
          ],
        ),

        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [
            // =============================================
            // FOTO PRODUK
            // =============================================

            Expanded(
              flex: 6,

              child: Stack(
                children: [
                  Container(
                    width:
                        double.infinity,

                    margin:
                        const EdgeInsets.all(8),

                    decoration:
                        BoxDecoration(
                      color:
                          const Color(0xffF3F3F5),

                      borderRadius:
                          BorderRadius.circular(
                        15,
                      ),
                    ),

                    child: ClipRRect(
                      borderRadius:
                          BorderRadius.circular(
                        15,
                      ),

                      child: Padding(
                        padding:
                            const EdgeInsets.all(
                          10,
                        ),

                        child: Image.asset(
                          product.imageUrl,

                          // FOTO TIDAK DIPAKSA
                          // MEMENUHI SELURUH KOTAK
                          fit: BoxFit.contain,

                          errorBuilder:
                              (
                            context,
                            error,
                            stackTrace,
                          ) {
                            return const Center(
                              child: Icon(
                                Icons
                                    .image_not_supported_outlined,

                                size: 40,

                                color:
                                    Colors.grey,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),

                  // FAVORITE

                  Positioned(
                    top: 14,
                    right: 14,

                    child:
                        GestureDetector(
                      onTap: () {
                        setState(() {
                          if (isFavorite) {
                            favoriteProducts
                                .remove(index);
                          } else {
                            favoriteProducts
                                .add(index);
                          }
                        });
                      },

                      child: Container(
                        width: 34,
                        height: 34,

                        decoration:
                            const BoxDecoration(
                          color: Colors.white,

                          shape:
                              BoxShape.circle,
                        ),

                        child: Icon(
                          isFavorite
                              ? Icons.favorite
                              : Icons.favorite_border,

                          color: isFavorite
                              ? Colors.red
                              : Colors.grey,

                          size: 19,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // =============================================
            // INFORMASI PRODUK
            // =============================================

            Expanded(
              flex: 4,

              child: Padding(
                padding:
                    const EdgeInsets.fromLTRB(
                  11,
                  1,
                  11,
                  10,
                ),

                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,

                  children: [
                    Text(
                      product.category,

                      maxLines: 1,

                      overflow:
                          TextOverflow.ellipsis,

                      style: TextStyle(
                        color:
                            warnaUtama,

                        fontSize: 10,

                        fontWeight:
                            FontWeight.w600,
                      ),
                    ),

                    const SizedBox(
                      height: 4,
                    ),

                    Text(
                      product.name,

                      maxLines: 2,

                      overflow:
                          TextOverflow.ellipsis,

                      style:
                          const TextStyle(
                        fontSize: 12,

                        fontWeight:
                            FontWeight.bold,

                        height: 1.2,
                      ),
                    ),

                    const Spacer(),

                    Row(
                      children: [
                        // RATING

                        if (product.rating > 0) ...[
                          const Icon(
                            Icons.star,
                            color:
                                Colors.amber,
                            size: 14,
                          ),

                          const SizedBox(
                            width: 3,
                          ),

                          Text(
                            product.rating
                                .toStringAsFixed(
                              1,
                            ),

                            style:
                                const TextStyle(
                              fontSize: 10,

                              fontWeight:
                                  FontWeight.w600,
                            ),
                          ),
                        ],

                        const Spacer(),

                        // HARGA

                        Flexible(
                          child: Text(
                            product.price,

                            maxLines: 1,

                            overflow:
                                TextOverflow
                                    .ellipsis,

                            style:
                                TextStyle(
                              color:
                                  warnaUtama,

                              fontSize: 11,

                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),
                        ),

                        const SizedBox(
                          width: 6,
                        ),

                        // KERANJANG

                        GestureDetector(
                          onTap: () {
                            tambahKeKeranjang(
                              product,
                            );
                          },

                          child:
                              Container(
                            width: 32,
                            height: 32,

                            decoration:
                                BoxDecoration(
                              gradient:
                                  LinearGradient(
                                colors: [
                                  warnaUtama,
                                  warnaKedua,
                                ],
                              ),

                              borderRadius:
                                  BorderRadius
                                      .circular(
                                9,
                              ),
                            ),

                            child:
                                const Icon(
                              Icons
                                  .shopping_cart_outlined,

                              color:
                                  Colors.white,

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

  // =====================================================
  // ABOUT ME
  // =====================================================

  Widget _aboutMe() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            width:
                double.infinity,

            padding:
                const EdgeInsets.fromLTRB(
              20,
              35,
              20,
              30,
            ),

            decoration:
                BoxDecoration(
              gradient:
                  LinearGradient(
                colors: [
                  warnaUtama,
                  warnaKedua,
                ],
              ),

              borderRadius:
                  const BorderRadius.vertical(
                bottom:
                    Radius.circular(30),
              ),
            ),

            child:
                Column(
              children: [
                CircleAvatar(
                  radius: 58,

                  backgroundColor:
                      Colors.white,

                  child:
                      ClipOval(
                    child:
                        Image.asset(
                      'assets/profile.png',

                      width: 112,
                      height: 112,

                      fit:
                          BoxFit.cover,

                      errorBuilder:
                          (
                        context,
                        error,
                        stackTrace,
                      ) {
                        return Icon(
                          Icons.person,

                          size: 60,

                          color:
                              warnaUtama,
                        );
                      },
                    ),
                  ),
                ),

                const SizedBox(
                  height: 15,
                ),

                const Text(
                  '✨ Tri Oktavia Ramadhani ✨',

                  textAlign:
                      TextAlign.center,

                  style:
                      TextStyle(
                    color:
                        Colors.white,

                    fontSize: 22,

                    fontWeight:
                        FontWeight.bold,
                  ),
                ),

                const SizedBox(
                  height: 6,
                ),

                const Text(
                  'Teknik Informatika 2025 H',

                  style:
                      TextStyle(
                    color:
                        Colors.white70,

                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding:
                const EdgeInsets.all(18),

            child:
                Column(
              children: [
                _card(
                  title:
                      '✨ Tentang Saya',

                  child:
                      const Text(
                    'Halo! Saya Tri Oktavia Ramadhani, mahasiswa Teknik Informatika Universitas Negeri Surabaya. Saya sedang belajar membuat aplikasi menggunakan Flutter dan terus mengembangkan kemampuan saya di bidang teknologi.',

                    style:
                        TextStyle(
                      fontSize: 14,
                      height: 1.7,
                    ),
                  ),
                ),

                _card(
                  title:
                      '👤 Biodata Saya',

                  child:
                      Column(
                    children: [
                      _info(
                        'Nama',
                        'Tri Oktavia Ramadhani',
                      ),

                      _info(
                        'NIM',
                        '25051204413',
                      ),

                      _info(
                        'Program Studi',
                        'Teknik Informatika',
                      ),

                      _info(
                        'Kelas',
                        'Teknik Informatika 2025 H',
                      ),

                      _info(
                        'Universitas',
                        'Universitas Negeri Surabaya',
                      ),
                    ],
                  ),
                ),

                _card(
                  title:
                      '🎨 Hobi Saya',

                  child:
                      Wrap(
                    spacing: 8,
                    runSpacing: 8,

                    children: [
                      _hobi(
                          'Melukis'),

                      _hobi(
                          'Membaca'),

                      _hobi(
                          'Menggambar'),
                    ],
                  ),
                ),

                _card(
                  title:
                      '💬 Motto',

                  child:
                      Text(
                    '“Salah jurusan bukan berarti salah masa depan; tidak ada ilmu yang sia-sia jika dipelajari dengan niat ikhlas.”',

                    style:
                        TextStyle(
                      fontSize: 14,

                      height: 1.7,

                      fontStyle:
                          FontStyle.italic,

                      color:
                          warnaText(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // =====================================================
  // CARD ABOUT
  // =====================================================

  Widget _card({
    required String title,
    required Widget child,
  }) {
    return Container(
      width:
          double.infinity,

      margin:
          const EdgeInsets.only(
        bottom: 15,
      ),

      padding:
          const EdgeInsets.all(18),

      decoration:
          BoxDecoration(
        color:
            Colors.white,

        borderRadius:
            BorderRadius.circular(18),

        boxShadow: [
          BoxShadow(
            color:
                Colors.black.withOpacity(0.05),

            blurRadius: 10,

            offset:
                const Offset(0, 4),
          ),
        ],
      ),

      child:
          Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [
          Text(
            title,

            style:
                TextStyle(
              color:
                  warnaUtama,

              fontSize: 17,

              fontWeight:
                  FontWeight.bold,
            ),
          ),

          const SizedBox(
            height: 13,
          ),

          child,
        ],
      ),
    );
  }

  // =====================================================
  // INFO
  // =====================================================

  Widget _info(
    String label,
    String value,
  ) {
    return Padding(
      padding:
          const EdgeInsets.only(
        bottom: 10,
      ),

      child:
          Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [
          SizedBox(
            width: 110,

            child:
                Text(
              label,

              style:
                  const TextStyle(
                fontWeight:
                    FontWeight.bold,

                fontSize: 13,
              ),
            ),
          ),

          const Text(': '),

          Expanded(
            child:
                Text(
              value,

              style:
                  const TextStyle(
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // =====================================================
  // HOBI
  // =====================================================

  Widget _hobi(
      String text) {
    return Container(
      padding:
          const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 9,
      ),

      decoration:
          BoxDecoration(
        color:
            warnaUtama.withOpacity(
          0.1,
        ),

        borderRadius:
            BorderRadius.circular(
          25,
        ),
      ),

      child:
          Text(
        text,

        style:
            TextStyle(
          color:
              warnaUtama,

          fontSize: 12,

          fontWeight:
              FontWeight.w600,
        ),
      ),
    );
  }

  Color warnaText() {
    return const Color(
      0xff252A40,
    );
  }
}

// =======================================================
// DETAIL PRODUK
// =======================================================

class ProductDetailPage
    extends StatelessWidget {
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
  Widget build(
      BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color(0xffF5F7FF),

      appBar:
          AppBar(
        title:
            const Text(
          'Detail Produk',

          style:
              TextStyle(
            fontWeight:
                FontWeight.bold,
          ),
        ),

        backgroundColor:
            warnaUtama,

        foregroundColor:
            Colors.white,
      ),

      body:
          SingleChildScrollView(
        child:
            Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [
            Container(
              width:
                  double.infinity,

              height:
                  330,

              color:
                  Colors.white,

              child:
                  Image.asset(
                product.imageUrl,

                fit:
                    BoxFit.contain,

                errorBuilder:
                    (
                  context,
                  error,
                  stackTrace,
                ) {
                  return const Center(
                    child:
                        Icon(
                      Icons
                          .image_not_supported_outlined,

                      size: 65,

                      color:
                          Colors.grey,
                    ),
                  );
                },
              ),
            ),

            Padding(
              padding:
                  const EdgeInsets.all(22),

              child:
                  Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [
                  Text(
                    product.category,

                    style:
                        TextStyle(
                      color:
                          warnaUtama,

                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  const SizedBox(
                    height: 8,
                  ),

                  Text(
                    product.name,

                    style:
                        const TextStyle(
                      fontSize: 23,

                      fontWeight:
                          FontWeight.bold,

                      height: 1.3,
                    ),
                  ),

                  const SizedBox(
                    height: 12,
                  ),

                  Text(
                    product.price,

                    style:
                        TextStyle(
                      color:
                          warnaKedua,

                      fontSize: 21,

                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  if (product.rating >
                      0) ...[
                    const SizedBox(
                      height: 12,
                    ),

                    Row(
                      children: [
                        const Icon(
                          Icons.star,

                          color:
                              Colors.amber,
                        ),

                        const SizedBox(
                          width: 5,
                        ),

                        Text(
                          '${product.rating.toStringAsFixed(1)} / 5.0',
                        ),
                      ],
                    ),
                  ],

                  const SizedBox(
                    height: 22,
                  ),

                  const Divider(),

                  const SizedBox(
                    height: 18,
                  ),

                  const Text(
                    'Deskripsi Produk',

                    style:
                        TextStyle(
                      fontSize: 19,

                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  const SizedBox(
                    height: 10,
                  ),

                  Text(
                    product.description,

                    style:
                        const TextStyle(
                      fontSize: 14,

                      height: 1.7,
                    ),
                  ),

                  const SizedBox(
                    height: 25,
                  ),

                  SizedBox(
                    width:
                        double.infinity,

                    height:
                        50,

                    child:
                        ElevatedButton.icon(
                      onPressed: () {
                        onAddToCart();

                        Navigator.pop(
                            context);
                      },

                      icon:
                          const Icon(
                        Icons
                            .shopping_cart_outlined,
                      ),

                      label:
                          const Text(
                        'Tambah ke Keranjang',

                        style:
                            TextStyle(
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),

                      style:
                          ElevatedButton.styleFrom(
                        backgroundColor:
                            warnaUtama,

                        foregroundColor:
                            Colors.white,

                        shape:
                            RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(
                            14,
                          ),
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

class CartPage
    extends StatefulWidget {
  final List<Product> cartProducts;

  final Color warnaUtama;
  final Color warnaKedua;

  final VoidCallback onCartChanged;

  const CartPage({
    super.key,

    required this.cartProducts,

    required this.warnaUtama,

    required this.warnaKedua,

    required this.onCartChanged,
  });

  @override
  State<CartPage> createState() =>
      _CartPageState();
}

class _CartPageState
    extends State<CartPage> {
  final Map<Product, int>
      jumlahProduk = {};

  @override
  void initState() {
    super.initState();

    for (final product
        in widget.cartProducts) {
      jumlahProduk[product] =
          (jumlahProduk[product] ?? 0) +
              1;
    }
  }

  // =====================================================
  // KONVERSI HARGA
  // =====================================================

  double hargaProduk(
      Product product) {
    String harga =
        product.price
            .replaceAll('Rp', '')
            .replaceAll('.', '')
            .replaceAll(',', '')
            .trim();

    return double.tryParse(harga) ?? 0;
  }

  String formatRupiah(
      double angka) {
    final value =
        angka.toInt().toString();

    final buffer =
        StringBuffer();

    for (int i = 0;
        i < value.length;
        i++) {
      if (i > 0 &&
          (value.length - i) % 3 ==
              0) {
        buffer.write('.');
      }

      buffer.write(value[i]);
    }

    return 'Rp ${buffer.toString()}';
  }

  double get total {
    double hasil = 0;

    jumlahProduk.forEach(
      (product, jumlah) {
        hasil +=
            hargaProduk(product) *
                jumlah;
      },
    );

    return hasil;
  }

  int get totalBarang {
    int hasil = 0;

    jumlahProduk.forEach(
      (product, jumlah) {
        hasil += jumlah;
      },
    );

    return hasil;
  }

  // =====================================================
  // CHECKOUT
  // =====================================================

  void checkout() {
    if (jumlahProduk.isEmpty) {
      return;
    }

    showDialog(
      context: context,

      builder:
          (context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(20),
          ),

          title:
              const Text(
            'Konfirmasi Checkout',
          ),

          content:
              Column(
            mainAxisSize:
                MainAxisSize.min,

            crossAxisAlignment:
                CrossAxisAlignment.start,

            children: [
              Text(
                'Jumlah barang: $totalBarang',
              ),

              const SizedBox(
                height: 10,
              ),

              const Text(
                'Total pembayaran:',
              ),

              const SizedBox(
                height: 5,
              ),

              Text(
                formatRupiah(total),

                style:
                    TextStyle(
                  color:
                      widget.warnaUtama,

                  fontSize: 20,

                  fontWeight:
                      FontWeight.bold,
                ),
              ),
            ],
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(
                    context);
              },

              child:
                  const Text(
                'Batal',
              ),
            ),

            ElevatedButton(
              onPressed: () {
                Navigator.pop(
                    context);

                setState(() {
                  jumlahProduk.clear();
                  widget.cartProducts.clear();
                });

                widget.onCartChanged();

                ScaffoldMessenger.of(
                        context)
                    .showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Checkout berhasil! 🎉',
                    ),
                  ),
                );
              },

              style:
                  ElevatedButton.styleFrom(
                backgroundColor:
                    widget.warnaUtama,

                foregroundColor:
                    Colors.white,
              ),

              child:
                  const Text(
                'Checkout',
              ),
            ),
          ],
        );
      },
    );
  }

  // =====================================================
  // BUILD CART
  // =====================================================

  @override
  Widget build(
      BuildContext context) {
    final daftarProduk =
        jumlahProduk.keys.toList();

    return Scaffold(
      backgroundColor:
          const Color(0xffF6F7FB),

      appBar:
          AppBar(
        title:
            const Text(
          'Keranjang Saya 🛒',
        ),

        backgroundColor:
            widget.warnaUtama,

        foregroundColor:
            Colors.white,
      ),

      body:
          jumlahProduk.isEmpty
              ? Center(
                  child:
                      Column(
                    mainAxisAlignment:
                        MainAxisAlignment
                            .center,

                    children: [
                      Icon(
                        Icons
                            .shopping_cart_outlined,

                        size: 80,

                        color:
                            widget.warnaUtama
                                .withOpacity(
                          0.35,
                        ),
                      ),

                      const SizedBox(
                        height: 15,
                      ),

                      const Text(
                        'Keranjang masih kosong',

                        style:
                            TextStyle(
                          fontSize: 18,

                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),

                      const SizedBox(
                        height: 6,
                      ),

                      const Text(
                        'Yuk pilih tas favoritmu!',

                        style:
                            TextStyle(
                          color:
                              Colors.grey,
                        ),
                      ),
                    ],
                  ),
                )
              : Column(
                  children: [
                    Expanded(
                      child:
                          ListView.builder(
                        padding:
                            const EdgeInsets.all(
                          15,
                        ),

                        itemCount:
                            daftarProduk
                                .length,

                        itemBuilder:
                            (context, index) {
                          final product =
                              daftarProduk[
                                  index];

                          final jumlah =
                              jumlahProduk[
                                      product] ??
                                  1;

                          return _itemKeranjang(
                            product,
                            jumlah,
                          );
                        },
                      ),
                    ),

                    _bagianCheckout(),
                  ],
                ),
    );
  }

  // =====================================================
  // ITEM KERANJANG
  // =====================================================

  Widget _itemKeranjang(
    Product product,
    int jumlah,
  ) {
    return Container(
      margin:
          const EdgeInsets.only(
        bottom: 12,
      ),

      padding:
          const EdgeInsets.all(10),

      decoration:
          BoxDecoration(
        color:
            Colors.white,

        borderRadius:
            BorderRadius.circular(18),

        boxShadow: [
          BoxShadow(
            color:
                Colors.black.withOpacity(
              0.05,
            ),

            blurRadius: 8,
          ),
        ],
      ),

      child:
          Row(
        children: [
          Container(
            width: 75,
            height: 75,

            decoration:
                BoxDecoration(
              color:
                  const Color(0xffF5F7FF),

              borderRadius:
                  BorderRadius.circular(
                14,
              ),
            ),

            child:
                Padding(
              padding:
                  const EdgeInsets.all(
                7,
              ),

              child:
                  Image.asset(
                product.imageUrl,

                fit:
                    BoxFit.contain,
              ),
            ),
          ),

          const SizedBox(
            width: 11,
          ),

          Expanded(
            child:
                Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [
                Text(
                  product.name,

                  maxLines: 2,

                  overflow:
                      TextOverflow.ellipsis,

                  style:
                      const TextStyle(
                    fontWeight:
                        FontWeight.bold,

                    fontSize: 13,
                  ),
                ),

                const SizedBox(
                  height: 4,
                ),

                Text(
                  product.price,

                  style:
                      TextStyle(
                    color:
                        widget.warnaUtama,

                    fontWeight:
                        FontWeight.bold,
                  ),
                ),

                const SizedBox(
                  height: 7,
                ),

                Row(
                  children: [
                    _tombolJumlah(
                      Icons.remove,
                      () {
                        setState(() {
                          if (jumlah > 1) {
                            jumlahProduk[
                                    product] =
                                jumlah - 1;
                          } else {
                            jumlahProduk
                                .remove(
                              product,
                            );
                          }
                        });
                      },
                    ),

                    Padding(
                      padding:
                          const EdgeInsets
                              .symmetric(
                        horizontal: 11,
                      ),

                      child:
                          Text(
                        '$jumlah',

                        style:
                            const TextStyle(
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),
                    ),

                    _tombolJumlah(
                      Icons.add,
                      () {
                        setState(() {
                          jumlahProduk[
                                  product] =
                              jumlah + 1;
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),

          IconButton(
            onPressed: () {
              setState(() {
                jumlahProduk
                    .remove(product);
              });
            },

            icon:
                const Icon(
              Icons.delete_outline,

              color:
                  Colors.red,
            ),
          ),
        ],
      ),
    );
  }

  // =====================================================
  // TOMBOL JUMLAH
  // =====================================================

  Widget _tombolJumlah(
    IconData icon,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,

      borderRadius:
          BorderRadius.circular(8),

      child:
          Container(
        width: 28,
        height: 28,

        decoration:
            BoxDecoration(
          color:
              widget.warnaUtama
                  .withOpacity(0.1),

          borderRadius:
              BorderRadius.circular(8),
        ),

        child:
            Icon(
          icon,

          size: 16,

          color:
              widget.warnaUtama,
        ),
      ),
    );
  }

  // =====================================================
  // CHECKOUT BAGIAN BAWAH
  // =====================================================

  Widget _bagianCheckout() {
    return Container(
      padding:
          const EdgeInsets.fromLTRB(
        20,
        14,
        20,
        20,
      ),

      decoration:
          const BoxDecoration(
        color:
            Colors.white,

        borderRadius:
            BorderRadius.vertical(
          top:
              Radius.circular(25),
        ),
      ),

      child:
          Column(
        children: [
          Row(
            mainAxisAlignment:
                MainAxisAlignment
                    .spaceBetween,

            children: [
              const Text(
                'Total Pembayaran',

                style:
                    TextStyle(
                  color:
                      Colors.grey,

                  fontSize: 13,
                ),
              ),

              Text(
                formatRupiah(total),

                style:
                    TextStyle(
                  color:
                      widget.warnaUtama,

                  fontSize: 20,

                  fontWeight:
                      FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(
            height: 12,
          ),

          SizedBox(
            width:
                double.infinity,

            height:
                50,

            child:
                ElevatedButton.icon(
              onPressed:
                  checkout,

              icon:
                  const Icon(
                Icons.shopping_bag,
              ),

              label:
                  const Text(
                'CHECKOUT SEKARANG',

                style:
                    TextStyle(
                  fontWeight:
                      FontWeight.bold,
                ),
              ),

              style:
                  ElevatedButton.styleFrom(
                backgroundColor:
                    widget.warnaUtama,

                foregroundColor:
                    Colors.white,

                shape:
                    RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(
                    15,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}