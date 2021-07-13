/// The data about single target
class TargetData{

  /// The pk number of the target
  final int pk;

  /// The name of the target
  final String targetName;

  /// The image of the target
  final String targetImage;

  TargetData({
    required this.pk,
    required this.targetName,
    required this.targetImage
  });

  factory TargetData.fromJson(Map<String, dynamic> json){
    return TargetData(
        pk: json['pk'],
        targetName: json['target_name'],
        targetImage: json['target_image']
    );
  }

  /// Parsing list of maps in a iterable targets
  static List<TargetData> parseTargets(List<Map<String, dynamic>> targetsBody){
    List<TargetData> targets = [];
    targetsBody.forEach((element) {
      targets.add(TargetData.fromJson(element));
    });
    return targets;
  }
}