class Product {
  String _name;
  String _category;
  String _price;
  String _imageUrl;
  double _rating;
  String _description;

  Product({
    required String name,
    required String category,
    required String price,
    required String imageUrl,
    required double rating,
    required String description,
  })  : _name = name,
        _category = category,
        _price = price,
        _imageUrl = imageUrl,
        _rating = rating,
        _description = description;

  // GETTER
  String get name => _name;
  String get category => _category;
  String get price => _price;
  String get imageUrl => _imageUrl;
  double get rating => _rating;
  String get description => _description;

  // SETTER
  set name(String value) => _name = value;
  set category(String value) => _category = value;
  set price(String value) => _price = value;
  set imageUrl(String value) => _imageUrl = value;

  set rating(double value) {
    if (value >= 0 && value <= 5) {
      _rating = value;
    }
  }

  set description(String value) => _description = value;

  // FUNCTION
  String informasiProduk() {
    return '$_name - $_category - $_price';
  }

  String ratingProduk() {
    return '⭐ ${_rating.toStringAsFixed(1)}';
  }
}