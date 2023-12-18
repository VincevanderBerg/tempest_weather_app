import 'package:test/test.dart';
import 'package:weather_repository/src/models/models.dart';

void main() {
  group('Weather', () {
    group('fromJson', () {
      test('returns correct Weather object', () {
        expect(
          Weather.fromJson(<String, dynamic>{
            'location': 'chicago',
            'temperature': 42.42,
            'condition': 'clear',
          }),
          isA<Weather>()
              .having((w) => w.location, 'location', 'chicago')
              .having((w) => w.temperature, 'temperature', 42.42)
              .having((w) => w.condition, 'condition', WeatherCondition.clear),
        );
      });
    });

    group('toJson', () {
      test('returns correct JSON structure', () {
        expect(
          Weather(
            location: 'chicago',
            temperature: 42.42,
            condition: WeatherCondition.clear,
          ).toJson(),
          {
            'location': 'chicago',
            'temperature': 42.42,
            'condition': 'clear',
          },
        );
      });
    });
  });
}
