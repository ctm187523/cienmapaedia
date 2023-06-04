
//hemos creado estas clases con la web --> https://app.quicktype.io/
//para pasar del JSON recibido de la API THE MOVIEDB a una clase de Dart
//modificamos lo recibido usando --> https://app.quicktype.io/ a la que necesitemos
//hemos cambiado el nombre the result original de la Api por MovieMoviedb

class MovieMovieDb {
    final bool adult;
    final String backdropPath;
    final List<int> genreIds;
    final int id;
    final String originalLanguage;
    final String originalTitle;
    final String overview;
    final double popularity;
    final String posterPath;
    final DateTime releaseDate;
    final String title;
    final bool video;
    final double voteAverage;
    final int voteCount;

    //constructor
    MovieMovieDb({
        required this.adult,
        required this.backdropPath,
        required this.genreIds,
        required this.id,
        required this.originalLanguage,
        required this.originalTitle,
        required this.overview,
        required this.popularity,
        required this.posterPath,
        required this.releaseDate,
        required this.title,
        required this.video,
        required this.voteAverage,
        required this.voteCount,
    });

    factory MovieMovieDb.fromJson(Map<String, dynamic> json) => MovieMovieDb(
        adult: json["adult"] ?? false, //si no viene lo ponemos en false
        backdropPath: json["backdrop_path"] ?? '', //ponemos que puede no venir la data si no viene es un String vacio
        genreIds: List<int>.from(json["genre_ids"].map((x) => x)),
        id: json["id"],
        originalLanguage: json["original_language"],
        originalTitle: json["original_title"],
        overview: json["overview"] ?? '', //ponemos que puede no venir la data si no viene es un String vacio
        popularity: json["popularity"]?.toDouble(),
        posterPath: json["poster_path"] ?? '', //ponemos que puede no venir la data si no viene es un String vacio
        releaseDate: DateTime.parse(json["release_date"]),
        title: json["title"],
        video: json["video"],
        voteAverage: json["vote_average"]?.toDouble(),
        voteCount: json["vote_count"],
    );

    //pasar a Json
    Map<String, dynamic> toJson() => {
        "adult": adult,
        "backdrop_path": backdropPath,
        "genre_ids": List<dynamic>.from(genreIds.map((x) => x)),
        "id": id,
        "original_language": originalLanguage,
        "original_title": originalTitle,
        "overview": overview,
        "popularity": popularity,
        "poster_path": posterPath,
        "release_date": "${releaseDate.year.toString().padLeft(4, '0')}-${releaseDate.month.toString().padLeft(2, '0')}-${releaseDate.day.toString().padLeft(2, '0')}",
        "title": title,
        "video": video,
        "vote_average": voteAverage,
        "vote_count": voteCount,
    };
}
