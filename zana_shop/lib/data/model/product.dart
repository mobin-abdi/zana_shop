class Product {
  final int id;
  final String title;
  final int price;
  final int discountPercent;
  final String category;
  final int finalPrice;
  final String image;
  final String createdAt;
  final String description;

  Product.fromJson(Map<String, dynamic> json)
    : id = json['id'],
      title = json['title'],
      price = json['price'],
      discountPercent = json['discount_percent'],
      category = json['category_name']??"  ",
      finalPrice = json['final_price'],
      image = json['image'] ?? "unknown",
      createdAt = json['created_at']?? "unknown",
      description = json['description'];
}
