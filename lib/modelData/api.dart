/// Base data model with factory method to parse a json response from an API call
abstract class BaseModel{
  BaseModel();

  factory BaseModel.fromJson(Map<String,dynamic> json){
    throw UnimplementedError();
  }
}

/// Data model about the page results from any paginated API
class PageData<T>{

  /// The list of data returned inside this page
  List<T> data;

  /// The status code results for this page
  int statusCode;

  /// Error message in case of error
  String errorMessage;

  /// Has a next page?
  bool hasNext;

  PageData({
    required this.data,
    required this.statusCode,
    required this.errorMessage,
    required this.hasNext
  });

  factory PageData.fromJson(Map<String, dynamic> json){
    return PageData(
      data: List<T>.generate(json['data'].length, ((element) => BaseModel.fromJson(json['data'][element]) as T)),
      statusCode: json['status_code'],
      errorMessage: json['error_message'],
      hasNext: json['has_next']
    );
  }

}