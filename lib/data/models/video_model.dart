class VideoModel {
  final String id;
  final String key;
  final String name;
  final String site;
  final int size;
  final String type;
  final bool official;
  final String? publishedAt;

  const VideoModel({
    required this.id,
    required this.key,
    required this.name,
    this.site = 'YouTube',
    this.size = 1080,
    this.type = 'Trailer',
    this.official = true,
    this.publishedAt,
  });

  factory VideoModel.fromJson(Map<String, dynamic> json) {
    return VideoModel(
      id: json['id'] as String? ?? '',
      key: json['key'] as String? ?? '',
      name: json['name'] as String? ?? '',
      site: json['site'] as String? ?? 'YouTube',
      size: json['size'] as int? ?? 1080,
      type: json['type'] as String? ?? 'Trailer',
      official: json['official'] as bool? ?? true,
      publishedAt: json['published_at'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'key': key,
      'name': name,
      'site': site,
      'size': size,
      'type': type,
      'official': official,
      'published_at': publishedAt,
    };
  }

  String get youtubeUrl => 'https://www.youtube.com/watch?v=$key';
  String get youtubeThumbnailUrl =>
      'https://img.youtube.com/vi/$key/hqdefault.jpg';
  bool get isYouTube => site.toLowerCase() == 'youtube';
  bool get isTrailer => type.toLowerCase() == 'trailer';
}
