import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FreezeEffect extends StatefulWidget {
  const FreezeEffect({Key? key}) : super(key: key);

  @override
  State<FreezeEffect> createState() => _FreezeEffectState();
}

class _FreezeEffectState extends State<FreezeEffect>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<LineSegment> _lines = [];
  final int _lineCount = 6;
  ui.Image? _noiseTexture;
  bool _isTextureLoaded = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);

    _loadNoiseTexture();
  }

  Future<void> _loadNoiseTexture() async {
    final ByteData data = await rootBundle.load('assets/noise_texture.jpg');
    final Uint8List bytes = data.buffer.asUint8List();
    final ui.Codec codec = await ui.instantiateImageCodec(bytes);
    final ui.FrameInfo fi = await codec.getNextFrame();

    setState(() {
      _noiseTexture = fi.image;
      _isTextureLoaded = true;
    });
  }

  void _generateLines(Size size) {
    _lines.clear();
    final random = Random();

    for (int i = 0; i < _lineCount; i++) {
      Offset startPoint;
      Offset endPoint;

      int edge = random.nextInt(4);
      switch (edge) {
        case 0:
          startPoint = Offset(random.nextDouble() * size.width, 0);
          break;
        case 1:
          startPoint = Offset(size.width, random.nextDouble() * size.height);
          break;
        case 2:
          startPoint = Offset(random.nextDouble() * size.width, size.height);
          break;
        default:
          startPoint = Offset(0, random.nextDouble() * size.height);
          break;
      }

      endPoint = Offset(
        size.width * (0.3 + random.nextDouble() * 0.4),
        size.height * (0.3 + random.nextDouble() * 0.4),
      );

      final mainAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(
            0.0,
            0.6 + random.nextDouble() * 0.4,
            curve: Curves.easeOut,
          ),
        ),
      );

      // Add the main line
      _lines.add(
        LineSegment(
          startPoint: startPoint,
          endPoint: endPoint,
          animation: mainAnimation,
          thickness: 2.0 + random.nextDouble() * 1.0,
          glow: 4.0 + random.nextDouble() * 3.0,
        ),
      );

      int branchCount = 2 + random.nextInt(3);
      for (int j = 0; j < branchCount; j++) {
        double t =
            0.3 + random.nextDouble() * 0.6; // Position along the main line
        Offset branchStart = Offset(
          startPoint.dx + (endPoint.dx - startPoint.dx) * t,
          startPoint.dy + (endPoint.dy - startPoint.dy) * t,
        );

        double angle = random.nextDouble() * pi - pi / 2; // -90 to 90 degrees
        double length = size.width * (0.1 + random.nextDouble() * 0.2);

        Offset branchEnd = Offset(
          branchStart.dx + cos(angle) * length,
          branchStart.dy + sin(angle) * length,
        );

        final branchAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
            parent: _controller,
            curve: Interval(
              0.2 + t * 0.3,
              0.7 + random.nextDouble() * 0.3,
              curve: Curves.easeOut,
            ),
          ),
        );

        _lines.add(
          LineSegment(
            startPoint: branchStart,
            endPoint: branchEnd,
            animation: branchAnimation,
            thickness:
                1.0 + random.nextDouble() * 0.5, // Thinner than main lines
            glow: 3.0 + random.nextDouble() * 2.0, // Less glow than main lines
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (_lines.isEmpty) {
          _generateLines(Size(constraints.maxWidth, constraints.maxHeight));
        }

        return Stack(
          children: [
            // Dark textured background
            Container(
              width: constraints.maxWidth,
              height: constraints.maxHeight,
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment(0.1, 0.1),
                  radius: 1.2,
                  colors: [Color(0xFF202530), Color(0xFF101520)],
                ),
              ),
            ),
            // Apply noise texture if loaded
            if (_isTextureLoaded && _noiseTexture != null)
              ShaderMask(
                blendMode: BlendMode.softLight,
                shaderCallback: (Rect bounds) {
                  return ImageShader(
                    _noiseTexture!,
                    TileMode.repeated,
                    TileMode.repeated,
                    Matrix4.identity().storage,
                  );
                },
                child: Container(
                  width: constraints.maxWidth,
                  height: constraints.maxHeight,
                  color: Colors.white.withOpacity(0.1),
                ),
              ),
            // Freeze lines
            AnimatedBuilder(
              animation: _controller,
              builder: (context, _) {
                return CustomPaint(
                  size: Size(constraints.maxWidth, constraints.maxHeight),
                  painter: FrostLinePainter(lines: _lines),
                );
              },
            ),
          ],
        );
      },
    );
  }
}

class LineSegment {
  final Offset startPoint;
  final Offset endPoint;
  final Animation<double> animation;
  final double thickness;
  final double glow;

  LineSegment({
    required this.startPoint,
    required this.endPoint,
    required this.animation,
    required this.thickness,
    required this.glow,
  });
}

class FrostLinePainter extends CustomPainter {
  final List<LineSegment> lines;

  FrostLinePainter({required this.lines});

  @override
  void paint(Canvas canvas, Size size) {
    for (var line in lines) {
      // Only draw if the animation has started
      if (line.animation.value <= 0) continue;

      // Calculate how much of the line to draw based on animation
      Offset currentEnd = Offset(
        line.startPoint.dx +
            (line.endPoint.dx - line.startPoint.dx) * line.animation.value,
        line.startPoint.dy +
            (line.endPoint.dy - line.startPoint.dy) * line.animation.value,
      );

      // Draw outer glow
      final glowPaint =
          Paint()
            ..color = Colors.red.withOpacity(0.4)
            ..strokeWidth = line.thickness + line.glow
            ..style = PaintingStyle.stroke
            ..strokeCap = StrokeCap.round
            ..maskFilter = MaskFilter.blur(BlurStyle.normal, line.glow);

      canvas.drawLine(line.startPoint, currentEnd, glowPaint);

      // Draw bright inner line
      final linePaint =
          Paint()
            ..color = Colors.red.withOpacity(0.9)
            ..strokeWidth = line.thickness
            ..style = PaintingStyle.stroke
            ..strokeCap = StrokeCap.round;

      canvas.drawLine(line.startPoint, currentEnd, linePaint);
    }
  }

  @override
  bool shouldRepaint(covariant FrostLinePainter oldDelegate) => true;
}
