import 'package:hive/hive.dart';
part 'news_hive.g.dart';

@HiveType(typeId: 0)
class NewsHive {
  @HiveField(0)
  String description;
  @HiveField(1)
  String title;
  @HiveField(2)
  String source;
  @HiveField(3)
  String urlToImage;
  @HiveField(4)
  String publishedAt;

  NewsHive({
    this.description,
    this.title,
    this.source,
    this.publishedAt,
    this.urlToImage,
  });
}
