import 'dart:io';

import 'package:test/test.dart';

import 'fixture_reader.dart';

void main() {
  setUp(() {});

  test('should return json', () async {
    final json =
        FixtureReader.getJsonData('core/fixture/fixture_reader_test.json');

    expect(json, allOf([isNotEmpty]));
  });

  test('should return Map<String, dynamic', () async {
    final data = FixtureReader.getData<Map<String, dynamic>>(
        'core/fixture/fixture_reader_test.json');

    expect(data, allOf([isA<Map<String, dynamic>>()]));
    expect(data['id'], 1);
  });

  test('should return List', () async {
    final data = FixtureReader.getData<List>(
        'core/fixture/fixture_reader_list_test.json');

    expect(data, allOf([isA<List>()]));
    expect(data.isNotEmpty, isTrue);
  });

  test('should return FileSystemException if file is not found', () async {
    var call = FixtureReader.getData;

    expect(() => call('error.json'), throwsA(isA<FileSystemException>()));
  });
}
