import 'package:mocktail/mocktail.dart';
import 'package:open_meteo_api/open_meteo_api.dart' as open_meteo_api;
import 'package:test/test.dart';
import 'package:weather_repository/weather_repository.dart';

class MockOpenMeteoApiClient extends Mock
    implements open_meteo_api.OpenMeteoApiClient {}

class MockLocation extends Mock implements open_meteo_api.Location {}

class MockWeather extends Mock implements open_meteo_api.Weather {}

void main() {
  group('WeatherRepository', () {
    late open_meteo_api.OpenMeteoApiClient weatherApiClient;
    late WeatherRepository weatherRepository;

    setUp(() {
      weatherApiClient = MockOpenMeteoApiClient();
      weatherRepository = WeatherRepository(
        weatherApiClient: weatherApiClient,
      );
    });

    group('constructor', () {
      test('instantiates internal weather api client when not injected', () {
        expect(WeatherRepository(), isNotNull);
      });
    });

    group('getWeather', () {
      const city = 'chicago';
      const latitude = 41.85003;
      const longitude = -87.65005;

      test('calls locationSearch with correct city', () async {
        try {
          await weatherRepository.getWeather(city);
        } catch (_) {}

        verify(() => weatherApiClient.locationSearch(city)).called(1);
      });

      test('throws when locationSearch fails', () async {
        final exception = Exception('oops');
        when(() => weatherApiClient.locationSearch(any())).thenThrow(exception);
        expect(
          () async => weatherRepository.getWeather(city),
          throwsA(exception),
        );
      });

      test('calls getWeather with correct latitude/longitude', () async {
        final location = MockLocation();
        when(() => location.latitude).thenReturn(latitude);
        when(() => location.longitude).thenReturn(longitude);
        when(() => weatherApiClient.locationSearch(any())).thenAnswer(
          (_) async => location,
        );
        try {
          await weatherRepository.getWeather(city);
        } catch (_) {}
        verify(
          () => weatherApiClient.getWeather(
            latitude: latitude,
            longitude: longitude,
          ),
        ).called(1);
      });

      test('throws when getWeather fails', () async {
        // Given
        final exception = Exception('oops');
        final location = MockLocation();

        // When
        when(() => location.latitude).thenReturn(latitude);
        when(() => location.longitude).thenReturn(longitude);
        when(() => weatherApiClient.locationSearch(any())).thenAnswer(
          (_) async => location,
        );
        when(
          () => weatherApiClient.getWeather(
            latitude: any(named: 'latitude'),
            longitude: any(named: 'longitude'),
          ),
        ).thenThrow(exception);

        // Then
        expect(
          () async => weatherRepository.getWeather(city),
          throwsA(exception),
        );
      });

      test('returns correct weather on success (clear)', () async {
        // Given
        final location = MockLocation();
        final weather = MockWeather();

        // When
        when(() => location.name).thenReturn(city);
        when(() => location.latitude).thenReturn(latitude);
        when(() => location.longitude).thenReturn(longitude);
        when(() => weather.temperature).thenReturn(42.42);
        when(() => weather.weatherCode).thenReturn(0);
        when(() => weatherApiClient.locationSearch(any())).thenAnswer(
          (_) async => location,
        );
        when(
          () => weatherApiClient.getWeather(
            latitude: any(named: 'latitude'),
            longitude: any(named: 'longitude'),
          ),
        ).thenAnswer((_) async => weather);

        // Then
        final actual = await weatherRepository.getWeather(city);
        expect(
          actual,
          Weather(
            temperature: 42.42,
            location: city,
            condition: WeatherCondition.clear,
          ),
        );
      });

      test('returns correct weather on success (cloudy)', () async {
        // Given
        final location = MockLocation();
        final weather = MockWeather();

        // When
        when(() => location.name).thenReturn(city);
        when(() => location.latitude).thenReturn(latitude);
        when(() => location.longitude).thenReturn(longitude);
        when(() => weather.temperature).thenReturn(42.42);
        when(() => weather.weatherCode).thenReturn(1);
        when(() => weatherApiClient.locationSearch(any())).thenAnswer(
          (_) async => location,
        );
        when(
          () => weatherApiClient.getWeather(
            latitude: any(named: 'latitude'),
            longitude: any(named: 'longitude'),
          ),
        ).thenAnswer((_) async => weather);

        // Then
        final actual = await weatherRepository.getWeather(city);
        expect(
          actual,
          Weather(
            temperature: 42.42,
            location: city,
            condition: WeatherCondition.cloudy,
          ),
        );
      });

      test('returns correct weather on success (rainy)', () async {
        // Given
        final location = MockLocation();
        final weather = MockWeather();

        // When
        when(() => location.name).thenReturn(city);
        when(() => location.latitude).thenReturn(latitude);
        when(() => location.longitude).thenReturn(longitude);
        when(() => weather.temperature).thenReturn(42.42);
        when(() => weather.weatherCode).thenReturn(51);
        when(() => weatherApiClient.locationSearch(any())).thenAnswer(
          (_) async => location,
        );
        when(
          () => weatherApiClient.getWeather(
            latitude: any(named: 'latitude'),
            longitude: any(named: 'longitude'),
          ),
        ).thenAnswer((_) async => weather);

        // Then
        final actual = await weatherRepository.getWeather(city);
        expect(
          actual,
          Weather(
            temperature: 42.42,
            location: city,
            condition: WeatherCondition.rainy,
          ),
        );
      });

      test('returns correct weather on success (snowy)', () async {
        // Given
        final location = MockLocation();
        final weather = MockWeather();

        // When
        when(() => location.name).thenReturn(city);
        when(() => location.latitude).thenReturn(latitude);
        when(() => location.longitude).thenReturn(longitude);
        when(() => weather.temperature).thenReturn(42.42);
        when(() => weather.weatherCode).thenReturn(71);
        when(() => weatherApiClient.locationSearch(any())).thenAnswer(
          (_) async => location,
        );
        when(
          () => weatherApiClient.getWeather(
            latitude: any(named: 'latitude'),
            longitude: any(named: 'longitude'),
          ),
        ).thenAnswer((_) async => weather);

        // Then
        final actual = await weatherRepository.getWeather(city);
        expect(
          actual,
          Weather(
            temperature: 42.42,
            location: city,
            condition: WeatherCondition.snowy,
          ),
        );
      });

      test('returns correct weather on success (unknown)', () async {
        // Given
        final location = MockLocation();
        final weather = MockWeather();

        // When
        when(() => location.name).thenReturn(city);
        when(() => location.latitude).thenReturn(latitude);
        when(() => location.longitude).thenReturn(longitude);
        when(() => weather.temperature).thenReturn(42.42);
        when(() => weather.weatherCode).thenReturn(-1);
        when(() => weatherApiClient.locationSearch(any())).thenAnswer(
          (_) async => location,
        );
        when(
          () => weatherApiClient.getWeather(
            latitude: any(named: 'latitude'),
            longitude: any(named: 'longitude'),
          ),
        ).thenAnswer((_) async => weather);

        // Then
        final actual = await weatherRepository.getWeather(city);
        expect(
          actual,
          Weather(
            temperature: 42.42,
            location: city,
            condition: WeatherCondition.unknown,
          ),
        );
      });
    });
  });
}
