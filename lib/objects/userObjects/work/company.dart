/// Custom class to handle the company data
class CompanyData{

  /// The name for this company
  final String companyName;

  CompanyData({required this.companyName});

  factory CompanyData.fromJson(Map<String, dynamic> json){
    return CompanyData(
        companyName: json['company_name']
    );
  }

}