class Pin {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final int width;
  final int height;
  final String creator;
  final String creatorUrl;
  final String photoUrl;
  final int saves;
  final bool isSaved;

  const Pin({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.width,
    required this.height,
    required this.creator,
    required this.creatorUrl,
    required this.photoUrl,
    this.saves = 0,
    this.isSaved = false,
  });

  double get aspectRatio => height == 0 ? 1 : width / height;

  Pin copyWith({bool? isSaved, int? saves}) {
    return Pin(
      id: id,
      title: title,
      description: description,
      imageUrl: imageUrl,
      width: width,
      height: height,
      creator: creator,
      creatorUrl: creatorUrl,
      photoUrl: photoUrl,
      saves: saves ?? this.saves,
      isSaved: isSaved ?? this.isSaved,
    );
  }
}
