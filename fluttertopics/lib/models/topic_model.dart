class TopicModel {
  final String title;
  final String description;
  final String category;
  final String? subcategory; // optional
  final String date;
  final String? demoScreen; // optional, dynamic demo screen reference

  TopicModel({
    required this.title,
    required this.description,
    required this.category,
    this.subcategory,
    required this.date,
    this.demoScreen,
  });

  // JSON se parse karne ke liye factory constructor
  factory TopicModel.fromJson(Map<String, dynamic> json) {
    return TopicModel(
      title: json['title'] as String,
      description: json['description'] as String,
      category: json['category'] as String,
      subcategory: json['subcategory'] != null ? json['subcategory'] as String : null,
      date: json['date'] as String,
      demoScreen: json['demoScreen'] != null ? json['demoScreen'] as String : null,
    );
  }

  // JSON me convert karne ke liye method
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'category': category,
      if (subcategory != null) 'subcategory': subcategory,
      'date': date,
      if (demoScreen != null) 'demoScreen': demoScreen,
    };
  }
}
