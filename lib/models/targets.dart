/// The data about single target
class TargetData{

  /// The name of the target
  final String targetName;

  /// The image of the target
  final String targetImage;

  TargetData({
    required this.targetName,
    required this.targetImage
  });

  factory TargetData.fromJson(Map<String, dynamic> json){
    return TargetData(
        targetName: json['target_name'],
        targetImage: json['target_image']
    );
  }
}