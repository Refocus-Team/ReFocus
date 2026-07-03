import 'dart:ui' as ui;
import 'package:flutter/material.dart';

class ChartPoint {
  final String label;
  final double value;

  ChartPoint(this.label, this.value);
}

class CustomLineChart extends StatelessWidget {
  final List<ChartPoint> data;
  final double height;

  const CustomLineChart({
    super.key,
    required this.data,
    this.height = 130,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SizedBox(
          width: constraints.maxWidth,
          height: height,
          child: CustomPaint(
            painter: _LineChartPainter(data),
          ),
        );
      },
    );
  }
}

class _LineChartPainter extends CustomPainter {
  final List<ChartPoint> data;

  _LineChartPainter(this.data);

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final double padL = 20.0;
    final double padR = 20.0;
    final double padT = 15.0;
    final double padB = 25.0;

    final double chartW = size.width - padL - padR;
    final double chartH = size.height - padT - padB;

    final List<double> yValues = data.map((d) => d.value).toList();
    final double minY = yValues.reduce((a, b) => a < b ? a : b);
    final double maxY = yValues.reduce((a, b) => a > b ? a : b);
    final double range = (maxY - minY == 0) ? 1.0 : (maxY - minY);

    final List<Offset> points = [];
    for (int i = 0; i < data.length; i++) {
      final double x = padL + (i / (data.length - 1)) * chartW;
      // Scale between 10% and 90% of the chart height to prevent clipping
      final double normalizedY = (data[i].value - minY) / range;
      final double y = padT + chartH - (normalizedY * chartH * 0.8 + chartH * 0.1);
      points.add(Offset(x, y));
    }

    // Paint for background grid lines (optional, let's draw a light bottom axis)
    final Paint axisPaint = Paint()
      ..color = Colors.grey.withOpacity(0.15)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;
    canvas.drawLine(
      Offset(padL, padT + chartH),
      Offset(padL + chartW, padT + chartH),
      axisPaint,
    );

    // Build the smooth line path using cubic bezier curves
    final Path linePath = Path();
    linePath.moveTo(points[0].dx, points[0].dy);

    for (int i = 0; i < points.length - 1; i++) {
      final Offset p0 = points[i];
      final Offset p1 = points[i + 1];
      final double controlX1 = p0.dx + (p1.dx - p0.dx) / 2.0;
      final double controlY1 = p0.dy;
      final double controlX2 = p0.dx + (p1.dx - p0.dx) / 2.0;
      final double controlY2 = p1.dy;

      linePath.cubicTo(controlX1, controlY1, controlX2, controlY2, p1.dx, p1.dy);
    }

    // Paint for the stroke line
    final Paint strokePaint = Paint()
      ..color = const Color(0xFF38BDF8)
      ..strokeWidth = 3.0
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;

    // Build fill path
    final Path fillPath = Path.from(linePath);
    fillPath.lineTo(points.last.dx, padT + chartH);
    fillPath.lineTo(points.first.dx, padT + chartH);
    fillPath.close();

    // Paint for the gradient fill below the line
    final Paint fillPaint = Paint()
      ..shader = ui.Gradient.linear(
        Offset(size.width / 2, padT),
        Offset(size.width / 2, padT + chartH),
        [
          const Color(0xFF38BDF8).withOpacity(0.35),
          const Color(0xFF38BDF8).withOpacity(0.0),
        ],
      )
      ..style = PaintingStyle.fill;

    // Draw the gradient area
    canvas.drawPath(fillPath, fillPaint);
    // Draw the main line stroke
    canvas.drawPath(linePath, strokePaint);

    // Draw points & labels
    final Paint dotStrokePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final Paint dotFillPaint = Paint()
      ..color = const Color(0xFF38BDF8)
      ..style = PaintingStyle.fill;

    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );

    for (int i = 0; i < points.length; i++) {
      final Offset p = points[i];

      // Draw outer point (shadow effect)
      canvas.drawCircle(p, 5.5, Paint()..color = const Color(0xFF38BDF8).withOpacity(0.2));
      // Draw inner point
      canvas.drawCircle(p, 4.0, dotFillPaint);
      canvas.drawCircle(p, 2.0, dotStrokePaint);

      // Draw X-axis text label
      textPainter.text = TextSpan(
        text: data[i].label,
        style: const TextStyle(
          color: Colors.grey,
          fontSize: 9,
          fontWeight: FontWeight.bold,
        ),
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(p.dx - textPainter.width / 2, padT + chartH + 8),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
