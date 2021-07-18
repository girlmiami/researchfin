class CustomMetaData {
  late final String s1Information;
  late final String s2Symbol;
  late final String s3LastRefreshed;
  late final String s4OutputSize;
  late final String s5TimeZone;

  CustomMetaData(
      {required this.s1Information,
      required this.s2Symbol,
      required this.s3LastRefreshed,
      required this.s4OutputSize,
      required this.s5TimeZone});

  CustomMetaData.fromJson(Map<String, dynamic> json) {
    s1Information = json['1. Information'];
    s2Symbol = json['2. Symbol'];
    s3LastRefreshed = json['3. Last Refreshed'];
    s4OutputSize = json['4. Output Size'];
    s5TimeZone = json['5. Time Zone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['1. Information'] = this.s1Information;
    data['2. Symbol'] = this.s2Symbol;
    data['3. Last Refreshed'] = this.s3LastRefreshed;
    data['4. Output Size'] = this.s4OutputSize;
    data['5. Time Zone'] = this.s5TimeZone;
    return data;
  }
}
