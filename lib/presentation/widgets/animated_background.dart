import 'package:flutter/material.dart';

class AnimatedBackground extends StatefulWidget {
  const AnimatedBackground({super.key});

  @override
  State<AnimatedBackground> createState() => _AnimatedBackgroundState();
}

class _AnimatedBackgroundState extends State<AnimatedBackground>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<Alignment>> _alignments;
  late List<Animation<double>> _sizes;
  late List<Color> _colors;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(3, (index) {
      return AnimationController(
        duration: Duration(seconds: 15 + index * 5),
        vsync: this,
      )..repeat(reverse: true);
    });

    _colors = [
      Colors.blue.withOpacity(0.5),
      Colors.purple.withOpacity(0.5),
      Colors.pink.withOpacity(0.5),
    ];

    _alignments = [
      Tween<Alignment>(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).animate(
        CurvedAnimation(parent: _controllers[0], curve: Curves.easeInOut),
      ),
      Tween<Alignment>(
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
      ).animate(
        CurvedAnimation(parent: _controllers[1], curve: Curves.easeInOut),
      ),
      Tween<Alignment>(
        begin: Alignment.center,
        end: Alignment.topCenter,
      ).animate(
        CurvedAnimation(parent: _controllers[2], curve: Curves.easeInOut),
      ),
    ];

    _sizes = [
      Tween<double>(begin: 0.8, end: 1.2).animate(_controllers[0]),
      Tween<double>(begin: 0.7, end: 1.1).animate(_controllers[1]),
      Tween<double>(begin: 0.9, end: 1.3).animate(_controllers[2]),
    ];
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge(_controllers),
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
          ),
          child: Stack(
            children: List.generate(3, (index) {
              return Align(
                alignment: _alignments[index].value,
                child: Transform.scale(
                  scale: _sizes[index].value,
                  child: Container(
                    width: 400,
                    height: 400,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _colors[index],
                    ),
                  ),
                ),
              );
            }),
          ),
        );
      },
    );
  }
}
