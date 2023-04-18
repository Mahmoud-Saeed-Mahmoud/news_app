import 'package:hive/hive.dart';

import '../../models/news.dart';

/// A [TypeAdapter] for the [News] class that allows it to be read from and
/// written to a binary file using the [Hive] library.
class NewsAdapter extends TypeAdapter<News> {
  @override
  final int typeId = 0;

  /// Reads a [News] object from the binary [reader].
  ///
  /// This method reads a map from the binary reader and creates a new [News]
  /// object from the map using its `fromJson` constructor.
  @override
  News read(BinaryReader reader) {
    final map = reader.readMap().cast<String, dynamic>();
    return News.fromJson(map);
  }

  /// Writes a [News] object to the binary [writer].
  ///
  /// This method writes the JSON representation of the [News] object to the
  /// binary writer as a map.
  @override
  void write(BinaryWriter writer, News obj) {
    final json = obj.toJson();
    writer.writeMap(json);
  }
}
