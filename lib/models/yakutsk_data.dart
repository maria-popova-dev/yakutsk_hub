class YakutskData {
  final String ferryStatus;
  final String weatherAlert;
  final List<dynamic> currencies;
  final List<dynamic> flights;
  final List<dynamic> winterRoads;
  final String holiday;

  YakutskData({
    required this.ferryStatus,
    required this.weatherAlert,
    required this.currencies,
    required this.flights,
    required this.winterRoads,
    required this.holiday,
  });

  factory YakutskData.fromJson(Map<String, dynamic> json) {
    return YakutskData(
      holiday: json['holiday'] ?? "",
      ferryStatus: json['ferryStatus'] ?? "Нет данных",
      weatherAlert: json['weatherAlert'] ?? "Нет данных",
      currencies: json['currencies'] ?? [],
      flights: json['flights'] ?? [],
      winterRoads: json['winterRoads'] ?? [],
    );
  }
}
