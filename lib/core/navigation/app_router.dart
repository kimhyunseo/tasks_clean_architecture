import 'package:go_router/go_router.dart';
import 'package:tasks/ui/pages/detail/detail_page.dart';
import 'package:tasks/ui/pages/home/home_page.dart';

final router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => const HomePage()),

    GoRoute(
      path: '/detail/:id',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return TodoDetailPage(id: id);
      },
    ),
  ],
);
