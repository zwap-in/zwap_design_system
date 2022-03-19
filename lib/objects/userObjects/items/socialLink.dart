/// The data model about any social link
class SocialLink {
  /// The social url for this custom link
  final String socialUrl;

  /// Custom description for this social
  final String socialDescription;

  SocialLink({required this.socialUrl, required this.socialDescription});

  factory SocialLink.fromJson(Map<String, dynamic> json) {
    return SocialLink(
        socialUrl: json['social_link_url'],
        socialDescription: json['social_link_description'] ?? ""
    );
  }

  @override
  operator ==(Object obj) {
    return obj is SocialLink && obj.socialDescription == socialDescription && obj.socialUrl == socialUrl;
  }

  @override
  int get hashCode => socialDescription.hashCode ^ socialUrl.hashCode;
}