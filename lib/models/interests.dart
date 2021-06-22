/// The data about single interest category
class InterestData{

  /// The name of the category
  final String category;

  /// The list of the interests related to this category
  final List<String> interests;

  InterestData({
    required this.category,
    required this.interests
  });

  factory InterestData.fromJson(Map<String, dynamic> json){
    return InterestData(
        category: json['category'],
        interests: json['interests']
    );
  }
}
