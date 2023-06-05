
//hemos creado estas clases con la web --> https://app.quicktype.io/
//para pasar del JSON recibido de la API THE MOVIEDB a una clase de Dart
//modificamos lo recibido usando --> https://app.quicktype.io/ a la que necesitemos
//ponemos la propiedad dates opcional, hemos cambiado el nombre the result por MovieMoviedb

import 'movie_moviedb.dart';

class MovieDbResponse {
    final Dates? dates;
    final int page;
    final List<MovieMovieDb> results;
    final int totalPages;
    final int totalResults;

    //cosntructor
    MovieDbResponse({
        required this.dates,
        required this.page,
        required this.results,
        required this.totalPages,
        required this.totalResults,
    });

    //se crea el metodo MovieDbResponse.fromJson automaticamente usando --> https://app.quicktype.io/
    //para crear una instancia de esta clase MovieDbResponse y pasarle los valores a los argumentos traidos del Json
    factory MovieDbResponse.fromJson(Map<String, dynamic> json) => MovieDbResponse(
        dates: json["dates"] != null ? Dates.fromJson(json["dates"]) : null,
        page: json["page"],
        results: List<MovieMovieDb>.from(json["results"].map((x) => MovieMovieDb.fromJson(x))),
        totalPages: json["total_pages"],
        totalResults: json["total_results"],
    );

    //pasar a Json
    Map<String, dynamic> toJson() => {
        "dates": dates == null ? null : dates!.toJson(),
        "page": page,
        "results": List<dynamic>.from(results.map((x) => x.toJson())),
        "total_pages": totalPages,
        "total_results": totalResults,
    };
}

class Dates {
    final DateTime maximum;
    final DateTime minimum;

    Dates({
        required this.maximum,
        required this.minimum,
    });

    factory Dates.fromJson(Map<String, dynamic> json) => Dates(
        maximum: DateTime.parse(json["maximum"]),
        minimum: DateTime.parse(json["minimum"]),
    );

    Map<String, dynamic> toJson() => {
        "maximum": "${maximum.year.toString().padLeft(4, '0')}-${maximum.month.toString().padLeft(2, '0')}-${maximum.day.toString().padLeft(2, '0')}",
        "minimum": "${minimum.year.toString().padLeft(4, '0')}-${minimum.month.toString().padLeft(2, '0')}-${minimum.day.toString().padLeft(2, '0')}",
    };
}

