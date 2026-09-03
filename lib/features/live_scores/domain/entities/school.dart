/// Model representing a Senior High School in NSMQ
class School {
  final String id;
  final String name;
  final String shortName; // e.g. "PRESEC", "OWASS", "WEY GEY HEY"
  final String region;    // e.g. "Greater Accra", "Ashanti", "Central"
  final String? crestUrl;
  final int titlesCount; // Number of NSMQ trophies won (e.g. 8 for Presec)

  const School({
    required this.id,
    required this.name,
    required this.shortName,
    required this.region,
    this.crestUrl,
    this.titlesCount = 0,
  });
}
