import 'package:flutter_test/flutter_test.dart';
import 'package:markdownnotepad/helpers/bytes_converter.dart';

void main() {
  group('bytes converter tests', () {
    test('bytesToSize should convert bytes to a human-readable size', () {
      expect(BytesConverter.bytesToSize(1024), '1.00 KB');
      expect(BytesConverter.bytesToSize(1048576), '1.00 MB');
      expect(BytesConverter.bytesToSize(1073741824), '1.00 GB');
      expect(BytesConverter.bytesToSize(1099511627776), '1.00 TB');
      expect(BytesConverter.bytesToSize(0), '0 B');
    });

    test('sizeToBytes should convert a human-readable size to bytes', () {
      expect(BytesConverter.sizeToBytes('1.00 KB'), 1024);
      expect(BytesConverter.sizeToBytes('1.00 MB'), 1048576);
      expect(BytesConverter.sizeToBytes('1.00 GB'), 1073741824);
      expect(BytesConverter.sizeToBytes('1.00 TB'), 1099511627776);
      expect(BytesConverter.sizeToBytes('0 B'), 0);
    });
  });
}
