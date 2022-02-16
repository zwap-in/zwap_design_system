import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Data model about the page results from any paginated API
class PageData<T> {
  /// The list of data returned inside this page
  List<T> data;

  /// The status code results for this page
  int count;

  /// Error message in case of error
  String next;

  /// Has a next page?
  String previous;

  PageData({required this.data, required this.count, required this.next, required this.previous});

  factory PageData.empty() => PageData(count: 0, data: [], next: '', previous: '');

  factory PageData.fromJson(Map<String, dynamic> json, T callBack(Map<String, dynamic> json)) {
    return PageData(
        data: List<T>.generate(json['results'].length, ((element) => callBack(json['results'][element]))),
        count: json['count'] ?? 0,
        next: json['next'] ?? "",
        previous: json['previous'] ?? "");
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PageData<T> && listEquals(other.data, data) && other.count == count && other.next == next && other.previous == previous;
  }

  @override
  int get hashCode {
    return data.hashCode ^ count.hashCode ^ next.hashCode ^ previous.hashCode;
  }

  PageData<T> copyWith({
    List<T>? data,
    int? count,
    String? next,
    String? previous,
  }) {
    return PageData<T>(
      data: data ?? this.data,
      count: count ?? this.count,
      next: next ?? this.next,
      previous: previous ?? this.previous,
    );
  }

  @override
  String toString() {
    return 'PageData(data: $data, count: $count, next: $next, previous: $previous)';
  }
}
