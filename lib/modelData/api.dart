/// Data model about the page results from any paginated API
class PageData<T>{

  /// The list of data returned inside this page
  List<T> data;

  /// The status code results for this page
  int count;

  /// Error message in case of error
  String next;

  /// Has a next page?
  String previous;

  PageData({
    required this.data,
    required this.count,
    required this.next,
    required this.previous
  });

  factory PageData.fromJson(Map<String, dynamic> json, T callBack(Map<String, dynamic> json)){
    return PageData(
      data: List<T>.generate(json['results'].length, ((element) => callBack(json['results'][element]))),
      count: json['count'] ?? 0,
      next: json['next'] ?? "",
      previous: json['previous'] ?? ""
    );
  }

}