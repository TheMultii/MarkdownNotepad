import 'dart:math';

class BytesConverter {
  static String bytesToSize(int bytes) {
    if (bytes <= 0) return '0 B';
    const suffixes = ['B', 'KB', 'MB', 'GB', 'TB'];
    var i = (log(bytes) / log(1024)).floor();
    return '${(bytes / pow(1024, i)).toStringAsFixed(2)} ${suffixes[i]}';
  }

  static int sizeToBytes(String size) {
    const suffixes = ['B', 'KB', 'MB', 'GB', 'TB'];
    var i = suffixes.indexOf(size.substring(size.length - 2));
    return (double.parse(size.substring(0, size.length - 2)) * pow(1024, i))
        .toInt();
  }
}
