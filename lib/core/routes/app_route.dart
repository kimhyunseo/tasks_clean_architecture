import 'package:go_router/go_router.dart';
import 'package:tasks/core/routes/app_routes.dart';
import 'package:tasks/ui/pages/detail/detail_page.dart';
import 'package:tasks/ui/pages/home/home_page.dart';

final router = GoRouter(
  initialLocation: AppRoutes.HomePage.absolutePath,
  routes: [
    GoRoute(
      path: AppRoutes.HomePage.path,
      name: AppRoutes.HomePage.name,
      builder: (context, state) => const HomePage(),
      routes: [
        GoRoute(
          path: AppRoutes.DetailPage.path,
          name: AppRoutes.DetailPage.name,
          builder: (context, state) {
            final id = state.pathParameters['id']!;
            return TodoDetailPage(id: id);
          },
        ),
      ],
    ),
  ],
);
