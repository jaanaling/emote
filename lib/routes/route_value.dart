enum RouteValue {
   splash(
    path: '/',
  ),
  home(
    path: '/home',
  ),
  dayli(
    path: 'dayli',
  ),
  create(
    path: 'create',
  ),
  achievements(
    path: 'achievements',
  ),
  level(
    path: 'level',
  ),
  quiz(
    path: 'quiz',
  ),
  privicy(path: 'privicy'),

  unknown(
    path: '',
  );

  final String path;
  const RouteValue({
    required this.path,
  });
}
