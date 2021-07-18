import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:researchfin/models/meta_data.dart';
import 'package:researchfin/models/search_data.dart';
import 'package:researchfin/models/time_series_item.dart';

class ApiCallProvider {
  String apiKey = "TIYBCFT2HI5D0Y3Z";

  getCall(String url) async {
    try {
      Map<String, String> headers = {
        "Content-type": "application/json",
      };
      Response response = await http.get(
        Uri.parse(url),
        headers: headers,
      );

      // var result = jsonDecode(response.body);
      print(jsonDecode(response.body));
      return response.body;
    } catch (error, stackTrace) {
      print(error);
      print(stackTrace);
    }
  }

  Future<List<BestMatches>> searchStock(String stringPattern) async {
    try {
      String searchUrl =
          "https://www.alphavantage.co/query?function=SYMBOL_SEARCH&keywords=$stringPattern&apikey=$apiKey";

      List<BestMatches> _bestMatches = [];
      Map apiData = jsonDecode(await getCall(searchUrl));
      apiData["bestMatches"].forEach((element) {
        BestMatches _bestMatch = BestMatches.fromJson(
          element,
        );
        _bestMatches.add(_bestMatch);
      });

      // print(searchData.bestMatches.length);

      return _bestMatches;
    } catch (error, stackTRace) {
      print(error);
      print(stackTRace);
      return [];
    }
  }

  Future<List<dynamic>> getStockDailyData(
      String outputSize, String symbol) async {
    try {
      String searchUrl =
          "https://www.alphavantage.co/query?function=TIME_SERIES_DAILY&symbol=$symbol&outputsize=$outputSize&apikey=$apiKey";
      print(searchUrl);

      List<TimeSeriesItem> _timeSeriesDailyData = [];
      Map apiData = jsonDecode(await getCall(searchUrl));
      apiData["Time Series (Daily)"].forEach((key, value) {
        Map<String, dynamic> singleItem = {
          ...value,
          "date": key,
        };

        TimeSeriesItem singleItem1 = TimeSeriesItem.fromJson(singleItem);
        _timeSeriesDailyData.add(singleItem1);
      });

      CustomMetaData metaData = CustomMetaData.fromJson(apiData["Meta Data"]);

      List allData = [metaData, _timeSeriesDailyData];

      print(allData);
      // print(searchData.bestMatches.length);

      return allData;
    } catch (error, stackTRace) {
      print(error);
      print(stackTRace);
      return [];
    }
  }
}
