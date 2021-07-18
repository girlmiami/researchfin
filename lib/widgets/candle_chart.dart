import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:painter/painter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:researchfin/controller/searching_provider.dart';
import 'package:researchfin/models/time_series_item.dart';
import 'package:researchfin/models/volume_chart_data.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';
import 'package:screenshot/screenshot.dart';

import 'color_picker_button.dart';

class CandleChart extends StatefulWidget {
  late final List<TimeSeriesItem> chartData;
  late final bool isEditing;

  CandleChart({required this.chartData, required this.isEditing});

  @override
  _CandleChartState createState() => _CandleChartState();
}

class _CandleChartState extends State<CandleChart> {
  double maxValue = 0;
  double minValue = 0;
  double maxVolume = 0;
  double minVolume = 0;
  late ZoomPanBehavior _zoomPanBehavior;

  // late TrackballBehavior _trackballBehavior;
  late TooltipBehavior _tooltipBehavior1;
  late TooltipBehavior _tooltipBehavior2;
  List<VolumeChartData> _volumeChartData = [];
  PainterController _controller = _newController();
  bool _finished = false;
  late Uint8List? _imageFile;

  //Create an instance of ScreenshotController
  ScreenshotController screenshotController = ScreenshotController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _tooltipBehavior1 = TooltipBehavior(
      enable: true,
      decimalPlaces: 1,
    );
    _tooltipBehavior2 = TooltipBehavior(
      enable: true,
      decimalPlaces: 1,
    );
    _zoomPanBehavior = ZoomPanBehavior(
      enablePinching: true,
      zoomMode: ZoomMode.xy,
      enablePanning: true,
    );
    super.initState();
  }

  static PainterController _newController() {
    PainterController controller = new PainterController();
    controller.thickness = 2.0;
    controller.backgroundColor = Colors.transparent;
    controller.drawColor = Colors.yellow;
    return controller;
  }

  @override
  Widget build(BuildContext context) {
    // get all max & min val for Volume & Price Chart
    _volumeChartData = [];
    maxValue = double.parse(
      widget.chartData
          .reduce(
            (curr, next) =>
                double.parse(curr.s2High) > double.parse(next.s2High)
                    ? curr
                    : next,
          )
          .s2High,
    );
    minValue = double.parse(
      widget.chartData
          .reduce(
            (curr, next) => double.parse(curr.s3Low) < double.parse(next.s3Low)
                ? curr
                : next,
          )
          .s4Close,
    );
    maxVolume = double.parse(
      widget.chartData
          .reduce(
            (curr, next) =>
                double.parse(curr.s5Volume) > double.parse(next.s5Volume)
                    ? curr
                    : next,
          )
          .s5Volume,
    );
    minVolume = double.parse(
      widget.chartData
          .reduce(
            (curr, next) =>
                double.parse(curr.s5Volume) < double.parse(next.s5Volume)
                    ? curr
                    : next,
          )
          .s5Volume,
    );

    widget.chartData.forEach((element) {
      _volumeChartData.add(
        VolumeChartData(
          DateTime.parse(element.date),
          double.parse(element.s5Volume),
          double.parse(element.s1Open) < double.parse(element.s4Close)
              ? Colors.green
              : Colors.red,
        ),
      );
    });
    return Column(
      children: [
        Screenshot(
          controller: screenshotController,
          child: Container(
            height: 400,
            width: MediaQuery.of(context).size.width,
            color: Colors.black87,
            child: Stack(
              children: [
                Column(
                  children: [
                    Container(
                      height: 200,
                      width: MediaQuery.of(context).size.width - 50,
                      child: SfCartesianChart(
                        plotAreaBorderColor: Colors.black87,
                        backgroundColor: Colors.black87,
                        zoomPanBehavior: _zoomPanBehavior,
                        // trackballBehavior: _trackballBehavior,
                        tooltipBehavior: _tooltipBehavior1,
                        primaryXAxis: DateTimeAxis(
                          isVisible: false,
                          // name: "mainXAxis",
                          enableAutoIntervalOnZooming: true,
                          majorGridLines: MajorGridLines(
                            color: Colors.black87,
                            width: 1,
                          ),
                          minorGridLines: MinorGridLines(
                            color: Colors.black87,
                            width: 1,
                          ),
                          majorTickLines: MajorTickLines(
                            color: Colors.black87,
                            width: 0,
                          ),
                          minorTickLines: MinorTickLines(
                            color: Colors.black87,
                            width: 0,
                          ),
                        ),
                        axisLabelFormatter:
                            (AxisLabelRenderDetails axisLabelFormatter) {
                          if (axisLabelFormatter.axisName == "mainXAxis") {
                            return ChartAxisLabel(
                              DateFormat('MM/dd').format(
                                DateTime.fromMillisecondsSinceEpoch(
                                  int.parse(
                                      "${axisLabelFormatter.value.toString().split(".")[0]}"),
                                ),
                              ),
                              TextStyle(
                                color: Colors.grey,
                              ),
                            );
                          }
                          return ChartAxisLabel(
                            axisLabelFormatter.text,
                            TextStyle(
                              color: Colors.grey,
                              fontSize: 10,
                            ),
                          );
                        },
                        primaryYAxis: NumericAxis(
                          maximum: maxValue,
                          minimum: minValue - (minValue * 0.02),
                          isVisible: true,
                          opposedPosition: true,
                          majorTickLines: MajorTickLines(
                            color: Colors.white,
                            width: 0,
                          ),
                          minorTickLines: MinorTickLines(
                            color: Colors.white,
                            width: 0,
                          ),
                          majorGridLines: MajorGridLines(
                            color: Colors.grey,
                            width: 1,
                          ),
                          minorGridLines: MinorGridLines(
                            color: Colors.black87,
                            width: 0,
                          ),
                        ),
                        margin: EdgeInsets.all(15),
                        series: <ChartSeries>[
                          // Renders CandleSeries
                          CandleSeries<TimeSeriesItem, DateTime>(
                            borderWidth: 1,
                            animationDuration: 2000,
                            dataSource: widget.chartData,
                            xValueMapper: (TimeSeriesItem sales, _) =>
                                DateTime.parse(sales.date),
                            lowValueMapper: (TimeSeriesItem sales, _) =>
                                double.parse(sales.s3Low),
                            highValueMapper: (TimeSeriesItem sales, _) =>
                                double.parse(sales.s2High),
                            openValueMapper: (TimeSeriesItem sales, _) =>
                                double.parse(sales.s1Open),
                            closeValueMapper: (TimeSeriesItem sales, _) =>
                                double.parse(sales.s4Close),
                            emptyPointSettings: EmptyPointSettings(
                              mode: EmptyPointMode.drop,
                            ),
                            bullColor: Colors.red,
                            bearColor: Colors.green,
                            name: "Price",
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        Container(
                          height: 100,
                          width: (MediaQuery.of(context).size.width - 50) -
                              (MediaQuery.of(context).size.width * 0.095),
                          padding: EdgeInsets.only(
                            left: MediaQuery.of(context).size.width * 0.025,
                            top: 0,
                          ),
                          child: SfCartesianChart(
                            plotAreaBorderColor: Colors.black87,
                            backgroundColor: Colors.black87,
                            zoomPanBehavior: _zoomPanBehavior,
                            // trackballBehavior: _trackballBehavior,
                            tooltipBehavior: _tooltipBehavior2,
                            primaryXAxis: DateTimeAxis(
                              enableAutoIntervalOnZooming: true,
                              majorGridLines: MajorGridLines(
                                color: Colors.black87,
                                width: 1,
                              ),
                              minorGridLines: MinorGridLines(
                                color: Colors.black87,
                                width: 1,
                              ),
                              majorTickLines: MajorTickLines(
                                color: Colors.black87,
                                width: 0,
                              ),
                              minorTickLines: MinorTickLines(
                                color: Colors.black87,
                                width: 5,
                              ),
                            ),
                            axisLabelFormatter:
                                (AxisLabelRenderDetails axisLabelFormatter) {
                              return axisLabelFormatter.axisName == "mainYAxis"
                                  ? ChartAxisLabel(
                                      axisLabelFormatter.value >= minValue
                                          ? axisLabelFormatter.text
                                          : "",
                                      TextStyle(
                                        color: Colors.grey,
                                        fontSize: 10,
                                      ),
                                    )
                                  : ChartAxisLabel(
                                      DateFormat('MM/dd').format(
                                        DateTime.fromMillisecondsSinceEpoch(
                                          int.parse(
                                              "${axisLabelFormatter.value.toString().split(".")[0]}"),
                                        ),
                                      ),
                                      TextStyle(
                                        color: Colors.grey,
                                      ),
                                    );
                            },
                            annotations: <CartesianChartAnnotation>[
                              CartesianChartAnnotation(
                                widget: Container(
                                  child: Text(
                                    '${maxVolume.toString().split(".")[0]}',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 10,
                                    ),
                                  ),
                                ),
                                // horizontalAlignment: ChartAlignment.center,
                                coordinateUnit: CoordinateUnit.point,
                                x: DateTime.parse(widget
                                    .chartData[_volumeChartData.length == 1
                                        ? 0
                                        : _volumeChartData.length == 22
                                            ? 16
                                            : 3]
                                    .date),
                                y: maxVolume * 0.8,
                              ),
                            ],
                            primaryYAxis: NumericAxis(
                              // name: "mainYAxis",
                              maximum: maxVolume,
                              minimum: minVolume,
                              isVisible: false,
                              opposedPosition: true,
                              majorTickLines: MajorTickLines(
                                color: Colors.white,
                                width: 0,
                              ),
                              minorTickLines: MinorTickLines(
                                color: Colors.white,
                                width: 0,
                              ),
                              majorGridLines: MajorGridLines(
                                color: Colors.grey,
                                width: 1,
                              ),
                              minorGridLines: MinorGridLines(
                                color: Colors.black87,
                                width: 0,
                              ),
                            ),
                            series: [
                              ColumnSeries<VolumeChartData, DateTime>(
                                  // width: 1,
                                  // borderWidth: 0.3,
                                  dataSource: _volumeChartData,
                                  xValueMapper: (VolumeChartData data, _) =>
                                      data.x,
                                  yValueMapper: (VolumeChartData data, _) =>
                                      data.y,
                                  pointColorMapper: (VolumeChartData data, _) =>
                                      data.color,
                                  emptyPointSettings: EmptyPointSettings(
                                    mode: EmptyPointMode.drop,
                                  ),
                                  name: "Volume"),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                widget.isEditing
                    ? Painter(_controller)
                    : SizedBox(
                        width: 0,
                        height: 0,
                      ),
              ],
            ),
          ),
        ),
        !widget.isEditing
            ? SizedBox()
            : Material(
                elevation: 5,
                shadowColor: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    color: Colors.black87,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.undo,
                            color: Colors.white,
                          ),
                          tooltip: 'Undo',
                          onPressed: () {
                            if (_controller.isEmpty) {
                              print("jhjhj");
                              showModalBottomSheet(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      new Text('Nothing to undo'));
                            } else {
                              print("ggggggggg");
                              print(_controller.toString());
                              _controller.undo();
                            }
                          },
                        ),
                        IconButton(
                          icon: new Icon(
                            Icons.delete,
                            color: Colors.white,
                          ),
                          tooltip: 'Clear',
                          onPressed: _controller.clear,
                        ),
                        IconButton(
                          icon: new Icon(
                            Icons.save_alt,
                            color: Colors.white,
                          ),
                          onPressed: () async {
                            PictureDetails picture = _controller.finish();
                            _controller.clear();
                            print("hhhhhhhh");
                            await _show(
                              picture,
                              context,
                            );
                          },
                        ),
                        ColorPickerButton(
                          _controller,
                          false,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
      ],
    );
  }

  Future<void> _show(PictureDetails picture, BuildContext context) async {
    try {
      setState(() {
        _finished = true;
      });
      _imageFile = await screenshotController.capture().catchError((onError) {
        print(onError);
      });
      final directory = await getApplicationDocumentsDirectory();
      final File pathOfImage = await File(
              '${directory.path}/annotation_${DateTime.now().toString()}.png')
          .create();
      await pathOfImage.writeAsBytes(_imageFile!).catchError((onError) {
        print(onError);
      });

      Navigator.of(context).push(
        new MaterialPageRoute(
          builder: (BuildContext context) {
            return new Scaffold(
              appBar: new AppBar(
                title: const Text('View your image'),
              ),
              body: new Container(
                alignment: Alignment.center,
                child: Column(
                  children: [
                    Image.file(pathOfImage),
                    ElevatedButton(
                      onPressed: () async {
                        final result =
                            await ImageGallerySaver.saveFile(pathOfImage.path);
                        Provider.of<SearchingProvider>(context, listen: false)
                            .changeSearch(false);
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        "Save Image To Gallery!",
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );
    } catch (error) {
      print(error);
    }
  }
}
