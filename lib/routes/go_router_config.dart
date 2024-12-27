import 'package:core_logic/core_logic.dart';
import 'package:emote_this/src/feature/game/presentation/achievements_screen.dart';
import 'package:emote_this/src/feature/game/presentation/create_screen.dart';
import 'package:emote_this/src/feature/game/presentation/home_screen.dart';
import 'package:emote_this/src/feature/game/presentation/level_screen.dart';
import 'package:emote_this/src/feature/game/presentation/quiz_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

import '../src/feature/splash/presentation/screens/splash_screen.dart';
import 'root_navigation_screen.dart';
import 'route_value.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _homeNavigatorKey = GlobalKey<NavigatorState>();
final _catalogNavigatorKey = GlobalKey<NavigatorState>();
final _diaryNavigatorKey = GlobalKey<NavigatorState>();
final _generatorNavigatorKey = GlobalKey<NavigatorState>();

final _shellNavigatorKey = GlobalKey<NavigatorState>();

GoRouter buildGoRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: RouteValue.splash.path,
  routes: <RouteBase>[
    StatefulShellRoute.indexedStack(
      pageBuilder: (context, state, navigationShell) {
        return NoTransitionPage(
          child: RootNavigationScreen(
            navigationShell: navigationShell,
          ),
        );
      },
      branches: [
        StatefulShellBranch(
          navigatorKey: _homeNavigatorKey,
          routes: <RouteBase>[
            GoRoute(
              path: RouteValue.home.path,
              builder: (BuildContext context, GoRouterState state) {
                return HomeScreen();
              },
              routes: [
                GoRoute(
                  path: RouteValue.achievements.path,
                  builder: (BuildContext context, GoRouterState state) {
                    return AchievementsScreen();
                  },
                ),
                GoRoute(
                  path: RouteValue.dayli.path,
                  builder: (BuildContext context, GoRouterState state) {
                    return QuizScreen(
                      puzzleId: state.extra as int,
                    );
                  },
                ),
                GoRoute(
                  path: RouteValue.create.path,
                  builder: (BuildContext context, GoRouterState state) {
                    return CreateScreen();
                  },
                ),
                GoRoute(
                  path: RouteValue.level.path,
                  builder: (BuildContext context, GoRouterState state) {
                    return LevelScreen(
                      levelId: state.extra as int,
                    );
                  },
                  routes: [
                    GoRoute(
                      path: RouteValue.quiz.path,
                      builder: (
                        BuildContext context,
                        GoRouterState state,
                      ) {
                        return QuizScreen(
                          puzzleId: state.extra as int,
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ],
    ),
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      pageBuilder: (context, state, child) {
        return NoTransitionPage(
          child: CupertinoPageScaffold(
            backgroundColor: CupertinoColors.black,
            child: child,
          ),
        );
      },
      routes: <RouteBase>[
        GoRoute(
          path: RouteValue.splash.path,
          builder: (BuildContext context, GoRouterState state) {
            return const SplashScreen();
          },
        ),
      ],
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: '/core',
      pageBuilder: (context, state) {
        return NoTransitionPage(
          child: CoreScreen(
            key: UniqueKey(),
          ),
        );
      },
    ),
  ],
);
