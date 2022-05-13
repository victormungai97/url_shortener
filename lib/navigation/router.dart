part of 'navigator.dart';

final router = GoRouter(
  routes: <GoRoute>[
    GoRoute(
      path: Routes.root,
      builder: (context, GoRouterState state) => const HomeScreen(),
    ),
    GoRoute(
      path: Routes.home,
      builder: (context, GoRouterState state) => const HomeScreen(),
    ),
  ],
  initialLocation: Routes.root,
);
