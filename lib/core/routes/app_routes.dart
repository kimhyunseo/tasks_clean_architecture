// ignore_for_file: constant_identifier_names

enum AppRoutes {
  HomePage(absolutePath: '/', path: '/', name: 'home'),
  DetailPage(absolutePath: '/detail/:id', path: 'detail/:id', name: 'detail');

  final String absolutePath;
  final String path;
  final String name;

  const AppRoutes({
    required this.absolutePath,
    required this.path,
    required this.name,
  });
}
