import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';
import 'package:zwap_design_system/atoms/atoms.dart';
import 'package:zwap_design_system/extensions/dateTimeExtension.dart';
import 'package:zwap_utils/zwap_utils/type.dart';

class ZwapChartsStory extends StatelessWidget {
  const ZwapChartsStory({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xff000025),
      child: const Padding(
        padding: EdgeInsets.all(48.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _Chart1(),
              SizedBox(height: 24),
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(child: _Chart2()),
                  SizedBox(width: 24),
                  Spacer(flex: 2),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Data1 {
  final DateTime date;
  final int value;

  _Data1(this.date, this.value);
}

class _Chart1 extends StatefulWidget {
  const _Chart1({Key? key}) : super(key: key);

  @override
  State<_Chart1> createState() => _Chart1State();
}

class _Chart1State extends State<_Chart1> {
  int _distance = 7;

  @override
  Widget build(BuildContext context) {
    String _format(DateTime time) {
      return DateFormat('EEE, dd MMM', 'it').format(time).split(' ').map((e) => e.capitalize()).join(' ');
    }

    List<SplineSeries> _gradientize(SplineSeries serie) {
      return [
        serie,
        if (false)
          SplineSeries<_Data1, String>(
            width: serie.width! + 6,
            animationDelay: 125,
            onCreateShader: (det) => RadialGradient(
              colors: [
                serie.color!,
                serie.color!.withOpacity(.1),
              ],
              center: const Alignment(-1, -1),
            ).createShader(det.rect),
            dataSource: serie.dataSource as List<_Data1>,
            xValueMapper: (data, _) => _format(data.date),
            yValueMapper: (data, _) => data.value,
          ),
      ];
    }

    final List<DateTime> _days = List.generate(
      _distance,
      (index) => DateTime.now().subtract(Duration(days: index)).pureDate,
    );

    List<_Data1> _generateData() {
      double _factor = ((1 + Random().nextDouble()) * 2);
      int _count = Random().nextInt(50) * _factor.toInt();
      return _days.map((e) {
        _count += Random().nextInt(10 * _factor.toInt());
        return _Data1(e, _count);
      }).toList();
    }

    return Container(
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: const Color(0xff0D0D30),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              InkWell(
                onTap: () => setState(() => _distance = 7),
                child: ZwapText(
                  text: '7 giorni',
                  zwapTextType: ZwapTextType.bigBodyRegular,
                  textColor: Colors.white.withOpacity(_distance == 7 ? 1 : .5),
                ),
              ),
              const SizedBox(width: 8),
              InkWell(
                onTap: () => setState(() => _distance = 15),
                child: ZwapText(
                  text: '15 giorni',
                  zwapTextType: ZwapTextType.bigBodyRegular,
                  textColor: Colors.white.withOpacity(_distance == 15 ? 1 : .5),
                ),
              ),
              const SizedBox(width: 8),
              InkWell(
                onTap: () => setState(() => _distance = 30),
                child: ZwapText(
                  text: '30 giorni',
                  zwapTextType: ZwapTextType.bigBodyRegular,
                  textColor: Colors.white.withOpacity(_distance == 30 ? 1 : .5),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SfCartesianChart(
            key: UniqueKey(),
            plotAreaBorderWidth: 0,
            primaryXAxis: CategoryAxis(
              labelStyle: ZwapTextType.mediumBodyMedium.copyWith(color: Colors.white.withOpacity(.5)),
              borderColor: Colors.transparent,
              majorGridLines: MajorGridLines(
                width: 2,
                color: const Color(0xff454459).withOpacity(.3),
              ),
              axisLine: AxisLine(color: const Color(0xff454459).withOpacity(.3)),
              majorTickLines: MajorTickLines(color: const Color(0xff454459).withOpacity(.3), size: 28),
            ),
            primaryYAxis: NumericAxis(
              name: 'count',
              labelStyle: ZwapTextType.mediumBodyMedium.copyWith(color: Colors.white.withOpacity(.5)),
              borderColor: Colors.transparent,
              majorGridLines: MajorGridLines(
                dashArray: [8, 8],
                width: 2,
                color: const Color(0xff454459).withOpacity(.3),
              ),
              axisLine: AxisLine(color: Colors.transparent),
              majorTickLines: MajorTickLines(color: Colors.transparent),
            ),
            series: [
              ..._gradientize(
                SplineSeries<_Data1, String>(
                  width: 4,
                  color: ZwapColors.primary700,
                  dataSource: _generateData(),
                  xValueMapper: (data, _) => _format(data.date),
                  yValueMapper: (data, _) => data.value,
                ),
              ),
              ..._gradientize(
                SplineSeries<_Data1, String>(
                  width: 4,
                  color: const Color(0xff99FFA3),
                  dataSource: _generateData(),
                  xValueMapper: (data, _) => _format(data.date),
                  yValueMapper: (data, _) => data.value,
                ),
              ),
              ..._gradientize(
                SplineSeries<_Data1, String>(
                  width: 4,
                  color: ZwapColors.error400,
                  dataSource: _generateData(),
                  xValueMapper: (data, _) => _format(data.date),
                  yValueMapper: (data, _) => data.value,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Chart2 extends StatelessWidget {
  const _Chart2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: const Color(0xff0D0D30),
        borderRadius: BorderRadius.circular(16),
      ),
      child: SfCircularChart(
        series: [
          DoughnutSeries(
            dataSource: const [27, 32, 41],
            xValueMapper: (data, _) => data,
            yValueMapper: (data, _) => data,
            explode: true,
          ),
        ],
        palette: const [Color(0xff64748B), Color(0xffF178B6), Color(0xff7788FA)],
      ),
    );
  }
}
