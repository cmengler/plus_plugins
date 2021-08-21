import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:package_info_plus_web/package_info_plus_web.dart';
import 'package:http/http.dart' as http;

import 'package_info_plus_web_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  const VERSION_JSON = {
    'appName': 'package_info_example',
    'buildNumber': '1',
    'packageName': 'io.flutter.plugins.packageinfoexample',
    'version': '1.0',
  };

  late PackageInfoPlugin plugin;
  late MockClient client;

  setUp(() {
    client = MockClient();
    plugin = PackageInfoPlugin();
  });

  group(
    'Package Info Web',
    () {
      test(
        'Get correct valaues when response status is 200',
        () async {
          when(client.get(any)).thenAnswer(
            (_) => Future.value(
              http.Response(jsonEncode(VERSION_JSON), 200),
            ),
          );

          final versionMap = await plugin.getAll();

          expect(versionMap.appName, VERSION_JSON['appName']);
          expect(versionMap.buildNumber, VERSION_JSON['buildNumber']);
          expect(versionMap.packageName, isEmpty);
          expect(versionMap.version, VERSION_JSON['version']);
        },
      );
      test(
        'Get empty valaues when response status is not 200',
        () async {
          when(client.get(any)).thenAnswer(
            (_) => Future.value(
              http.Response('', 404),
            ),
          );

          final versionMap = await plugin.getAll();

          expect(versionMap.appName, isEmpty);
          expect(versionMap.buildNumber, isEmpty);
          expect(versionMap.packageName, isEmpty);
          expect(versionMap.version, isEmpty);
        },
      );
    },
  );
}
