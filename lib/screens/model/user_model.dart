class User{

  final int? catId;
  final String? catName;
  final bool? isactive;
  final String? description;
  final String? catThumbnail;

  User({this.catId, this.catName, this.catThumbnail,this.description, this.isactive, } );
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
    catName: json['cat_name'],
      description: json['description'],
      isactive: json['isactive'],
      catThumbnail: json['cat_thumbnail'],
      catId: json['cat_id'],
    );
  }
}

