import 'dart:math';
import 'package:emote_this/routes/go_router_config.dart';
import 'package:emote_this/routes/route_value.dart';
import 'package:emote_this/src/core/utils/size_utils.dart';
import 'package:emote_this/ui_kit/app_bar.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import '../bloc/game_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _PuzzleScreenState();
}

class _PuzzleScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GameBloc, GameState>(
      builder: (context, state) {
        if (state is GameLoaded) {
          final score = state.user!.points;
          final allScore = state.riddles.fold<int>(
            0,
            (previousValue, element) => previousValue + element.points,
          );
          final solvedRiddles = state.user!.solvedRiddles;
          final categoryCounts = <String, int>{};
          for (final riddleId in solvedRiddles) {
            final riddle = state.riddles.firstWhere((r) => r.id == riddleId);
            categoryCounts[riddle.category] =
                (categoryCounts[riddle.category] ?? 0) + 1;
          }

          String favoriteCategory = 'Unknown';
          int maxCount = 0;
          categoryCounts.forEach((category, count) {
            if (count > maxCount) {
              maxCount = count;
              favoriteCategory = category;
            }
          });

          return Stack(
            alignment: Alignment.topCenter,
            children: [
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.only(top: 100),
                  child: Column(
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          RoundedPieChart(
                            value: (score / allScore),
                          ),
                          Text(
                            '$score\nSCORE',
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 26, height: 0.95),
                          )
                        ],
                      ),
                      const Gap(75),
                      const Text(
                        'FAVORITE CATEGORY',
                        style: TextStyle(fontSize: 30),
                      ),
                      Container(
                        width: 211,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                                color: const Color(0xFFE2E2E2), width: 2),
                            borderRadius: BorderRadius.circular(22)),
                        child: Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 7),
                            child: Text(
                              favoriteCategory,
                              style: TextStyle(
                                color: Color(0xFFFF48A0),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Spacer(),
                      Material(
                        color: Colors.transparent,
                        child: ElevatedButton(
                          onPressed: () {
                            context.read<GameBloc>().currentAttempts = 0;
                            context.push(
                                '${RouteValue.home.path}/${RouteValue.level.path}',
                                extra: state.user!.currentLevel);
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFFF48A0),
                              elevation: 0,
                              padding: EdgeInsets.zero),
                          child: SizedBox(
                            width: 250,
                            height: 37,
                            child: Center(
                              child: const Text(
                                'Select level',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontFamily: 'Baloo Bhaijaan',
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Gap(7),
                      Material(
                        color: Colors.transparent,
                        child: ElevatedButton(
                          onPressed: () {
                            context.read<GameBloc>().currentAttempts = 0;
                            context.push(
                                "${RouteValue.home.path}/${RouteValue.dayli.path}",
                                extra: int.parse(
                                    "200${Random().nextInt(11) + 1}"));
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF8348FF),
                              elevation: 0,
                              padding: EdgeInsets.zero),
                          child: SizedBox(
                            width: 250,
                            height: 37,
                            child: Center(
                              child: const Text(
                                'Random riddle',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontFamily: 'Baloo Bhaijaan',
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Gap(7),
                      Material(
                        color: Colors.transparent,
                        child: ElevatedButton(
                          onPressed: () {
                            context.read<GameBloc>().currentAttempts = 0;
                            context.push(
                                "${RouteValue.home.path}/${RouteValue.dayli.path}",
                                extra:
                                    int.parse("100${DateTime.now().weekday}"));
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFFF48A0),
                              elevation: 0,
                              padding: EdgeInsets.zero),
                          child: SizedBox(
                            width: 250,
                            height: 37,
                            child: Center(
                              child: const Text(
                                'Everyday riddle',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontFamily: 'Baloo Bhaijaan',
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Gap(7),
                      Material(
                        color: Colors.transparent,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF8348FF),
                              elevation: 0,
                              padding: EdgeInsets.zero),
                          child: SizedBox(
                            width: 250,
                            height: 37,
                            child: Center(
                              child: const Text(
                                'Create riddle',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontFamily: 'Baloo Bhaijaan',
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Gap(62)
                    ],
                  ),
                ),
              ),
              AppBarWidget(
                  tipsCount: state.user!.hints, coinsCount: state.user!.coins)
            ],
          );
        } else {
          return Center(
            child: CupertinoActivityIndicator(),
          );
        }
      },
    );
  }
}

class RoundedPieChart extends StatefulWidget {
  final double value;

  const RoundedPieChart({
    Key? key,
    required this.value,
  }) : super(key: key);

  @override
  _RoundedPieChartState createState() => _RoundedPieChartState();
}

class _RoundedPieChartState extends State<RoundedPieChart>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  late double _previousValue;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _previousValue = widget.value;
    _setupAnimation();
  }

  void _setupAnimation() {
    _animation = Tween<double>(
      begin: _previousValue,
      end: widget.value,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void didUpdateWidget(covariant RoundedPieChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _previousValue = oldWidget.value;
      _setupAnimation();
      _animationController.reset();
      _animationController.forward();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return CustomPaint(
          size: Size(230, 230),
          painter: PieChartPainter(_animation.value, context),
        );
      },
    );
  }
}

class PieChartPainter extends CustomPainter {
  final double value;
  final BuildContext context;

  PieChartPainter(this.value, this.context);

  @override
  void paint(Canvas canvas, Size size) {
    final double radius = size.width / 2;
    final Offset center = Offset(size.width / 2, size.height / 2);

    // Background Section (Always full circle)
    final backgroundPaint = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFF8348FF), Color(0xFFFF48A0)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(
        Rect.fromCircle(center: center, radius: radius),
      )
      ..style = PaintingStyle.stroke
      ..strokeWidth = 40;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      0,
      2 * pi,
      false,
      backgroundPaint,
    );

    // Foreground Section (Yellow Arc)
    final sweepAngle = value * 2 * pi;
    final foregroundPaint = Paint()
      ..shader = const LinearGradient(
        colors: [
          Color(0xFFFF961A),
          Color(0xFFFAFF17),
        ],
      ).createShader(
        Rect.fromCircle(center: center, radius: radius),
      )
      ..style = PaintingStyle.stroke
      ..strokeWidth = 41
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2, // Start at top center
      sweepAngle,
      false,
      foregroundPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true; // Перерисовка при изменении данных
  }
}
