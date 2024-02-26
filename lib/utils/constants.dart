class Constants {
  static const List<String> RATING_OPTIONS = const [
    "Deficiente",
    "Malo",
    "Regular",
    "Bueno",
    "Excelente"
  ];

  static const List<String> DAYS_OF_WEEK = const [
    "Lunes",
    "Martes",
    "Miércoles",
    "Jueves",
    "Viernes",
    "Sábado",
    "Domingo"
  ];

  //CATEGORIA DE AGLOMERACION
  static const int WEEKDAYS_CROWD_RECOMMENDATION = 0;
  static const int WEEKENDS_CROWD_RECOMMENDATION = 1;

  //TIEMPOS DEL DIA
  static const int TIMEOFDAY_MORNING = 0;
  static const int TIMEOFDAY_AFTERNOON = 1;

  //**** TIPOS DE OPCION EN PROGRAMADOR DE VIAJES  ****//

  static const int TRAVELSCHEDULEROPTION_PLACETYPE = 0;
  static const int TRAVELSCHEDULEROPTION_SERVICETYPE = 1;

  //*** TIPOS DE TRANSPORTE */
  static const int TRANSPORTTYPE_WALKING = 0;
  static const int TRANSPORTTYPE_BIKE = 1;
  static const int TRANSPORTTYPE_VEHICLE = 2;

  //*** OPCIONES DE VISUALIZACIÓN DE INFO EN EL MAPA */
  static const int MAPSELECTEDMAPINFO_CROWDS = 0;
  static const int MAPSELECTEDMAPINFO_QUEUES = 1;
  static const int MAPSELECTEDMAPINFO_SAFETY = 2;

  static const List<String> COVID_SAFETY_INDICATORS = const [
    "Distanciamiento social",
    "Disposición de alcohol gel",
    "Cantidad adecuada de personas en su interior"
  ];

  static const List<String> SERVICE_QUALITY_INDICATORS = const [
    "Seguridad en el local",
    "Capacidad de respuesta",
  ];
}
