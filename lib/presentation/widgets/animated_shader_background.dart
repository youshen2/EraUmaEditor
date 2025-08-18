import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AnimatedShaderBackground extends StatefulWidget {
  const AnimatedShaderBackground({super.key});

  @override
  State<AnimatedShaderBackground> createState() =>
      _AnimatedShaderBackgroundState();
}

class _AnimatedShaderBackgroundState extends State<AnimatedShaderBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  Future<ui.FragmentShader>? _shaderFuture;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();
    _shaderFuture = _loadShader();
  }

  Future<ui.FragmentShader> _loadShader() async {
    final program = await ui.FragmentProgram.fromAsset('shaders/bg_frag.glsl');
    return program.fragmentShader();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ui.FragmentShader>(
      future: _shaderFuture,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return CustomPaint(
                size: MediaQuery.of(context).size,
                painter: ShaderPainter(
                  shader: snapshot.data!,
                  time: _controller.value * 20, // Pass time to shader
                  isDarkMode: Theme.of(context).brightness == Brightness.dark,
                ),
              );
            },
          );
        } else if (snapshot.hasError) {
          return Center(child: Text('Error loading shader: ${snapshot.error}'));
        }
        return Container(color: Theme.of(context).colorScheme.surface);
      },
    );
  }
}

class ShaderPainter extends CustomPainter {
  final ui.FragmentShader shader;
  final double time;
  final bool isDarkMode;

  ShaderPainter(
      {required this.shader, required this.time, required this.isDarkMode});

  @override
  void paint(Canvas canvas, Size size) {
    shader.setFloat(0, size.width);
    shader.setFloat(1, size.height);
    shader.setFloat(2, time);

    shader.setFloat(3, 0.0);
    shader.setFloat(4, 0.0);
    shader.setFloat(5, 1.0);
    shader.setFloat(6, 1.0);

    shader.setFloat(7, 0.0);

    final points = isDarkMode
        ? [0.63, 0.5, 0.88, 0.69, 0.75, 0.8, 0.17, 0.66, 0.81, 0.14, 0.24, 0.72]
        : [0.67, 0.42, 1.0, 0.69, 0.75, 1.0, 0.14, 0.71, 0.95, 0.14, 0.27, 0.8];
    for (int i = 0; i < points.length; i++) {
      shader.setFloat(8 + i, points[i]);
    }

    final colors = isDarkMode
        ? [
            0.0,
            0.31,
            0.58,
            1.0,
            0.53,
            0.29,
            0.15,
            1.0,
            0.46,
            0.06,
            0.27,
            1.0,
            0.16,
            0.12,
            0.45,
            1.0
          ]
        : [
            0.57,
            0.76,
            0.98,
            1.0,
            0.98,
            0.85,
            0.68,
            1.0,
            0.98,
            0.75,
            0.93,
            1.0,
            0.73,
            0.7,
            0.98,
            1.0
          ];
    for (int i = 0; i < colors.length; i++) {
      shader.setFloat(20 + i, colors[i]);
    }

    // Other uniforms
    shader.setFloat(36, 1.0); // uAlphaMulti
    shader.setFloat(37, 1.5); // uNoiseScale
    shader.setFloat(38, 0.1); // uPointOffset
    shader.setFloat(39, 1.0); // uPointRadiusMulti
    shader.setFloat(40, 0.2); // uSaturateOffset
    shader.setFloat(41, isDarkMode ? -0.1 : 0.1); // uLightOffset

    final paint = Paint()..shader = shader;
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
