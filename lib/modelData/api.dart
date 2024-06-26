import 'package:flutter/foundation.dart';

/// Data model about the page results from any paginated API
class PageData<T> {
  /// The list of data returned inside this page
  List<T> data;

  /// The status code results for this page
  int count;

  /// Error message in case of error
  String? next;

  /// Has a next page?
  String? previous;

  PageData({required this.data, required this.count, required this.next, required this.previous});

  int? get nextPage => int.tryParse(next ?? '');
  int? get previousPage => int.tryParse(previous ?? '');

  /// Deduce the current page number from the next and previous page numbers
  /// 
  /// If there is no next or previous page, it will return 1
  /// 
  /// ! If [next] or [previous] are not numbers, it will return 1
  int get decodeCurrentPage {
    if (nextPage == null && previousPage == null) return 1;
    if (nextPage == null && previousPage != null) return previousPage! + 1;
    if (nextPage != null) return nextPage! - 1;
    return 1;
  }

  factory PageData.empty() => PageData(count: 0, data: [], next: null, previous: null);

  factory PageData.fromList(List<T> values, {bool thereAreMore = true}) => PageData(
        count: thereAreMore ? values.length + 1 : values.length,
        data: values,
        next: thereAreMore ? '' : null,
        previous: null,
      );

  factory PageData.fromJson(Map<String, dynamic> json, T callBack(Map<String, dynamic> json)) {
    String? _next;
    String? _previous;

    if (json['next'] is String) _next = json['next'];
    if (json['next'] is int) _next = json['next'] > 0 ? '${json['next']}' : null;
    if (json['next'] is bool) _next = json['next'] ? 'true' : null;

    if (json['previous'] is String) _previous = json['previous'];
    if (json['previous'] is int) _previous = json['previous'] > 0 ? '${json['previous']}' : null;
    if (json['previous'] is bool) _previous = json['previous'] ? 'true' : null;

    return PageData(
      data: List<T>.generate(json['results'].length, ((element) => callBack(json['results'][element]))),
      count: json['count'] ?? 0,
      next: _next,
      previous: _previous,
    );
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
