class DataModel {
  final int id;
  final String title;
  final String description;
  
  DataModel({
    required this.id, 
    required this.title, 
    required this.description
  });
  
  // Factory constructor untuk mengubah JSON menjadi objek DataModel
  factory DataModel.fromJson(Map<String, dynamic> json) {
    return DataModel(
      id: json['id'],
      title: json['title'],
      description: json['body'],
    );
  }
}