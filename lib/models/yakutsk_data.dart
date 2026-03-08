class YakutskData {
  final String ferryStatus;
  final String weatherAlert;
  final List<dynamic> currencies;
  final List<dynamic> flights;
  final List<dynamic> winterRoads;

  YakutskData({
    required this.ferryStatus,
    required this.weatherAlert,
    required this.currencies,
    required this.flights,
    required this.winterRoads,
  });

  factory YakutskData.fromJson(Map<String, dynamic> json) {
    return YakutskData(
      ferryStatus: json['ferryStatus'] ?? "Нет данных",
      weatherAlert: json['weatherAlert'] ?? "Нет данных",
      currencies: json['currencies'] ?? [],
      flights: json['flights'] ?? [],
      winterRoads: json['winterRoads'] ?? [], // 3. Читаем из JSON от Java
    );
  }
}
