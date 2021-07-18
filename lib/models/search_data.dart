class BestMatches {
  late final String s1Symbol;
  late final String s2Name;
  late final String s3Type;
  late final String s4Region;
  late final String s5MarketOpen;
  late final String s6MarketClose;
  late final String s7Timezone;
  late final String s8Currency;
  late final String s9MatchScore;

  BestMatches(
      {required this.s1Symbol,
      required this.s2Name,
      required this.s3Type,
      required this.s4Region,
      required this.s5MarketOpen,
      required this.s6MarketClose,
      required this.s7Timezone,
      required this.s8Currency,
      required this.s9MatchScore});

  BestMatches.fromJson(Map<String, dynamic> json) {
    s1Symbol = json['1. symbol'];
    s2Name = json['2. name'];
    s3Type = json['3. type'];
    s4Region = json['4. region'];
    s5MarketOpen = json['5. marketOpen'];
    s6MarketClose = json['6. marketClose'];
    s7Timezone = json['7. timezone'];
    s8Currency = json['8. currency'];
    s9MatchScore = json['9. matchScore'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['1. symbol'] = this.s1Symbol;
    data['2. name'] = this.s2Name;
    data['3. type'] = this.s3Type;
    data['4. region'] = this.s4Region;
    data['5. marketOpen'] = this.s5MarketOpen;
    data['6. marketClose'] = this.s6MarketClose;
    data['7. timezone'] = this.s7Timezone;
    data['8. currency'] = this.s8Currency;
    data['9. matchScore'] = this.s9MatchScore;
    return data;
  }
}
