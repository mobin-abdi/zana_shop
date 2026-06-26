class Category {
  final int id;
  final String name;
  final String slug;

  Category.fromJson(Map<String, dynamic> json)
    : id = json['id'] ?? 0 ,
      name = json['name'] ?? 'unknown',
      slug = json['slug'] ?? 'unknown';
}
