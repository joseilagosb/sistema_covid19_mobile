import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:flutter/cupertino.dart';
//****************************//
//****************************//
//**** TIPOS DE LUGARES ******//
//****************************//
//****************************//

const String PLACETYPE_SUPERMARKET = 'Supermercado';
const String PLACETYPE_PUBLICSERVICE = 'Servicio público';
const String PLACETYPE_BANK = 'Banco';
const String PLACETYPE_NOTARY = 'Notaría';
const String PLACETYPE_HEALTHCAREFACILITIES =
    'Establecimiento de salud pública';
const String PLACETYPE_DRUGSTORE = 'Farmacia';
const String PLACETYPE_HARDWARE = 'Ferretería';

class Constants {
  static const List<String> PLACE_TYPES = const [
    'Supermercado',
    'Servicio público',
    'Banco',
    'Notaría',
    'Establecimiento de salud pública',
    'Farmacia',
    'Ferretería',
  ];

  static const List<String> SERVICES = const [
    'Registro civil',
    'Retiro de dinero',
    'Artículos de aseo y seguridad personal',
    'Compra de alimentos',
    'Pago de servicios básicos (agua, luz, gas)',
    'Salvoconductos, permisos individuales o colectivos',
    'Compra de medicamentos'
  ];

  static Map<int, Color> COLOR_CODES = {
    50: Color.fromARGB(255, 255, 150, 30),
    100: Color.fromARGB(255, 255, 160, 55),
    200: Color.fromARGB(255, 255, 170, 80),
    300: Color.fromARGB(255, 255, 180, 105),
    400: Color.fromARGB(255, 255, 190, 130),
    500: Color.fromARGB(255, 255, 200, 155),
    600: Color.fromARGB(255, 255, 210, 180),
    700: Color.fromARGB(255, 255, 220, 205),
    800: Color.fromARGB(255, 255, 230, 220),
    900: Color.fromARGB(255, 255, 240, 235),
  };

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

  static const List<String> HOURS_OF_DAY = const [
    "0:00 a.m.",
    "1:00 a.m.",
    "2:00 a.m.",
    "3:00 a.m.",
    "4:00 a.m.",
    "5:00 a.m.",
    "6:00 a.m.",
    "7:00 a.m.",
    "8:00 a.m.",
    "9:00 a.m.",
    "10:00 a.m.",
    "11:00 a.m.",
    "12:00 p.m.",
    "1:00 p.m.",
    "2:00 p.m.",
    "3:00 p.m.",
    "4:00 p.m.",
    "5:00 p.m.",
    "6:00 p.m.",
    "7:00 p.m.",
    "8:00 p.m.",
    "9:00 p.m.",
    "10:00 p.m.",
    "11:00 p.m.",
  ];

  static const List<String> CROWD_RECOMENDATIONS_CATEGORIES = const [
    "Días de semana",
    "Fines de semana",
  ];

  //CATEGORIA DE AGLOMERACION
  static const int WEEKDAYS_CROWD_RECOMMENDATION = 0;
  static const int WEEKENDS_CROWD_RECOMMENDATION = 1;

  static const String GMAPS_DIRECTIONS_API_KEY =
      "AIzaSyDqmOGy0rN1jiM48zR2xXIqciydHxpTyXA";

  //TIPOS DE POLIGONO
  static const int POLYGON_PLACE = 0;
  static const int POLYGON_AREA = 1;

  //TIEMPOS DEL DIA
  static const int TIMEOFDAY_MORNING = 0;
  static const int TIMEOFDAY_AFTERNOON = 1;

  //TIPOS DE ENTRADA DE USUARIO
  static const int USERINPUT_TEXT = 0;
  static const int USERINPUT_RATING = 1;
  static const int USERINPUT_SLIDER = 2;
  static const int USERINPUT_NUMERIC = 3;

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

  //*** UBICACIÓN POR DEFECTO */
  static const LatLng DEFAULTLOCATION = LatLng(-40.577305, -73.131226);

  static const List<String> COVID_SAFETY_INDICATORS = const [
    "Distanciamiento social",
    "Disposición de alcohol gel",
    "Cantidad adecuada de personas en su interior"
  ];

  static const List<String> SERVICE_QUALITY_INDICATORS = const [
    "Seguridad en el local",
    "Capacidad de respuesta",
  ];

  static const String BACKEND_IP = "192.168.0.9";
  static const String BACKEND_PORT = "3000";
  static const String BACKEND_URI = "http://" + BACKEND_IP + ":" + BACKEND_PORT;
}

//****************************//
//****************************//
//**** TIPOS DE SERVICIOS ****//
//****************************//
//****************************//

const String SERVICETYPE_CIVILREGISTRY = 'Registro civil';
const String SERVICETYPE_CASHWITHDRAWAL = 'Retiro de dinero';
const String SERVICETYPE_GROCERIES = 'Compra de alimentos';
const String SERVICETYPE_TOILETRY = 'Artículos de aseo y seguridad personal';
const String SERVICETYPE_UTILITIES =
    'Pago de servicios básicos (agua, luz, gas)';
const String SERVICETYPE_SPECIALPERMITS =
    'Salvoconductos, permisos individuales o colectivos';
const String SERVICETYPE_MEDICATION = 'Compra de medicamentos';

//****************************//
//****************************//
//***** RANGOS HORARIOS ******//
//****************************//
//****************************//

const String TIMERANGE_0700 = '07:00-09:00';
const String TIMERANGE_0900 = '09:00-11:00';
const String TIMERANGE_1100 = '11:00-13:00';
const String TIMERANGE_1300 = '13:00-15:00';
const String TIMERANGE_1500 = '15:00-17:00';
const String TIMERANGE_1700 = '17:00-19:00';
const String TIMERANGE_1900 = '19:00-21:00';

//****************************//

const double DIALOG_PADDING = 16.0;
const double DIALOG_AVATAR_RADIUS = 66.0;
