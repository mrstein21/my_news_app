import 'dart:convert';

List<News> listNewsFromJson(String response) {
  final jsonData = json.decode(response);
  final data = jsonData["articles"];
  return new List<News>.from(data.map((x) => News.fromJson(x)));
}

class News {
  String description;
  String title;
  String source;
  String urlToImage;
  String publishedAt;

  News({
    this.description,
    this.title,
    this.source,
    this.publishedAt,
    this.urlToImage,
  });

  factory News.fromJson(Map<String, dynamic> json) => News(
      title: json["title"],
      description: json["description"],
      publishedAt: json["publishedAt"],
      source: json["source"]["name"],
      urlToImage: json["urlToImage"]);
}
