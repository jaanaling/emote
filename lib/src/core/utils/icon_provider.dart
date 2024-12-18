enum IconProvider {
  splash(imageName: 'splash.png'),
  logo(imageName: 'logo.png'),
  coins(imageName: 'coins.png'),
  tip(imageName: 'tip.png'),
  achievements(imageName: 'achievements.png'),
  animals(imageName: 'animals.png'),
  books(imageName: 'books.png'),
  country(imageName: 'country.png'),
  first(imageName: 'first.png'),
  food(imageName: 'food.png'),
  heart(imageName: 'heart.png'),
  lose(imageName: 'lose.png'),
  movie(imageName: 'movie.png'),
  music(imageName: 'music.png'),
  score(imageName: 'score.png'),
  second(imageName: 'second.png'),
  stars(imageName: 'stars.png'),
  third(imageName: 'third.png'),
  win(imageName: 'win.png'),
  unknown(imageName: '');

  const IconProvider({
    required this.imageName,
  });

  final String imageName;
  static const _imageFolderPath = 'assets/images';

  String buildImageUrl() => '$_imageFolderPath/$imageName';
  static String buildImageByName(String name) => '$_imageFolderPath/$name';
}
