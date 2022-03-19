/// Custom class to handle the city data models
class CityData{

  /// The city name for this data model
  final String cityName;

  CityData({required this.cityName});

  factory CityData.fromJson(Map<String, dynamic> json){
    return CityData(
      cityName: json['city_name'],
    );
  }

}