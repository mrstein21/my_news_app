// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'news_hive.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class NewsHiveAdapter extends TypeAdapter<NewsHive> {
  @override
  final int typeId = 0;

  @override
  NewsHive read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return NewsHive(
      description: fields[0] as String,
      title: fields[1] as String,
      source: fields[2] as String,
      publishedAt: fields[4] as String,
      urlToImage: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, NewsHive obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.description)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.source)
      ..writeByte(3)
      ..write(obj.urlToImage)
      ..writeByte(4)
      ..write(obj.publishedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NewsHiveAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
