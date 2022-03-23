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

  factory Membership.fromJson(Map<String, dynamic> json){
    return Membership(pk: json['pk'],
        name: json['membership_name'],
        domain: json['membership_domain'],
        brandImage: json['brand_image']);
  }

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
