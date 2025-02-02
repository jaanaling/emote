import 'dart:math';
import 'package:emote_this/routes/go_router_config.dart';
import 'package:emote_this/routes/route_value.dart';
import 'package:emote_this/src/core/utils/size_utils.dart';
import 'package:emote_this/ui_kit/app_bar.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import '../../../core/utils/app_icon.dart';
import '../../../core/utils/icon_provider.dart';
import '../bloc/game_bloc.dart';
import 'package:webview_flutter/webview_flutter.dart';

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
                            isHomeScreen: true,
                          ),
                          Text(
                            '$score\nSCORE',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: isIpad(context) ? 36 : 26,
                                height: 0.95),
                          )
                        ],
                      ),
                      const Gap(75),
                      Text(
                        'FAVORITE CATEGORY',
                        style: TextStyle(fontSize: isIpad(context) ? 40 : 30),
                      ),
                      Container(
                        width: isIpad(context) ? 311 : 211,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                                color: const Color(0xFFE2E2E2), width: 2),
                            borderRadius: BorderRadius.circular(22)),
                        child: Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 7),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                if (favoriteCategory != 'Unknown')
                                  _getIconByCategory(favoriteCategory),
                                Text(
                                  favoriteCategory,
                                  style: TextStyle(
                                      color: Color(0xFFFF48A0),
                                      fontSize: isIpad(context) ? 30 : null),
                                ),
                              ],
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
                            width: isIpad(context) ? 350 : 250,
                            height: isIpad(context) ? 74 : 37,
                            child: Center(
                              child: Text(
                                'Select level',
                                style: TextStyle(
                                  fontSize: isIpad(context) ? 30 : 20,
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
                            width: isIpad(context) ? 350 : 250,
                            height: isIpad(context) ? 74 : 37,
                            child: Center(
                              child: Text(
                                'Random riddle',
                                style: TextStyle(
                                  fontSize: isIpad(context) ? 30 : 20,
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
                            width: isIpad(context) ? 350 : 250,
                            height: isIpad(context) ? 74 : 37,
                            child: Center(
                              child: Text(
                                'Everyday riddle',
                                style: TextStyle(
                                  fontSize: isIpad(context) ? 30 : 20,
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
                            context.push(
                                "${RouteValue.home.path}/${RouteValue.create.path}");
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFFF48A0),
                              elevation: 0,
                              padding: EdgeInsets.zero),
                          child: SizedBox(
                            width: isIpad(context) ? 350 : 250,
                            height: isIpad(context) ? 74 : 37,
                            child: Center(
                              child: Text(
                                'Create riddle',
                                style: TextStyle(
                                  fontSize: isIpad(context) ? 30 : 20,
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

Widget _getIconByCategory(String category) {
  switch (category) {
    case 'Movies & TV':
      return AppIcon(
        asset: IconProvider.movie.buildImageUrl(),
        width: 24,
        height: 28,
      );
    case 'Fairy tales & literature':
      return AppIcon(
        asset: IconProvider.books.buildImageUrl(),
        width: 30,
        height: 26,
      );
    case 'Songs & Musicians':
      return AppIcon(
        asset: IconProvider.music.buildImageUrl(),
        width: 27,
        height: 25,
      );
    case 'Food & Drinks':
      return AppIcon(
        asset: IconProvider.food.buildImageUrl(),
        width: 26,
        height: 27,
      );
    case 'Animals & Nature':
      return AppIcon(
        asset: IconProvider.animals.buildImageUrl(),
        width: 25.14,
        height: 25.54,
      );
    case 'Celebrities & historical figures':
      return AppIcon(
        asset: IconProvider.stars.buildImageUrl(),
        width: 13,
        height: 30,
      );
  }
  return AppIcon(
    asset: IconProvider.country.buildImageUrl(),
    width: 36,
    height: 36,
  );
}

class RoundedPieChart extends StatefulWidget {
  final double value;
  final bool isHomeScreen;

  const RoundedPieChart(
      {Key? key, required this.value, this.isHomeScreen = false})
      : super(key: key);

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
          size: isIpad(context) && widget.isHomeScreen
              ? Size(460, 460)
              : Size(230, 230),
          painter: PieChartPainter(_animation.value, context,
              isHomeScreen: widget.isHomeScreen),
        );
      },
    );
  }
}

class PieChartPainter extends CustomPainter {
  final double value;
  final BuildContext context;
  final bool isHomeScreen;

  PieChartPainter(this.value, this.context, {this.isHomeScreen = false});

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
      ..strokeWidth = isIpad(context) && isHomeScreen ? 80 : 40;

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
      ..strokeWidth = isIpad(context) && isHomeScreen ? 81 : 41
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

class PrivicyScreen extends StatefulWidget {
  const PrivicyScreen({super.key});

  @override
  State<PrivicyScreen> createState() => _PrivicyScreenState();
}

class _PrivicyScreenState extends State<PrivicyScreen> {
  late final WebViewController _controller;
  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        systemNavigationBarColor: CupertinoColors.black,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    );

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted);
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: Colors.white,
      child: Column(
        children: [
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: Row(children: [
                Gap(15),
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        context.pop();
                      },
                      borderRadius: BorderRadius.circular(32),
                      child: const Icon(
                        CupertinoIcons.arrowtriangle_left_circle_fill,
                        color: Colors.black,
                        size: 34,
                      ),
                    ),
                  ),
                ),
                Spacer(),
                Text('Privacy Policy'),
                Spacer(),
              ],),
            ),
          ),
          Expanded(
            child: WebViewWidget(
              controller: _controller
                ..loadRequest(Uri.parse("https://emotethis.com/privacy"))
                ..setBackgroundColor(
                  Colors.orange,
                ),
            ),
          ),
        ],
      ),
    );
  }
}
