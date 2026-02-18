class SearchResult {
  final String type; // 'category' or 'provider'
  final String id;
  final String name;

  SearchResult({
    required this.type,
    required this.id,
    required this.name,
  });

  factory SearchResult.fromJson(Map<String, dynamic> json) {
    return SearchResult(
      type: json['type'],
      id: json['id'],
      name: json['name'],
    );
  }
}
