import 'dart:math';

import 'package:dio/dio.dart';

import '../../../core/network/dio_client.dart';
import '../../../shared/models/pin.dart';

class HomeRepository {
  HomeRepository({Dio? dio}) : _dio = dio ?? DioClient.instance;

  final Dio _dio;

  // Supplied at run time with:
  // flutter run --dart-define=PEXELS_API_KEY=YOUR_KEY
  static const _apiKey = String.fromEnvironment('PEXELS_API_KEY');

  bool get hasApiKey => _apiKey.trim().isNotEmpty;

  static const _homeTopics = <String>[
    'fashion',
    'travel',
    'cars',
    'food',
    'nature',
    'architecture',
    'technology',
    'art',
  ];

  Future<List<Pin>> getHomeFeed({int page = 1, int perPage = 24}) async {
    if (!hasApiKey) {
      return _demoPins(page);
    }

    // Build a deliberately mixed discovery feed instead of relying on
    // Pexels' curated endpoint, which can be dominated by one topic.
    final topic = _homeTopics[(page - 1) % _homeTopics.length];
    final nextTopic = _homeTopics[page % _homeTopics.length];

    final results = await Future.wait([
      _searchPexels(topic, page: page, perPage: perPage ~/ 2),
      _searchPexels(nextTopic, page: page, perPage: perPage - perPage ~/ 2),
    ]);

    final pins = [...results[0], ...results[1]];
    pins.shuffle(Random(page * 997));
    return pins;
  }

  Future<List<Pin>> search(
    String query, {
    int page = 1,
    int perPage = 24,
  }) async {
    final q = query.trim();
    if (q.isEmpty) return const [];

    if (!hasApiKey) {
      return _demoPins(page, query: q);
    }

    return _searchPexels(q, page: page, perPage: perPage);
  }

  Future<List<Pin>> _searchPexels(
    String query, {
    required int page,
    required int perPage,
  }) async {
    try {
      final response = await _dio.get(
        '/search',
        queryParameters: {
          'query': query,
          'page': page,
          'per_page': perPage,
          'orientation': 'portrait',
        },
        options: Options(
          headers: {'Authorization': _apiKey},
        ),
      );

      final data = Map<String, dynamic>.from(response.data as Map);
      final photos = data['photos'] as List<dynamic>? ?? const [];

      return photos
          .whereType<Map>()
          .map((item) => _fromPexels(Map<String, dynamic>.from(item)))
          .toList();
    } on DioException catch (e) {
      final status = e.response?.statusCode;
      final message = e.response?.data is Map
          ? (e.response?.data['error'] ?? e.message)
          : e.message;
      throw Exception(
        status == 401
            ? 'Pexels API key is invalid or missing.'
            : 'Pexels request failed${status == null ? '' : ' ($status)'}: $message',
      );
    }
  }

  Pin _fromPexels(Map<String, dynamic> json) {
    final src = Map<String, dynamic>.from(
      (json['src'] as Map?) ?? const <String, dynamic>{},
    );
    final photographer = json['photographer'] as String? ?? 'Pexels creator';

    final imageUrl = (src['large2x'] ?? src['large'] ?? src['medium'] ?? src['original'])
        as String?;

    return Pin(
      id: '${json['id']}',
      title: (json['alt'] as String?)?.trim().isNotEmpty == true
          ? json['alt'] as String
          : 'Inspiration',
      description: 'Photo by $photographer on Pexels.',
      imageUrl: imageUrl ?? 'https://images.pexels.com/',
      width: (json['width'] as num?)?.toInt() ?? 800,
      height: (json['height'] as num?)?.toInt() ?? 1200,
      creator: photographer,
      creatorUrl: json['photographer_url'] as String? ?? 'https://www.pexels.com/',
      photoUrl: json['url'] as String? ?? 'https://www.pexels.com/',
      saves: 0,
    );
  }

  List<Pin> _demoPins(int page, {String query = ''}) {
    const urls = [
      'https://images.unsplash.com/photo-1529139574466-a303027c1d8b?w=900',
      'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?w=900',
      'https://images.unsplash.com/photo-1503376780353-7e6692767b70?w=900',
      'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=900',
      'https://images.unsplash.com/photo-1504674900247-0877df9cc836?w=900',
      'https://images.unsplash.com/photo-1501785888041-af3ef285b470?w=900',
      'https://images.unsplash.com/photo-1497366811353-6870744d04b2?w=900',
      'https://images.unsplash.com/photo-1518005020951-eccb494ad742?w=900',
      'https://images.unsplash.com/photo-1516321318423-f06f85e504b3?w=900',
      'https://images.unsplash.com/photo-1541961017774-22349e4a1262?w=900',
    ];

    final labels = [
      'Fashion inspiration',
      'Travel inspiration',
      'Car inspiration',
      'Style inspiration',
      'Food inspiration',
      'Nature inspiration',
      'Workspace inspiration',
      'Architecture inspiration',
      'Technology inspiration',
      'Art inspiration',
    ];

    return List.generate(urls.length, (i) {
      final n = ((page - 1) * urls.length) + i;
      return Pin(
        id: 'demo-$n-${query.toLowerCase()}',
        title: query.isEmpty ? labels[i] : '$query inspiration ${n + 1}',
        description: 'Demo image. Run the app with your Pexels API key for live results.',
        imageUrl: urls[i],
        width: 900,
        height: i.isEven ? 1200 : 1000,
        creator: 'Demo mode',
        creatorUrl: 'https://www.pexels.com/',
        photoUrl: 'https://www.pexels.com/',
        saves: 100 + n * 11,
      );
    });
  }
}
