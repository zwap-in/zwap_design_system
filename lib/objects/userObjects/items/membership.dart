/// IMPORTING THIRD PARTY PACKAGES
import 'dart:convert';

/// The data model about any membership data
class Membership {
  /// Unique pk of the membership
  final int pk;

  /// The space's name
  final String name;

  /// The space's domain
  final String domain;

  /// The image path for this space's data model
  final String brandImage;

  static Membership zwapMembership = const Membership(
    pk: -1,
    name: 'Zwap',
    domain: '',
    brandImage: '',
  );

  static Membership allMembership = const Membership(
    pk: -2,
    name: 'All', //TODO: traduci -- per ora non presente in app
    domain: '', //TODO: implementa
    brandImage: '',
  );

  const Membership({
    required this.pk,
    required this.name,
    required this.domain,
    required this.brandImage,
  });

  Membership copyWith({
    int? pk,
    String? name,
    String? domain,
    String? brandImage,
  }) {
    return Membership(
      pk: pk ?? this.pk,
      name: name ?? this.name,
      domain: domain ?? this.domain,
      brandImage: brandImage ?? this.brandImage,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'pk': pk,
      'membership_name': name,
      'membership_domain': domain,
      'brand_image': brandImage,
    };
  }

  factory Membership.fromMap(Map<String, dynamic> map) {
    assert(map['pk']?.toInt() != null);

    return Membership(
      pk: map['pk']?.toInt(),
      name: map['membership_name'] ?? '',
      domain: map['membership_domain'] ?? '',
      brandImage: map['brand_image'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Membership.fromJson(String source) => Membership.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Membership(pk: $pk, name: $name, domain: $domain, brandImage: $brandImage)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Membership && other.pk == pk;
  }

  @override
  int get hashCode {
    return pk.hashCode ^ name.hashCode ^ domain.hashCode ^ brandImage.hashCode;
  }
}
