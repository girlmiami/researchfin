import 'package:flutter/material.dart';
import 'package:researchfin/controller/api_call.dart';
import 'package:researchfin/models/meta_data.dart';
import 'package:researchfin/models/time_series_item.dart';
import 'package:researchfin/widgets/candle_chart.dart';

class HomePageBody extends StatefulWidget {
  late final double width;
  late final double height;
  late final String stockSymbol;

  HomePageBody({
    required this.width,
    required this.height,
    required this.stockSymbol,
  });

  @override
  _HomePageBodyState createState() => _HomePageBodyState();
}

class _HomePageBodyState extends State<HomePageBody> {
  ApiCallProvider _apiCallProvider = ApiCallProvider();
  Map selectedMap = {
    "D": true,
    "W": false,
    "M": false,
  };
  List<TimeSeriesItem> variableChartData = [];
  late CustomMetaData metaData;

  bool isEditing = false;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _apiCallProvider.getStockDailyData(
          "compact", "${widget.stockSymbol}"),
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          List allData = snapshot.data;

          if (allData.length == 0) {
            return Center(
              child: Text(
                "Please try after 1 minute !",
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          variableChartData.add(allData[1][0]);
          metaData = allData[0];

          return SingleChildScrollView(
            child: Container(
              height: widget.height-80,
              decoration: BoxDecoration(
                color: Colors.black87,
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Material(
                  elevation: 5,
                  shadowColor: Colors.white,
                  shape: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: BorderSide(
                      color: Colors.black87,
                    ),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black87,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    width: widget.width - 40,
                    height: 500,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Price Trends".toUpperCase(),
                                style: TextStyle(
                                  color: Colors.deepOrange,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Divider(
                          thickness: 1.5,
                          color: Colors.grey,
                        ),
                        StatefulBuilder(
                          builder: (context, chartState) {
                            return Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        selectTimePeriodButton(
                                          "D",
                                          selectedMap["D"],
                                          chartState,
                                          allData[1],
                                        ),
                                        selectTimePeriodButton(
                                          "W",
                                          selectedMap["W"],
                                          chartState,
                                          allData[1],
                                        ),
                                        selectTimePeriodButton(
                                          "M",
                                          selectedMap["M"],
                                          chartState,
                                          allData[1],
                                        ),
                                      ],
                                    ),
                                    editButton(chartState,),
                                  ],
                                ),
                                CandleChart(
                                  chartData: variableChartData,
                                  isEditing: isEditing,
                                ),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }

  selectTimePeriodButton(
      String text, bool isSelected, chartState, List<TimeSeriesItem> fullData) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () {
          if (text == "D") {
            chartState(() {
              variableChartData = fullData.sublist(0, 1);
              selectedMap.forEach(
                (key, value) {
                  if (key == text) {
                    selectedMap[key] = true;
                  } else {
                    selectedMap[key] = false;
                  }
                },
              );
            });
          } else if (text == "M") {
            chartState(() {
              variableChartData = fullData.sublist(0, 22);
              selectedMap.forEach(
                (key, value) {
                  if (key == text) {
                    selectedMap[key] = true;
                  } else {
                    selectedMap[key] = false;
                  }
                },
              );
            });
          } else {
            chartState(() {
              variableChartData = fullData.sublist(0, 5);
              selectedMap.forEach(
                (key, value) {
                  if (key == text) {
                    selectedMap[key] = true;
                  } else {
                    selectedMap[key] = false;
                  }
                },
              );
            });
          }
        },
        child: Material(
          elevation: 5,
          shadowColor: Colors.white,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black87,
            ),
            height: 30,
            width: 30,
            child: Center(
              child: Text(
                "$text",
                style: TextStyle(
                  color: isSelected ? Colors.green : Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  editButton(chartState,) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        elevation: 5,
        shadowColor: Colors.white,
        child: GestureDetector(
          onTap: () {
            chartState((){
              isEditing = !isEditing;
            });
            // Navigator.of(context).push(
            //   MaterialPageRoute(
            //     builder: (context) => ExamplePage(),
            //   ),
            // );
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black87,
            ),
            height: 30,
            width: 30,
            child: Center(
              child: Icon(
                Icons.edit,
                color: isEditing ? Colors.green : Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
