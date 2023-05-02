class ContentUser {
  final int? contentId;
  final int? categoryId;
  final String? title;
  final bool? isactive;
  final String? description;
  final String? contentUrl;
  final String? thumbnailUrl;

  ContentUser({
    this.contentId,
    this.thumbnailUrl,
    this.categoryId,
    this.title,
    this.contentUrl,
    this.description,
    this.isactive,
  });

  factory ContentUser.fromJson(Map<String, dynamic> json) {
    return ContentUser(
      title: json['title'],
      description: json['description'],
      isactive: json['isactive'],
      contentUrl: json['content_url'],
      contentId: json['content_id'],
      categoryId: json['category_id'],
      thumbnailUrl: json['thumbnail_url'],
    );
  }
}
