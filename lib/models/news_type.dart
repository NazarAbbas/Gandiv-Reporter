import 'dart:convert';

class NewsType {
  final String? newsType;
  final String? newsTypeHindi;
  final int? newsTypeId;

  NewsType({
    this.newsType,
    this.newsTypeId,
    this.newsTypeHindi,
  });

  factory NewsType.fromRawJson(String str) =>
      NewsType.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory NewsType.fromJson(Map<String, dynamic> json) => NewsType(
        newsType: json["newsType"],
        newsTypeHindi: json["newsTypeHindi"],
        newsTypeId: json["newsTypeId"],
      );

  Map<String, dynamic> toJson() => {
        "newsType": newsType,
        "newsTypeHindi": newsTypeHindi,
        "newsTypeId": newsTypeId,
      };
}
