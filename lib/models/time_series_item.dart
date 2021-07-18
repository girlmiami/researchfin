class TimeSeriesItem {
  late final String s1Open;
  late final String s2High;
  late final String s3Low;
  late final String s4Close;
  late final String s5Volume;
  late final String date;

  TimeSeriesItem({
    required this.s1Open,
    required this.s2High,
    required this.s3Low,
    required this.s4Close,
    required this.s5Volume,
    required this.date,
  });

  TimeSeriesItem.fromJson(Map<String, dynamic> json) {
    s1Open = json['1. open'];
    s2High = json['2. high'];
    s3Low = json['3. low'];
    s4Close = json['4. close'];
    s5Volume = json['5. volume'];
    date = json["date"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['1. open'] = this.s1Open;
    data['2. high'] = this.s2High;
    data['3. low'] = this.s3Low;
    data['4. close'] = this.s4Close;
    data['5. volume'] = this.s5Volume;
    data['date'] = this.date;
    return data;
  }
}
